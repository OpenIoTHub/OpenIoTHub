import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// 设置桌面端窗口最小尺寸；若当前窗口过小则放大到合理默认值。
Future<void> configureOpenIoTHubDesktopWindow() async {
  if (kIsWeb) return;
  if (defaultTargetPlatform != TargetPlatform.windows &&
      defaultTargetPlatform != TargetPlatform.linux &&
      defaultTargetPlatform != TargetPlatform.macOS) {
    return;
  }
  try {
    await windowManager.setTitle('云亿连');
    await windowManager.setMinimumSize(const Size(900, 620));
    final sz = await windowManager.getSize();
    const minW = 900.0;
    const minH = 620.0;
    if (sz.width < minW || sz.height < minH) {
      await windowManager.setSize(const Size(1200, 780));
    }
    await windowManager.center();
  } catch (e, st) {
    debugPrint('configureOpenIoTHubDesktopWindow: $e\n$st');
  }
}
