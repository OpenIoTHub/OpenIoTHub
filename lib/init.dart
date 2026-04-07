import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub/service/internal_plugin_service.dart';
import 'package:openiothub/utils/check_auth.dart' as check;
import 'package:openiothub/ads/openiothub_ads.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_mobile_service/openiothub_mobile_service.dart'
    as openiothub_mobile_service;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wechat_kit/wechat_kit.dart';
// import 'package:workmanager/workmanager.dart';

// import 'configs/consts.dart';

List<Map<String, bool>>? initList;

Future<void> init() async {
  initBackgroundService();
  initForegroundService();
  initWakeLockService();
  try {
    await initAD();
  } catch (e) {
    debugPrint('initAD: $e');
  }
  initHttpAssets();
  initWechat();
  initQQ();
  // initSystemUi();
  unawaited(Future.delayed(const Duration(milliseconds: 10), () {
    loadConfig();
    initGatewayService();
  }));
  // setWindowSize();
}

void run(dynamic) {
  openiothub_mobile_service.run();
}

Future<void> initBackgroundService() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool("foreground", true);
  Isolate.spawn(run, null);
}

Future<void> initHttpAssets() async {
  try {
    final server = Jaguar(
      address: Config.webStaticIp,
      port: Config.webStaticPort,
    );
    server.addRoute(serveFlutterAssets());
    await server.serve(logRequests: true);
    server.log.onRecord.listen((r) => debugPrint('==serve-log：$r'));
  } catch (e) {
    debugPrint('initHttpAssets: $e');
  }
}

Future<void> initWechat() async {
  bool agreed = await check.agreedPrivacyPolicy();
  // 如果同意了隐私政策或者不是安卓平台则初始化wechat_kit
  if (agreed || Platform.isIOS) {
    WechatKitPlatform.instance.registerApp(
      appId: WeChatConfig.wechatAppId,
      universalLink: WeChatConfig.wechatUniversalLink,
    );
  }
}

Future<void> initQQ() async {
  // bool agreed = await agreedPrivacyPolicy();
  // // 如果同意了隐私政策或者不是安卓平台则初始化wechat_kit
  // if (agreed || Platform.isIOS) {
  //   await TencentKitPlatform.instance.setIsPermissionGranted(granted: true);
  //   await TencentKitPlatform.instance.registerApp(
  //         appId: QQConfig.qqAppId, universalLink: QQConfig.qqUniversalLink);
  // }
}

Future<void> initSystemUi() async {
  // SystemChrome.setEnabledSystemUIMode([SystemUiOverlay.top] as SystemUiMode);
  //安卓透明状态栏
  // if (Platform.isAndroid) {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // 导航栏下面的控制栏的颜色
    systemNavigationBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // }
}

Future<void> loadConfig() async {
  if (!(await check.userSignedIn())) {
    return;
  }
  // 异步拉取配置与云端别名；别名写入本地后由 [CnameRefreshSignal] 通知列表刷新展示名。
  unawaited(_loadConfigChain());
}

Future<void> _loadConfigChain() async {
  try {
    await CnameManager.loadAllCnameFromRemote();
    final StringValue config = await UserManager.getAllConfig();
    await UtilApi.ping();
    await UtilApi.syncConfigWithJsonConfig(config.value);
  } catch (e, stackTrace) {
    debugPrint('loadConfig: $e');
    debugPrint('$stackTrace');
  }
}

Future<void> setWindowSize() async {
  Size size = await DesktopWindow.getWindowSize();
  debugPrint("windows size:$size");
  await DesktopWindow.setWindowSize(Size(500, 500));
}

Future<void> initAD() async {
  if (!Platform.isAndroid && !Platform.isIOS) {
    return;
  }
  initList = await initGTADsAD();
}

Future<void> initForegroundService() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? forgeRound = prefs.getBool(SharedPreferencesKey.forgeRoundTaskEnable);
  try {
    if (Platform.isAndroid && forgeRound != null && forgeRound) {
      InternalPluginService.instance.init();
      InternalPluginService.instance.start();
      // 唤醒锁
      WakelockPlus.enable();
    } else {
      InternalPluginService.instance.stop();
      WakelockPlus.disable();
    }
  } catch (e) {
    debugPrint('initForegroundService: $e');
  }
}

Future<void> initGatewayService() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? autoStartGateway = prefs.getBool(SharedPreferencesKey.startGatewayWhenAppStart);
  try {
    if (autoStartGateway == null || autoStartGateway) {
      if (prefs.containsKey(SharedPreferencesKey.gatewayJwtKey) &&
          prefs.containsKey(SharedPreferencesKey.qrCodeForMobileAddKey)) {
        var gatewayJwt = prefs.getString(SharedPreferencesKey.gatewayJwtKey)!;
        await GatewayLoginManager.loginServerByToken(
          gatewayJwt,
          Config.gatewayGrpcIp,
          Config.gatewayGrpcPort,
        );
      }
    }
  } catch (e) {
    debugPrint('initGatewayService: $e');
  }
}

Future<void> initWakeLockService() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? wakeLockEnabled = prefs.getBool(SharedPreferencesKey.wakeLockEnabled);
  try {
    if (wakeLockEnabled != null) {
      WakelockPlus.toggle(enable: wakeLockEnabled);
    }
  } catch (e) {
    debugPrint('initWakeLockService: $e');
  }
}
