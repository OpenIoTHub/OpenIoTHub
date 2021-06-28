import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub/util/InitAllConfig.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_constants/constants/WeChatConfig.dart';
import 'package:wechat_kit/wechat_kit.dart';

Future<void> init(){
  initBackgroundService();
  initHttpAssets();
  initWechat();
  initSystemUi();
}

Future<void> initBackgroundService(){
  FlutterNatcloudService.start().then((String value) {
    // Fluttertoast.showToast(msg: "FlutterNatcloudService.start()：$value}");
  });
  Future.delayed(Duration(seconds: 1), () {
    InitAllConfig();
  });
}

Future<void> initHttpAssets(){
  final server =
  Jaguar(address: Config.webStaticIp, port: Config.webStaticPort);
  server.addRoute(serveFlutterAssets());
  server.serve(logRequests: true).then((v) {
    server.log.onRecord.listen((r) => debugPrint("==serve-log：$r"));
  });
}

Future<void> initWechat(){
  // 初始化wechat_kit
  Wechat.instance.registerApp(
    appId: WeChatConfig.WECHAT_APPID,
    universalLink: WeChatConfig.WECHAT_UNIVERSAL_LINK,
  );
}

Future<void> initSystemUi(){
  //安卓透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
