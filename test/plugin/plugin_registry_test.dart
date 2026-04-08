import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openiothub/models/port_service_info.dart';
import 'package:openiothub/plugin/registry/plugin_context.dart';
import 'package:openiothub/plugin/registry/plugin_registry.dart';

void main() {
  test('registerBatch emits single notification', () {
    final registry = PluginRegistry();
    var notifications = 0;
    registry.addListener(() => notifications++);

    registry.registerBatch({
      'a': (_) => const SizedBox.shrink(),
      'b': (_) => const SizedBox.shrink(),
    });

    expect(notifications, 1);
    expect(registry.supports('a'), isTrue);
    expect(registry.supports('b'), isTrue);
    expect(registry.length, 2);
  });

  test('register notifies each time', () {
    final registry = PluginRegistry();
    var notifications = 0;
    registry.addListener(() => notifications++);

    registry.register('x', (_) => const SizedBox.shrink());
    registry.register('y', (_) => const SizedBox.shrink());

    expect(notifications, 2);
  });

  test('tryBuildPage supplies PluginContext with device alias', () {
    final registry = PluginRegistry();
    PluginContext? captured;
    registry.register('m', (ctx) {
      captured = ctx;
      return const SizedBox.shrink();
    });

    final service = PortServiceInfo(
      '192.168.1.1',
      8080,
      true,
      info: {'model': 'm', 'name': 't'},
    );

    final widget = registry.tryBuildPage('m', service);
    expect(widget, isNotNull);
    expect(captured!.modelId, 'm');
    expect(captured!.service, same(service));
    expect(captured!.device, same(service));
  });

  test('tryBuildPage returns null for unknown model', () {
    final registry = PluginRegistry();
    final service = PortServiceInfo('127.0.0.1', 80, true, info: {});
    expect(registry.tryBuildPage('unknown', service), isNull);
  });

  test('clear removes entries and notifies once', () {
    final registry = PluginRegistry();
    var notifications = 0;
    registry.addListener(() => notifications++);

    registry.registerBatch({
      'a': (_) => const SizedBox.shrink(),
    });
    expect(notifications, 1);

    registry.clear();
    expect(notifications, 2);
    expect(registry.length, 0);
    expect(registry.supports('a'), isFalse);

    registry.clear();
    expect(notifications, 2);
  });
}
