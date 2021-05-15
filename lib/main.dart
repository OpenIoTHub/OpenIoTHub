import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/pages/splashPage/splashPage.dart';
import 'package:openiothub/util/InitAllConfig.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_constants/constants/WeChatConfig.dart';
import 'package:provider/provider.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'package:openiothub/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomTheme()),
      ],
      child: MyApp(),
    ),
    // MyApp()
  );
  FlutterNatcloudService.start().then((String value) {
    // Fluttertoast.showToast(msg: "FlutterNatcloudService.start()：$value}");
  });
  Future.delayed(Duration(seconds: 1), () {
    InitAllConfig();
  });
  final server =
      Jaguar(address: Config.webStaticIp, port: Config.webStaticPort);
  server.addRoute(serveFlutterAssets());
  server.serve(logRequests: true).then((v) {
    server.log.onRecord.listen((r) => debugPrint("==serve-log：$r"));
  });
  // 初始化wechat_kit
  Wechat.instance.registerApp(
    appId: WeChatConfig.WECHAT_APPID,
    universalLink: WeChatConfig.WECHAT_UNIVERSAL_LINK,
  );
  //安卓透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "OpenIoTHub",
        theme: CustomThemes.light,
        darkTheme: CustomThemes.dark,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeListResolutionCallback: (locales, supportedLocales) {
          print("locales:$locales");
          return;
        },
        home: SplashPage()
    );
  }
}
