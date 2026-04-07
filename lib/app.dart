import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/providers/custom_theme.dart';
import 'package:openiothub/providers/locale_provider.dart';
import 'package:openiothub/providers/auth_provider.dart';
import 'package:openiothub/router/go_app_router.dart';
import 'package:openiothub/plugin/registry/builtin_plugins.dart';
import 'package:openiothub/plugin/registry/plugin_registry.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthProvider _auth = AuthProvider()..loadCurrentToken();
  late final GoRouter _router = createOpenIoTHubRouter(_auth);

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
            registerBuiltinPlugins(registry);
            return registry;
          },
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          final systemLocale =
              WidgetsBinding.instance.platformDispatcher.locale;
          final effectiveLocale =
              localeProvider.getEffectiveLocale(systemLocale);

          return Consumer<CustomTheme>(
            builder: (context, customTheme, child) {
              return OKToast(
                child: MaterialApp.router(
                  title: "云亿连",
                  debugShowCheckedModeBanner: false,
                  locale: effectiveLocale,
                  localizationsDelegates: const [
                    OpenIoTHubLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales:
                      OpenIoTHubLocalizations.supportedLocales,
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
                  theme: CustomThemes.getLightTheme(
                      customTheme.primaryColor),
                  darkTheme: CustomThemes.getDarkTheme(
                      customTheme.primaryColor),
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
