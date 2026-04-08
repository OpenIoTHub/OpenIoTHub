import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub/app/service/internal_plugin_service.dart';
import 'package:openiothub/utils/app/check_auth.dart' as check;
import 'package:openiothub/ads/openiothub_ads.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_mobile_service/openiothub_mobile_service.dart'
    as openiothub_mobile_service;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wechat_kit/wechat_kit.dart';
// import 'package:workmanager/workmanager.dart';

// import 'configs/consts.dart';

List<Map<String, bool>>? initList;

Future<void> init() async {
  await initBackgroundService();
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

/// 同一 Android 进程内若因前台服务等未退出而再次执行 [main]，不得重复 [Isolate.spawn] 调用原生
/// [openiothub_mobile_service.run]，否则 Go 层易崩溃，表现为再次点开图标闪退。
@pragma('vm:entry-point')
void openIoTHubMobileServiceIsolateEntry(Object? message) {
  RandomAccessFile? raf;
  if (message is String && message.isNotEmpty) {
    try {
      final file = File(message);
      file.parent.createSync(recursive: true);
      raf = file.openSync(mode: FileMode.write);
      raf.lockSync(FileLock.exclusive);
      debugPrint(
        '[OpenIoTHub][mobile_isolate] acquired lock, starting native Run()',
      );
    } catch (e) {
      debugPrint(
        '[OpenIoTHub][mobile_isolate] lock held by existing isolate, skip Run(): $e',
      );
      try {
        raf?.closeSync();
      } catch (_) {}
      return;
    }
  }
  openiothub_mobile_service.run();
}

Future<void> initBackgroundService() async {
  try {
    if (Platform.isAndroid) {
      final Directory dir = await getTemporaryDirectory();
      final String lockPath = '${dir.path}/openiothub_mobile_service.lock';
      await Isolate.spawn(openIoTHubMobileServiceIsolateEntry, lockPath);
    } else {
      await Isolate.spawn(openIoTHubMobileServiceIsolateEntry, null);
    }
  } catch (e, st) {
    debugPrint('initBackgroundService: $e\n$st');
  }
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

/// 仅做插件初始化与「关闭时」清理：前台服务在应用进入后台时再启动，回到前台或进程结束时停止，
/// 避免用户退出应用后通知仍残留、需再次打开才消失的问题。
Future<void> initForegroundService() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? forgeRound = prefs.getBool(SharedPreferencesKey.forgeRoundTaskEnable);
  try {
    if (Platform.isAndroid && forgeRound != null && forgeRound) {
      InternalPluginService.instance.init();
    } else {
      await InternalPluginService.instance.stop();
    }
    await _syncWakeLockWithPrefs(prefs);
  } catch (e) {
    debugPrint('initForegroundService: $e');
  }
}

Future<void> _syncWakeLockWithPrefs(SharedPreferences prefs) async {
  final bool? wakeLockEnabled = prefs.getBool(SharedPreferencesKey.wakeLockEnabled);
  WakelockPlus.toggle(enable: wakeLockEnabled == true);
}

/// Android：开启「前台保活」时，仅在进入后台时启动前台服务，回到前台时停止；
/// [AppLifecycleState.detached] 时无论开关如何都尝试停止服务，避免进程结束后通知残留。
Future<void> handleAndroidForegroundServiceLifecycle(AppLifecycleState state) async {
  if (!Platform.isAndroid) {
    return;
  }

  debugPrint('[OpenIoTHub][lifecycle] $state');

  if (state == AppLifecycleState.detached) {
    try {
      final bool running = await InternalPluginService.instance.isRunningService;
      debugPrint('[OpenIoTHub][lifecycle] detached, isRunningService=$running');
      if (running) {
        await InternalPluginService.instance.stop();
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await _syncWakeLockWithPrefs(prefs);
    } catch (e) {
      debugPrint('handleAndroidForegroundServiceLifecycle detached: $e');
    }
    return;
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool forgeRound =
      prefs.getBool(SharedPreferencesKey.forgeRoundTaskEnable) == true;
  if (!forgeRound) {
    debugPrint('[OpenIoTHub][lifecycle] forgeRound off, skip FGS sync');
    return;
  }

  try {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        debugPrint('[OpenIoTHub][lifecycle] background -> start FGS if needed');
        InternalPluginService.instance.init();
        if (!await InternalPluginService.instance.isRunningService) {
          await InternalPluginService.instance.start();
        }
        WakelockPlus.enable();
        break;
      case AppLifecycleState.resumed:
        debugPrint('[OpenIoTHub][lifecycle] resumed -> stop FGS if running');
        if (await InternalPluginService.instance.isRunningService) {
          await InternalPluginService.instance.stop();
        }
        await _syncWakeLockWithPrefs(prefs);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        break;
    }
  } catch (e) {
    debugPrint('handleAndroidForegroundServiceLifecycle: $e');
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
