import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// 网络 / gRPC 层调试日志；仅在 [kDebugMode] 下输出，DevTools 中可按 [name] 过滤。
void netLog(
  String name,
  String message, {
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!kDebugMode) return;
  if (error != null) {
    developer.log(message, name: name, error: error, stackTrace: stackTrace);
  } else {
    developer.log(message, name: name);
  }
}
