import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub/service/internal_plugin_service.dart';
import 'package:openiothub/utils/check/check.dart' as check;
import 'package:openiothub_ads/openiothub_ads.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
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
    print(e);
  }
  initHttpAssets();
  initWechat();
  initQQ();
  // initSystemUi();
  Future.delayed(Duration(milliseconds: 10),(){
    loadConfig();
    initGatewayService();
  });
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
    server.serve(logRequests: true).then((v) {
      server.log.onRecord.listen((r) => debugPrint("==serve-log：$r"));
    });
  } catch (e) {}
}

Future<void> initWechat() async {
  bool agreed = await check.agreedPrivacyPolicy();
  // 如果同意了隐私政策或者不是安卓平台则初始化wechat_kit
  if (agreed || Platform.isIOS) {
    WechatKitPlatform.instance.registerApp(
      appId: WeChatConfig.WECHAT_APPID,
      universalLink: WeChatConfig.WECHAT_UNIVERSAL_LINK,
    );
  }
}

Future<void> initQQ() async {
  // bool agreed = await agreedPrivacyPolicy();
  // // 如果同意了隐私政策或者不是安卓平台则初始化wechat_kit
  // if (agreed || Platform.isIOS) {
  //   await TencentKitPlatform.instance.setIsPermissionGranted(granted: true);
  //   await TencentKitPlatform.instance.registerApp(
  //         appId: QQConfig.QQ_APPID, universalLink: QQConfig.QQ_UNIVERSAL_LINK);
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
  // Future.delayed(const Duration(milliseconds: 500), () {
  //   UtilApi.SyncConfigWithToken().then((OpenIoTHubOperationResponse rsp) {
  //     // showToast( rsp.msg);
  //   });
  // });
  // CnameManager.LoadAllCnameFromRemote();
  // TODO 后面也可以定时同步
  CnameManager.LoadAllCnameFromRemote().then(
    (_) => {
      UserManager.GetAllConfig().then(
        (StringValue config) => {
          UtilApi.Ping().then(
            (_) => {UtilApi.SyncConfigWithJsonConfig(config.value)},
          ),
        },
      ),
    },
  );
  // TODO 通知UI进行刷新
}

Future setWindowSize() async {
  Size size = await DesktopWindow.getWindowSize();
  print("windows size:$size");
  await DesktopWindow.setWindowSize(Size(500, 500));
}

Future initAD() async {
  if (!Platform.isAndroid && !Platform.isIOS){
    return;
  }
  initList = await initGTADsAD();
}

Future initForegroundService() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? forgeRound = prefs.getBool(SharedPreferencesKey.FORGE_ROUND_TASK_ENABLE);
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
    print(e);
  }
}

Future initGatewayService() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? autoStartGateway = prefs.getBool(SharedPreferencesKey.START_GATEWAY_WHEN_APP_START);
  try {
    if (autoStartGateway == null || autoStartGateway) {
      if (prefs.containsKey(SharedPreferencesKey.Gateway_Jwt_KEY) &&
          prefs.containsKey(SharedPreferencesKey.QR_Code_For_Mobile_Add_KEY)) {
        var gatewayJwt = prefs.getString(SharedPreferencesKey.Gateway_Jwt_KEY)!;
        await GatewayLoginManager.LoginServerByToken(
          gatewayJwt,
          Config.gatewayGrpcIp,
          Config.gatewayGrpcPort,
        );
      }
    }
  } catch (e) {
    print(e);
  }
}

Future initWakeLockService() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? wakeLockEnabled = prefs.getBool(SharedPreferencesKey.WAKE_LOCK);
  try {
    if (wakeLockEnabled != null) {
      WakelockPlus.toggle(enable: wakeLockEnabled);
    }
  } catch (e) {
    print(e);
  }
}
