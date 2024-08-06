import 'dart:async';
import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub/util/check/check.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_mobile_service/openiothub_mobile_service.dart' as openiothub_mobile_service;
import 'package:tencent_kit/tencent_kit.dart';
import 'package:wechat_kit/wechat_kit.dart';

Future<void> init() async {
  // initBackgroundService();
  initHttpAssets();
  initWechat();
  initQQ();
  // initSystemUi();
  loadConfig();
  // setWindowSize();
}

Future<void> initBackgroundService() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool("foreground", true);
  openiothub_mobile_service.run();
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
  bool agreed = await agreedPrivacyPolicy();
  // 如果同意了隐私政策或者不是安卓平台则初始化wechat_kit
  if (agreed || Platform.isIOS) {
    WechatKitPlatform.instance.registerApp(
      appId: WeChatConfig.WECHAT_APPID,
      universalLink: WeChatConfig.WECHAT_UNIVERSAL_LINK,
    );
  }
}

Future<void> initQQ() async {
  bool agreed = await agreedPrivacyPolicy();
  // 如果同意了隐私政策或者不是安卓平台则初始化wechat_kit
  if (agreed || Platform.isIOS) {
    await TencentKitPlatform.instance.setIsPermissionGranted(granted: true);
    await TencentKitPlatform.instance.registerApp(
          appId: QQConfig.QQ_APPID, universalLink: QQConfig.QQ_UNIVERSAL_LINK);
  }
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
