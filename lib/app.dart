import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/providers/custom_theme.dart';
import 'package:openiothub/providers/locale_provider.dart';
import 'package:openiothub/providers/auth_provider.dart';
import 'package:openiothub/pages/home/all/home_page.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/router/auth_navigator_observer.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/plugin/openiothub_plugin.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomTheme()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadCurrentToken()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          final systemLocale =
              WidgetsBinding.instance.platformDispatcher.locale;
          final effectiveLocale =
              localeProvider.getEffectiveLocale(systemLocale);

          return Consumer<CustomTheme>(
            builder: (context, customTheme, child) {
              return Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return OKToast(
                    child: MaterialApp(
                      title: "云亿连",
                      debugShowCheckedModeBanner: false,
                      locale: effectiveLocale,
                      localizationsDelegates: const [
                        OpenIoTHubLocalizations.delegate,
                        OpenIoTHubCommonLocalizations.delegate,
                        OpenIoTHubPluginLocalizations.delegate,
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
                      initialRoute: AppRoutes.root,
                      navigatorObservers: [
                        AuthNavigatorObserver(authProvider: authProvider),
                      ],
                      routes: AppRoutes.buildStaticRoutes(
                        initialRouteWidget: const InitialRoute(),
                        homeMainWidget: const HomeMainRoute(),
                      ),
                      onGenerateRoute: AppRoutes.onGenerateRoute,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class InitialRoute extends StatefulWidget {
  const InitialRoute({super.key});

  @override
  State<InitialRoute> createState() => _InitialRouteState();
}

class _InitialRouteState extends State<InitialRoute> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isLoading) {
        authProvider.loadCurrentToken();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            }
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            }
          });
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class HomeMainRoute extends StatefulWidget {
  const HomeMainRoute({super.key});

  @override
  State<HomeMainRoute> createState() => _HomeMainRouteState();
}

class _HomeMainRouteState extends State<HomeMainRoute> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.loadCurrentToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyHomePage(
      key: UniqueKey(),
      title: '',
    );
  }
}
