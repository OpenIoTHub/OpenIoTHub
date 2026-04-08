import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:openiothub/app.dart';
import 'package:openiothub/init.dart';
import 'package:openiothub/platform/configure_desktop_window.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isMacOS) {
    await const MacosWindowUtilsConfig(
      toolbarStyle: NSWindowToolbarStyle.expanded,
      hideTitle: false,
    ).apply();
  }
  await init();
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    windowManager.addListener(MyWindowListener());
    await configureOpenIoTHubDesktopWindow();
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
