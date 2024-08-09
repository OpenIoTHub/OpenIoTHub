import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart'as fluent_ui;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/init.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/pages/homePage/all/homePage.dart';
import 'package:openiothub/pages/homePage/pc/pcHomePage.dart';
import 'package:openiothub/pages/splashPage/splashPage.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomTheme()),
      ],
      child: (Platform.isAndroid || Platform.isIOS || true) ? const MyApp() : const PcApp(),
    ),
    // MyApp()
  );
  init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
            title: "云亿连",
            // title: "OpenIoTHub",
            theme: CustomThemes.light,
            darkTheme: CustomThemes.dark,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              OpenIoTHubLocalizations.delegate,
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
                ? const SplashPage()
                : PcHomePage(
                    key: UniqueKey(),
                    title: '',
                  )));
  }
}

class PcApp extends StatelessWidget {
  const PcApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child:fluent_ui.FluentApp(
      title: '云亿连',
      theme: fluent_ui.FluentThemeData(
          accentColor: fluent_ui.Colors.orange
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        OpenIoTHubLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        fluent_ui.FluentLocalizations.delegate,
      ],
      supportedLocales: OpenIoTHubLocalizations.supportedLocales,
      localeListResolutionCallback: (locales, supportedLocales) {
        print("locales:$locales");
        return;
      },
      home: const PcHomePage(
        title: '',
      ),
    ));
  }
}
