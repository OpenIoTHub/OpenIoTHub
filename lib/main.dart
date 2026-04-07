import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub/app.dart';
import 'package:openiothub/init.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    windowManager.addListener(MyWindowListener());
  }
  runApp(const MyApp());
}

class MyWindowListener extends WindowListener {
  @override
  void onWindowClose() {
    debugPrint("onWindowClose");
    exit(0);
  }

  @override
  void onWindowMaximize() {
    debugPrint("onWindowMaximize");
  }
}
