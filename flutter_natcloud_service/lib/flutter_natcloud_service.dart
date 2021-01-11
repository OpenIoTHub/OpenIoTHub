import 'dart:async';

import 'package:flutter/services.dart';

class FlutterNatcloudService {
  static const MethodChannel _channel =
      const MethodChannel('flutter_natcloud_service');

  static Future<String> start() async {
    final String result = await _channel.invokeMethod('start');
    return result;
  }

}
