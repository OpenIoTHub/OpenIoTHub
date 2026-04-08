import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub/app/init.dart';
import 'package:fluent_ui/fluent_ui.dart' show FluentLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/app/providers/custom_theme.dart';
import 'package:openiothub/app/providers/locale_provider.dart';
import 'package:openiothub/app/providers/auth_provider.dart';
import 'package:openiothub/router/core/go_app_router.dart';
import 'package:openiothub/utils/app/openiothub_scroll_behavior.dart';
import 'package:openiothub/plugins/registry/builtin_plugins.dart'
    show registerOpenIoTHubPlugins;
import 'package:openiothub/plugins/registry/plugin_registry.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AuthProvider _auth = AuthProvider()..loadCurrentToken();
  late final GoRouter _router = createOpenIoTHubRouter(_auth);

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('[OpenIoTHub][lifecycle] observer: $state');
    unawaited(handleAndroidForegroundServiceLifecycle(state));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomTheme()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider<AuthProvider>.value(value: _auth),
        ChangeNotifierProvider(
          create: (_) {
            final registry = PluginRegistry();
            registerOpenIoTHubPlugins(registry);
            return registry;
          },
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          final systemLocale =
              WidgetsBinding.instance.platformDispatcher.locale;
          final effectiveLocale = localeProvider.getEffectiveLocale(
            systemLocale,
          );

          return Consumer<CustomTheme>(
            builder: (context, customTheme, child) {
              return OKToast(
                child: MaterialApp.router(
                  title: "云亿连",
                  debugShowCheckedModeBanner: false,
                  scrollBehavior: const OpenIoTHubScrollBehavior(),
                  locale: effectiveLocale,
                  localizationsDelegates: const [
                    OpenIoTHubLocalizations.delegate,
                    FluentLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: OpenIoTHubLocalizations.supportedLocales,
                  localeResolutionCallback: (locale, supportedLocales) {
                    if (locale == null) return null;

                    for (final supported in supportedLocales) {
                      if (supported.languageCode == locale.languageCode &&
                          supported.countryCode == locale.countryCode) {
                        return supported;
                      }
                    }

                    for (final supported in supportedLocales) {
                      if (supported.languageCode == locale.languageCode) {
                        return supported;
                      }
                    }

                    return const Locale('en');
                  },
                  theme: CustomThemes.getLightTheme(customTheme.primaryColor),
                  darkTheme: CustomThemes.getDarkTheme(
                    customTheme.primaryColor,
                  ),
                  themeMode: customTheme.getThemeMode(),
                  routerConfig: _router,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
