import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'services/services.dart';
import 'shared/shared.dart';
import 'pages/pages.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ConnectionModel()),
        ChangeNotifierProvider(builder: (context) => CustomTheme()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MaterialApp(
      title: 'RemoteFiles',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
      theme: Provider.of<CustomTheme>(context).themeValue == "dark"
          ? CustomThemes.dark
          : CustomThemes.light,
      // 'darkTheme' is not active because it's not working properly in versions
      // of Android earlier than Android Pie.
      // According to the Flutter API, darkTheme should only be used when a
      // concept of brightness mode is supported on a platform.
      // But it is also used on platforms that don't support a concept of
      // brightness mode.
      // Until this is fixed the theme option 'automatic' in the settings will
      // always show the light theme.
      // ---
      /*
      darkTheme: Provider.of<CustomTheme>(context).themeValue == "light"
          ? CustomThemes.light
          : CustomThemes.dark,
      */
    );
  }
}
