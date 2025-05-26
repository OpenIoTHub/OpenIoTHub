import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtads/gtads.dart';
import 'package:gtads_csj/gtads_csj.dart';
import 'package:gtads_ylh/gtads_ylh.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub/util/check/check.dart' as check;
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_mobile_service/openiothub_mobile_service.dart'
as openiothub_mobile_service;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_kit/wechat_kit.dart';
// import 'package:workmanager/workmanager.dart';

import 'configs/consts.dart';

List<Map<String, bool>>? initList;

Future<void> init() async {
  initBackgroundService();
  try{
    await initAD();
  }catch (e) {
    print(e);
  }
  initHttpAssets();
  initWechat();
  initQQ();
  // initSystemUi();
  loadConfig();
  // setWindowSize();
}

// @pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print("Native called background task: $task"); //simpleTask will be emitted here.
//     openiothub_mobile_service.run();
//     // while (true) {
//     //   Future.delayed(Duration(seconds: 2000000), () {
//     //     print('2秒后执行');
//     //   });
//     // }
//     await Future<void>.delayed(Duration(seconds: 60*20));
//     print("Native called background task: $task end");
//     return Future.value(true);
//   });
// }
//
// Future<void> initBackgroundService2() async {
//   Workmanager().initialize(
//       callbackDispatcher, // The top level function, aka callbackDispatcher
//       isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
//   );
//   Workmanager().registerOneOffTask("task-identifier", "simpleTask");
// }

void run(dynamic) {
  openiothub_mobile_service.run();
}

Future<void> initBackgroundService() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool("foreground", true);
  Isolate.spawn(run, null);
}

Future<void> initHttpAssets() async {
  final server =
      Jaguar(address: Config.webStaticIp, port: Config.webStaticPort);
  server.addRoute(serveFlutterAssets());
  server.serve(logRequests: true).then((v) {
    server.log.onRecord.listen((r) => debugPrint("==serve-log：$r"));
  });
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
      systemNavigationBarColor: Colors.transparent);
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
  CnameManager.LoadAllCnameFromRemote().then((_) => {
        UserManager.GetAllConfig().then((StringValue config) => {
              UtilApi.Ping()
                  .then((_) => {UtilApi.SyncConfigWithJsonConfig(config.value)})
            })
      });
  // TODO 通知UI进行刷新
}

Future setWindowSize() async {
  Size size = await DesktopWindow.getWindowSize();
  print("windows size:$size");
  await DesktopWindow.setWindowSize(Size(500, 500));
}

Future initAD() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(Platform.isAndroid && (!prefs.containsKey(Agreed_Privacy_Policy) || !(prefs.getBool(Agreed_Privacy_Policy)!))){
    return;
  }
  //添加Provider列表
  GTAds.addProviders([
    GTAdsCsjProvider("csj", "5695020", "5695009", appName: "云亿连"),
    GTAdsYlhProvider("ylh", "1210892167", "1210892181")
  ]);
  initList = await GTAds.init(isDebug: true);
}
