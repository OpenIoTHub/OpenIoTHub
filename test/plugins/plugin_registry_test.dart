import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openiothub/models/port_service_info.dart';
import 'package:openiothub/plugins/registry/builtin_plugins.dart'
    show openIoTHubDefaultBuiltinPluginModules, registerOpenIoTHubPlugins;
import 'package:openiothub/plugins/registry/openiothub_plugin_definition.dart';
import 'package:openiothub/plugins/registry/plugin_context.dart';
import 'package:openiothub/plugins/registry/plugin_invoke_request.dart';
import 'package:openiothub/plugins/registry/openiothub_plugin_module.dart';
import 'package:openiothub/plugins/registry/plugin_registry.dart';
import 'package:openiothub/plugins/registry/plugin_registry_observer.dart';
import 'package:openiothub/plugins/registry/plugin_route_settings.dart';

void main() {
  test('registerPluginBatch emits single notification', () {
    final registry = PluginRegistry();
    var notifications = 0;
    registry.addListener(() => notifications++);

    registry.registerPluginBatch([
      (
        definition: OpenIoTHubPluginDefinition.device('a'),
        builder: (_) => const SizedBox.shrink(),
      ),
      (
        definition: OpenIoTHubPluginDefinition.device('b'),
        builder: (_) => const SizedBox.shrink(),
      ),
    ]);

    expect(notifications, 1);
    expect(registry.supports('a'), isTrue);
    expect(registry.supports('b'), isTrue);
    expect(registry.registeredDefinitions.length, 2);
  });

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
    expect(registry.registeredDefinitions.length, 2);
    expect(
      registry.definitionFor('a')?.category,
      OpenIoTHubPluginCategory.device,
    );
  });

  test('registerServiceBatch tags definitions as service', () {
    final registry = PluginRegistry();
    registry.registerServiceBatch({
      'svc': (_) => const SizedBox.shrink(),
    });
    expect(
      registry.definitionFor('svc')?.category,
      OpenIoTHubPluginCategory.service,
    );
  });

  test('register notifies each time', () {
    final registry = PluginRegistry();
    var notifications = 0;
    registry.addListener(() => notifications++);

    registry.register('x', (_) => const SizedBox.shrink());
    registry.register('y', (_) => const SizedBox.shrink());

    expect(notifications, 2);
    expect(registry.definitionFor('x')?.category, OpenIoTHubPluginCategory.device);
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

  test('registerPlugin resolves alias to canonical modelId in context', () {
    final registry = PluginRegistry();
    PluginContext? captured;
    registry.registerPlugin(
      const OpenIoTHubPluginDefinition(
        id: 'main-id',
        aliases: ['legacy-alias'],
      ),
      (ctx) {
        captured = ctx;
        return const SizedBox.shrink();
      },
    );

    final service = PortServiceInfo(
      '192.168.1.1',
      8080,
      true,
      info: const {},
    );

    expect(registry.tryBuildPage('legacy-alias', service), isNotNull);
    registry.tryBuildPage('legacy-alias', service);
    expect(captured!.modelId, 'main-id');
    expect(captured!.pluginId, 'main-id');
  });

  test('tryInvoke passes extras on PluginContext', () {
    final registry = PluginRegistry();
    PluginContext? captured;
    registry.register('p', (ctx) {
      captured = ctx;
      return const SizedBox.shrink();
    });

    final service = PortServiceInfo('127.0.0.1', 1, true, info: const {});
    registry.tryInvoke(
      PluginInvokeRequest(
        pluginId: 'p',
        params: {
          PluginInvokeRequest.paramService: service,
          'foo': 1,
        },
      ),
    );

    expect(captured!.extras, {'foo': 1});
    expect(captured!.service, same(service));
  });

  test('pluginInvokeFromModel uses info model or returns null', () {
    final withModel = PortServiceInfo(
      '1.1.1.1',
      1,
      true,
      info: const {'model': 'm1'},
    );
    expect(withModel.pluginInvokeFromModel()?.pluginId, 'm1');

    final noModel = PortServiceInfo('1.1.1.1', 1, true, info: const {});
    expect(noModel.pluginInvokeFromModel(), isNull);
  });

  test('PluginInvokeRequest mergeParams and copyWith', () {
    final service = PortServiceInfo('h', 1, true, info: {});
    final base = PluginInvokeRequest.withService('p', service);
    final merged = base.mergeParams({'k': 2});
    expect(merged.params[PluginInvokeRequest.paramService], same(service));
    expect(merged.params['k'], 2);

    final copied = base.copyWith(pluginId: 'q');
    expect(copied.pluginId, 'q');
    expect(copied.requireService(), same(service));
  });

  test('definitionsForCategory filters by OpenIoTHubPluginCategory', () {
    final registry = PluginRegistry();
    registry.registerPluginBatch([
      (
        definition: OpenIoTHubPluginDefinition.device('d'),
        builder: (_) => const SizedBox.shrink(),
      ),
      (
        definition: OpenIoTHubPluginDefinition.service('s'),
        builder: (_) => const SizedBox.shrink(),
      ),
    ]);
    expect(
      registry.definitionsForCategory(OpenIoTHubPluginCategory.device).length,
      1,
    );
    expect(
      registry.definitionsForCategory(OpenIoTHubPluginCategory.device).first.id,
      'd',
    );
    expect(
      registry.definitionsForCategory(OpenIoTHubPluginCategory.service).length,
      1,
    );
  });

  test('supportsInvoke mirrors supports on pluginId', () {
    final registry = PluginRegistry();
    registry.register('z', (_) => const SizedBox.shrink());
    final req = PluginInvokeRequest.withService(
      'z',
      PortServiceInfo('h', 1, true, info: const {}),
    );
    expect(registry.supportsInvoke(req), isTrue);
    expect(
      registry.supportsInvoke(
        PluginInvokeRequest.withService(
          'missing',
          PortServiceInfo('h', 1, true, info: const {}),
        ),
      ),
      isFalse,
    );
  });

  test('PluginInvokeRequest.hasTunnelServiceParam', () {
    final svc = PortServiceInfo('h', 1, true, info: const {});
    expect(
      PluginInvokeRequest.withService('a', svc).hasTunnelServiceParam,
      isTrue,
    );
    expect(PluginInvokeRequest.utility('b').hasTunnelServiceParam, isFalse);
  });

  test('tryInvoke returns null when requireInvokeParamsSatisfied and tunnel missing', () {
    final registry = PluginRegistry();
    registry.registerPlugin(
      OpenIoTHubPluginDefinition.device('dev_only'),
      (_) => const SizedBox.shrink(),
    );
    expect(
      registry.tryInvoke(PluginInvokeRequest.utility('dev_only')),
      isNotNull,
    );
    expect(
      registry.tryInvoke(
        PluginInvokeRequest.utility('dev_only'),
        requireInvokeParamsSatisfied: true,
      ),
      isNull,
    );
    expect(
      registry.tryInvoke(
        PluginInvokeRequest.withService(
          'dev_only',
          PortServiceInfo('h', 1, true, info: const {}),
        ),
        requireInvokeParamsSatisfied: true,
      ),
      isNotNull,
    );
  });

  test('invokeParamsSatisfied matches definition expectsTunnelService', () {
    final registry = PluginRegistry();
    registry.registerPluginBatch([
      (
        definition: OpenIoTHubPluginDefinition.device('dev'),
        builder: (_) => const SizedBox.shrink(),
      ),
      (
        definition: OpenIoTHubPluginDefinition.utility('util'),
        builder: (_) => const SizedBox.shrink(),
      ),
    ]);
    final svc = PortServiceInfo('h', 1, true, info: const {});
    expect(
      registry.invokeParamsSatisfied(PluginInvokeRequest.utility('dev')),
      isFalse,
    );
    expect(
      registry.invokeParamsSatisfied(PluginInvokeRequest.withService('dev', svc)),
      isTrue,
    );
    expect(
      registry.invokeParamsSatisfied(PluginInvokeRequest.utility('util')),
      isTrue,
    );
    expect(
      registry.invokeParamsSatisfied(PluginInvokeRequest.withService('util', svc)),
      isTrue,
    );
  });

  test('PluginContext.extraAs returns typed extra or null', () {
    final svc = PortServiceInfo('h', 1, true, info: const {});
    final ctx = PluginContext(
      modelId: 'p',
      service: svc,
      extras: const {'n': 3, 's': 'x'},
    );
    expect(ctx.extraAs<int>('n'), 3);
    expect(ctx.extraAs<String>('n'), isNull);
    expect(ctx.extraAs<String>('s'), 'x');
    expect(ctx.extraAs<int>('missing'), isNull);
  });

  test('definitionsSortedByPriority orders by sortPriority then id', () {
    final registry = PluginRegistry();
    registry.registerPluginBatch([
      (
        definition: OpenIoTHubPluginDefinition.device('a', sortPriority: 0),
        builder: (_) => const SizedBox.shrink(),
      ),
      (
        definition: OpenIoTHubPluginDefinition.device('b', sortPriority: 10),
        builder: (_) => const SizedBox.shrink(),
      ),
      (
        definition: OpenIoTHubPluginDefinition.device('c', sortPriority: 10),
        builder: (_) => const SizedBox.shrink(),
      ),
    ]);
    final sorted = registry.definitionsSortedByPriority;
    expect(sorted.map((d) => d.id).toList(), ['b', 'c', 'a']);
  });

  test('builder exception returns fallback widget and notifies observer', () {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (_) {};
    addTearDown(() => FlutterError.onError = oldOnError);

    final registry = PluginRegistry();
    final obs = _RecordingPluginObserver();
    registry.observer = obs;
    registry.register('bad', (_) => throw StateError('boom'));
    final service = PortServiceInfo('h', 1, true, info: const {});
    final w = registry.tryBuildPage('bad', service);
    expect(w, isNotNull);
    expect(obs.will, 1);
    expect(obs.didBuild, 0);
    expect(obs.failed, 1);
  });

  test('PluginContext copyWith replaces or merges extras', () {
    final svc = PortServiceInfo('h', 1, true, info: const {});
    final ctx = PluginContext(
      modelId: 'p',
      service: svc,
      extras: const {'a': 1},
    );
    final merged = ctx.copyWith(extras: const {'b': 2}, mergeExtras: true);
    expect(merged.extras, {'a': 1, 'b': 2});
    final replaced = ctx.copyWith(extras: const {'b': 2});
    expect(replaced.extras, {'b': 2});
    final sameId = ctx.copyWith(modelId: 'q');
    expect(sameId.modelId, 'q');
    expect(sameId.extras, ctx.extras);
    expect(sameId.service, same(svc));
    final cleared = ctx.copyWith(clearTunnelService: true);
    expect(cleared.service, isNull);
    expect(cleared.hasTunnelService, isFalse);
  });

  test('utility plugin invoke has no tunnel service; extras from params', () {
    final registry = PluginRegistry();
    PluginContext? captured;
    registry.registerPlugin(
      OpenIoTHubPluginDefinition.utility('util_x'),
      (ctx) {
        captured = ctx;
        return const SizedBox.shrink();
      },
    );
    registry.tryInvoke(PluginInvokeRequest.utility('util_x', {'n': 7}));
    expect(captured, isNotNull);
    expect(captured!.hasTunnelService, isFalse);
    expect(captured!.extras, {'n': 7});
    expect(() => captured!.device, throwsStateError);
  });

  test('registerUtilityBatch tags definitions as utility category', () {
    final registry = PluginRegistry();
    registry.registerUtilityBatch({
      'u1': (_) => const SizedBox.shrink(),
    });
    expect(
      registry.definitionFor('u1')?.category,
      OpenIoTHubPluginCategory.utility,
    );
  });

  test('CompositePluginRegistryObserver forwards to all children', () {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (_) {};
    addTearDown(() => FlutterError.onError = oldOnError);

    final a = _RecordingPluginObserver();
    final b = _RecordingPluginObserver();
    final registry = PluginRegistry()
      ..observer = CompositePluginRegistryObserver([a, b])
      ..register('bad', (_) => throw StateError('x'));
    registry.tryBuildPage(
      'bad',
      PortServiceInfo('h', 1, true, info: const {}),
    );
    expect(a.will, 1);
    expect(b.will, 1);
    expect(a.failed, 1);
    expect(b.failed, 1);
  });

  test('registerModules invokes registerInto in order', () {
    final registry = PluginRegistry();
    final log = <String>[];
    registry.registerModules([
      _FakePluginModule('m1', () => log.add('1')),
      _FakePluginModule('m2', () => log.add('2')),
    ]);
    expect(log, ['1', '2']);
  });

  test('PluginRouteSettings.withName carries RouteSettings', () {
    final s = PluginRouteSettings.withName('plugin/demo', arguments: 42);
    expect(s.routeSettings?.name, 'plugin/demo');
    expect(s.routeSettings?.arguments, 42);
  });

  test('registerOpenIoTHubPlugins registers builtin plus extraModules', () {
    final builtinOnly = PluginRegistry();
    registerOpenIoTHubPlugins(builtinOnly);
    final builtinCount = builtinOnly.length;

    final withExtra = PluginRegistry();
    registerOpenIoTHubPlugins(
      withExtra,
      extraModules: [_ExtraPluginModule()],
    );
    expect(withExtra.supports('extra_plugin_only'), isTrue);
    expect(withExtra.length, builtinCount + 1);
  });

  test('pageBuildFailureBuilder overrides default failure UI', () {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (_) {};
    addTearDown(() => FlutterError.onError = oldOnError);

    final registry = PluginRegistry();
    registry.pageBuildFailureBuilder =
        (id, err) => Text('custom-$id-${err.runtimeType}');
    registry.register('bad', (_) => throw StateError('boom'));
    final w = registry.tryBuildPage(
      'bad',
      PortServiceInfo('h', 1, true, info: const {}),
    );
    expect(w, isA<Text>());
    expect((w! as Text).data, 'custom-bad-StateError');
  });

  test('openIoTHubDefaultBuiltinPluginModules lists core modules', () {
    expect(openIoTHubDefaultBuiltinPluginModules.length, 2);
    expect(
      openIoTHubDefaultBuiltinPluginModules.map((m) => m.moduleId).toList(),
      [
        'openiothub.builtin.device_plugins',
        'openiothub.builtin.service_plugins',
      ],
    );
  });

  test('unregisterPlugin removes all lookup keys', () {
    final registry = PluginRegistry();
    registry.registerPlugin(
      const OpenIoTHubPluginDefinition(
        id: 'x',
        aliases: ['y'],
      ),
      (_) => const SizedBox.shrink(),
    );
    expect(registry.supports('x'), isTrue);
    expect(registry.supports('y'), isTrue);

    registry.unregisterPlugin('x');
    expect(registry.supports('x'), isFalse);
    expect(registry.supports('y'), isFalse);
    expect(registry.definitionFor('x'), isNull);
  });
}

final class _ExtraPluginModule implements OpenIoTHubPluginModule {
  @override
  String get moduleId => 'test.extra_plugin';

  @override
  void registerInto(PluginRegistry registry) {
    registry.register('extra_plugin_only', (_) => const SizedBox.shrink());
  }
}

final class _FakePluginModule implements OpenIoTHubPluginModule {
  _FakePluginModule(this.moduleId, this.onRegister);

  @override
  final String moduleId;
  final void Function() onRegister;

  @override
  void registerInto(PluginRegistry registry) => onRegister();
}

final class _RecordingPluginObserver extends PluginRegistryObserver {
  int will = 0;
  int didBuild = 0;
  int failed = 0;

  @override
  void onWillBuildPage(String canonicalPluginId, String lookupKey) {
    will++;
  }

  @override
  void onDidBuildPage(String canonicalPluginId, String lookupKey) {
    didBuild++;
  }

  @override
  void onBuildPageFailed(
    String canonicalPluginId,
    String lookupKey,
    Object error,
    StackTrace stack,
  ) {
    failed++;
  }
}
