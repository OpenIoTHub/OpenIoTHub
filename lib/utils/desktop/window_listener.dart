import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// 桌面端窗口事件监听器。关闭窗口时直接退出进程，
/// 避免 Go FFI 后台 Isolate 在主窗口关闭后残留。
class OpenIoTHubWindowListener extends WindowListener {
  @override
  void onWindowClose() {
    debugPrint('onWindowClose');
    exit(0);
  }
}
