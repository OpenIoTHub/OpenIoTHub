import 'dart:io';

// import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/init.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/pages/homePage/all/homePage.dart';
import 'package:openiothub/pages/splashPage/splashAdPage.dart';
import 'package:openiothub/service/internal_plugin_service.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'configs/consts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    windowManager.addListener(MyWindowListener());
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomTheme()),
      ],
      child: (Platform.isAndroid || Platform.isIOS || true)
          ? const MyApp()
          // : const PcApp(),
          : const MyApp()
    ),
    // MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
            // 华为需要
            title: "云亿连",
            // title: OpenIoTHubLocalizations.of(context).app_title,
            // title: "OpenIoTHub",
            theme: CustomThemes.light,
            darkTheme: CustomThemes.dark,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              OpenIoTHubLocalizations.delegate,
              OpenIoTHubCommonLocalizations.delegate,
              OpenIoTHubPluginLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: OpenIoTHubLocalizations.supportedLocales,
            localeListResolutionCallback: (locales, supportedLocales) {
              print("locales:$locales");
              return;
            },
            home: (Platform.isAndroid || Platform.isIOS)
                ? SplashAdPage()
                : MyHomePage(
                    key: UniqueKey(),
                    title: '',
                  )
          ));
  }
}

// class PcApp extends StatelessWidget {
//   const PcApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return OKToast(
//         child: fluent_ui.FluentApp(
//       title: OpenIoTHubCommonLocalizations.of(context).app_title,
//       theme: fluent_ui.FluentThemeData(accentColor: fluent_ui.Colors.orange),
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: const [
//         OpenIoTHubLocalizations.delegate,
//         OpenIoTHubCommonLocalizations.delegate,
//         OpenIoTHubPluginLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         fluent_ui.FluentLocalizations.delegate,
//       ],
//       supportedLocales: OpenIoTHubLocalizations.supportedLocales,
//       localeListResolutionCallback: (locales, supportedLocales) {
//         print("locales:$locales");
//         return;
//       },
//       home: const PcHomePage(
//         title: '',
//       ),
//     ));
//   }
// }

class MyWindowListener extends WindowListener {
  @override
  void onWindowClose() {
    // 处理窗口关闭事件
    print("onWindowClose");
    exit(0);
  }

  @override
  void onWindowMaximize() {
    // 处理窗口最大化事件
    print("onWindowMaximize");
  }
}
