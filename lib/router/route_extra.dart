import 'package:flutter/material.dart';
import 'package:openiothub/router/app_navigator.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

/// 解析 [GoRoute] 的 [GoRouterState.extra]（Map 或直传 [Device]）。
class OpenIoTHubRouteExtra {
  OpenIoTHubRouteExtra._();

  static Map<String, dynamic>? map(Object? extra) {
    if (extra is Map) {
      return Map<String, dynamic>.from(
        extra.map((k, v) => MapEntry(k.toString(), v)),
      );
    }
    return null;
  }

  static String? string(Object? extra, String key) {
    final v = map(extra)?[key];
    return v is String ? v : null;
  }

  static int integer(Object? extra, String key, int defaultValue) {
    final v = map(extra)?[key];
    return v is int ? v : defaultValue;
  }

  static T? typed<T>(Object? extra, String key) {
    final v = map(extra)?[key];
    return v is T ? v : null;
  }

  static Device? device(Object? extra) {
    if (extra is Device) return extra;
    final d = map(extra)?[AppNavigator.argDevice];
    return d is Device ? d : null;
  }

  static Widget invalidPage() => const Scaffold(
        body: Center(child: Text('Invalid navigation')),
      );
}
