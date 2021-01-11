import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_natcloud_service');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterNatcloudService.platformVersion, '42');
  });
}
