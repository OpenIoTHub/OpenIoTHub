import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:openiothub/app/app.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub/app/init.dart';
import 'package:openiothub/utils/desktop/configure_desktop_window.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemTheme.fallbackColor = ThemeUtils.defaultPrimaryForCurrentPlatform;
  await SystemTheme.accentColor.load();
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
