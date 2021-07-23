import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub_api/api/OpenIoTHub/Utils.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_constants/constants/WeChatConfig.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'package:openiothub_grpc_api/pb/service.pb.dart';

Future<void> init(){
  initBackgroundService();
  initHttpAssets();
  initWechat();
  initSystemUi();
  loadConfig();
}

Future<void> initBackgroundService() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool("foreground", true);
  FlutterNatcloudService.start().then((String value) {
    // Fluttertoast.showToast(msg: "FlutterNatcloudService.start()：$value}");
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

Future<void> loadConfig(){
  Future.delayed(Duration(milliseconds: 500), () {
    UtilApi.SyncConfigWithToken().then((OpenIoTHubOperationResponse rsp) {
      // Fluttertoast.showToast(msg: rsp.msg);
    });
  });
}
