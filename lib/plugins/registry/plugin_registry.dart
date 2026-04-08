import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:openiothub/models/port_service_info.dart';
import 'package:openiothub/plugins/registry/openiothub_plugin_definition.dart';
import 'package:openiothub/plugins/registry/plugin_context.dart';
import 'package:openiothub/plugins/registry/plugin_invoke_request.dart';
import 'package:openiothub/plugins/registry/plugin_registry_observer.dart';

typedef PluginPageBuilder = Widget Function(PluginContext context);

/// 插件页 [PluginPageBuilder] 抛错时展示的占位组件（可在此使用 [BuildContext] 外的文案或上报）。
typedef PluginPageBuildFailureBuilder =
    Widget Function(String canonicalPluginId, Object error);

Widget? _buildPluginPageSafe(
  PluginPageBuilder builder,
  PluginContext context,
  String lookupKey,
  String canonicalPluginId,
  PluginRegistryObserver? observer,
  PluginPageBuildFailureBuilder? failureBuilder,
) {
  observer?.onWillBuildPage(canonicalPluginId, lookupKey);
  try {
    final w = builder(context);
    observer?.onDidBuildPage(canonicalPluginId, lookupKey);
    return w;
  } catch (error, stack) {
    observer?.onBuildPageFailed(canonicalPluginId, lookupKey, error, stack);
    assert(() {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'openiothub/plugins',
          context: ErrorDescription(
            'Plugin page build failed for "$canonicalPluginId" (lookup: "$lookupKey").',
          ),
        ),
      );
      return true;
    }());
    return (failureBuilder ?? _defaultPluginBuildFailureWidget)(
      canonicalPluginId,
      error,
    );
  }
}

Widget _defaultPluginBuildFailureWidget(String pluginId, Object error) {
  return ColoredBox(
    color: const Color(0xFFFFF3E0),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          '插件页面构建失败\n$pluginId\n$error',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFB71C1C)),
        ),
      ),
    ),
  );
}

/// 带元数据的一条插件注册（用于 [PluginRegistry.registerPluginBatch]）。
typedef PluginPageRegistration = ({
  OpenIoTHubPluginDefinition definition,
  PluginPageBuilder builder,
});

/// 设备 / 服务插件页面注册表，可通过 [Provider] 注入，并在运行时增删。
///
/// 推荐使用 [registerPlugin] 登记主 [OpenIoTHubPluginDefinition.id] 与别名，通过
/// [tryInvoke] / [PluginInvokeRequest] 统一按「插件 id + 参数」打开页面。
///
/// 长期扩展：[observer] 观测构建与失败；[pageBuildFailureBuilder] 自定义错误占位；
/// 启动注册见 [registerOpenIoTHubPlugins] / [OpenIoTHubPluginModule]（`builtin_plugins.dart`）。
class PluginRegistry extends ChangeNotifier {
  /// 横切逻辑（埋点、上报等）；不参与 [notifyListeners]。
  PluginRegistryObserver? observer;

  /// 插件页构建抛错时的占位 UI；为 null 时使用内置默认文案（中文）。
  /// 若需多语言，在应用启动后对注册表赋值，在闭包内使用已缓存的文案或自行查表。
  PluginPageBuildFailureBuilder? pageBuildFailureBuilder;

  final Map<String, PluginPageBuilder> _builders = {};
  final Map<String, String> _aliasToCanonical = {};
  final Map<String, OpenIoTHubPluginDefinition> _definitions = {};
  final Map<String, Set<String>> _canonicalToKeys = {};

  /// 所有可解析的查找键（含主 id 与别名）。
  Iterable<String> get registeredLookupKeys => _builders.keys;

  /// 已注册的 model / 插件查找键（与 [registeredLookupKeys] 相同，保留旧名）。
  Iterable<String> get registeredModelIds => registeredLookupKeys;

  /// 已登记元数据的规范插件 id（含 [register] / [registerBatch] 写入的简易定义）。
  Iterable<String> get registeredPluginIds => _canonicalToKeys.keys;

  int get length => _builders.length;

  bool supports(String? modelId) =>
      modelId != null && modelId.isNotEmpty && _builders.containsKey(modelId);

  /// 是否可解析 [request.pluginId]（含已登记别名）；不校验 [PluginInvokeRequest.params] 是否完整。
  bool supportsInvoke(PluginInvokeRequest request) => supports(request.pluginId);

  /// [supportsInvoke] 为 true，且若存在元数据定义，则 [PluginInvokeRequest] 满足
  /// [OpenIoTHubPluginDefinition.expectsTunnelService] 时对 [PluginInvokeRequest.paramService] 的要求。
  ///
  /// 无元数据（仅 [register] / [registerBatch] 等）时无法推断，视为满足（由调用方保证）。
  bool invokeParamsSatisfied(PluginInvokeRequest request) {
    if (!supports(request.pluginId)) {
      return false;
    }
    final def = definitionFor(request.pluginId);
    if (def == null) {
      return true;
    }
    if (!def.expectsTunnelService) {
      return true;
    }
    return request.hasTunnelServiceParam;
  }

  OpenIoTHubPluginDefinition? definitionFor(String lookupOrCanonicalId) {
    final canonical = resolveCanonicalPluginId(lookupOrCanonicalId);
    return _definitions[canonical];
  }

  /// 将查找键（可为别名）解析为规范插件 id。
  String resolveCanonicalPluginId(String lookupKey) =>
      _aliasToCanonical[lookupKey] ?? lookupKey;

  /// 已登记元数据的插件定义（规范 id → 定义）。
  ///
  /// 含 [registerPlugin] / [registerPluginBatch] 以及 [register] / [registerBatch] /
  /// [registerServiceBatch] / [registerUtilityBatch] 写入的简易定义。
  Map<String, OpenIoTHubPluginDefinition> get registeredDefinitions =>
      UnmodifiableMapView(_definitions);

  /// 已登记且属于 [category] 的插件定义（顺序不保证）。
  Iterable<OpenIoTHubPluginDefinition> definitionsForCategory(
    OpenIoTHubPluginCategory category,
  ) sync* {
    for (final d in _definitions.values) {
      if (d.category == category) {
        yield d;
      }
    }
  }

  /// 按 [OpenIoTHubPluginDefinition.sortPriority] 降序，同优先级按 [OpenIoTHubPluginDefinition.id] 升序。
  List<OpenIoTHubPluginDefinition> get definitionsSortedByPriority {
    final list = _definitions.values.toList()
      ..sort((a, b) {
        final byP = b.sortPriority.compareTo(a.sortPriority);
        if (byP != 0) {
          return byP;
        }
        return a.id.compareTo(b.id);
      });
    return List<OpenIoTHubPluginDefinition>.unmodifiable(list);
  }

  void _unregisterPluginSilent(String canonicalPluginId) {
    final keys = _canonicalToKeys.remove(canonicalPluginId);
    if (keys == null || keys.isEmpty) {
      _definitions.remove(canonicalPluginId);
      return;
    }
    for (final k in keys) {
      _builders.remove(k);
      _aliasToCanonical.remove(k);
    }
    _definitions.remove(canonicalPluginId);
  }

  void _registerPluginCore(
    OpenIoTHubPluginDefinition definition,
    PluginPageBuilder builder, {
    required bool allowOverride,
  }) {
    final keys = definition.allLookupKeys.toSet();
    for (final key in keys) {
      if (!allowOverride && _builders.containsKey(key)) {
        throw StateError('Plugin already registered: $key');
      }
    }
    if (_definitions.containsKey(definition.id)) {
      if (!allowOverride) {
        throw StateError('Plugin already registered: ${definition.id}');
      }
      _unregisterPluginSilent(definition.id);
    }
    for (final key in keys) {
      _builders[key] = builder;
      _indexKey(key, definition.id);
    }
    _definitions[definition.id] = definition;
  }

  void _indexKey(String lookupKey, String canonicalId) {
    final oldCanonical = _aliasToCanonical[lookupKey];
    if (oldCanonical != null && oldCanonical != canonicalId) {
      final oldSet = _canonicalToKeys[oldCanonical];
      oldSet?.remove(lookupKey);
      if (oldSet == null || oldSet.isEmpty) {
        _canonicalToKeys.remove(oldCanonical);
        _definitions.remove(oldCanonical);
      }
    }
    _aliasToCanonical[lookupKey] = canonicalId;
    _canonicalToKeys.putIfAbsent(canonicalId, () => <String>{}).add(lookupKey);
  }

  void _removeKeyFromCanonical(String lookupKey, String canonicalId) {
    _aliasToCanonical.remove(lookupKey);
    final keys = _canonicalToKeys[canonicalId];
    keys?.remove(lookupKey);
    if (keys == null || keys.isEmpty) {
      _canonicalToKeys.remove(canonicalId);
      _definitions.remove(canonicalId);
    }
  }

  /// 注册插件页构建函数；等价于以 [OpenIoTHubPluginDefinition.device] 登记简易元数据。
  ///
  /// 服务类请使用 [registerPlugin]（[OpenIoTHubPluginDefinition.service]）或 [registerServiceBatch]；
  /// 工具类见 [registerUtilityBatch] / [OpenIoTHubPluginDefinition.utility]。
  void register(
    String modelId,
    PluginPageBuilder builder, {
    bool allowOverride = true,
  }) {
    _registerPluginCore(
      OpenIoTHubPluginDefinition.device(modelId),
      builder,
      allowOverride: allowOverride,
    );
    notifyListeners();
  }

  void registerAll(
    Map<String, PluginPageBuilder> entries, {
    bool allowOverride = true,
  }) {
    registerBatch(entries, allowOverride: allowOverride);
  }

  /// 批量注册（**设备类**简易元数据：[OpenIoTHubPluginDefinition.device]），结束时只 [notifyListeners] 一次。
  ///
  /// 需要别名、展示名或非设备分类时请用 [registerPluginBatch] / [registerPlugin]；
  /// 纯服务类批量注册可用 [registerServiceBatch]。
  void registerBatch(
    Map<String, PluginPageBuilder> entries, {
    bool allowOverride = true,
  }) {
    if (entries.isEmpty) return;
    for (final e in entries.entries) {
      _registerPluginCore(
        OpenIoTHubPluginDefinition.device(e.key),
        e.value,
        allowOverride: allowOverride,
      );
    }
    notifyListeners();
  }

  /// 批量注册（**服务类**简易元数据：[OpenIoTHubPluginDefinition.service]）。
  void registerServiceBatch(
    Map<String, PluginPageBuilder> entries, {
    bool allowOverride = true,
  }) {
    if (entries.isEmpty) return;
    for (final e in entries.entries) {
      _registerPluginCore(
        OpenIoTHubPluginDefinition.service(e.key),
        e.value,
        allowOverride: allowOverride,
      );
    }
    notifyListeners();
  }

  /// 批量注册（**工具类**简易元数据：[OpenIoTHubPluginDefinition.utility]，无隧道 [PortServiceInfo]）。
  void registerUtilityBatch(
    Map<String, PluginPageBuilder> entries, {
    bool allowOverride = true,
  }) {
    if (entries.isEmpty) return;
    for (final e in entries.entries) {
      _registerPluginCore(
        OpenIoTHubPluginDefinition.utility(e.key),
        e.value,
        allowOverride: allowOverride,
      );
    }
    notifyListeners();
  }

  /// 使用元数据注册：主 [OpenIoTHubPluginDefinition.id] 与 [OpenIoTHubPluginDefinition.aliases]
  /// 均可用于 [tryBuildPage] / [tryInvoke]。
  void registerPlugin(
    OpenIoTHubPluginDefinition definition,
    PluginPageBuilder builder, {
    bool allowOverride = true,
  }) {
    _registerPluginCore(definition, builder, allowOverride: allowOverride);
    notifyListeners();
  }

  /// 批量 [registerPlugin]，结束时只 [notifyListeners] 一次。
  void registerPluginBatch(
    List<PluginPageRegistration> entries, {
    bool allowOverride = true,
  }) {
    if (entries.isEmpty) return;
    for (final e in entries) {
      _registerPluginCore(e.definition, e.builder, allowOverride: allowOverride);
    }
    notifyListeners();
  }

  /// 按规范 id 移除该插件下全部查找键与元数据。
  void unregisterPlugin(String canonicalPluginId) {
    final hadKeys = _canonicalToKeys.containsKey(canonicalPluginId);
    _unregisterPluginSilent(canonicalPluginId);
    if (hadKeys) {
      notifyListeners();
    }
  }

  void unregister(String modelId) {
    final canonical = _aliasToCanonical[modelId];
    final removed = _builders.remove(modelId) != null;
    if (canonical != null) {
      _aliasToCanonical.remove(modelId);
      _removeKeyFromCanonical(modelId, canonical);
    }
    if (removed) {
      notifyListeners();
    }
  }

  /// 清空全部注册（例如测试或动态重载模块前）；有变更时通知监听者。
  void clear() {
    if (_builders.isEmpty) return;
    _builders.clear();
    _aliasToCanonical.clear();
    _definitions.clear();
    _canonicalToKeys.clear();
    notifyListeners();
  }

  /// 构建插件根 [Widget]；未知 [modelId] 时返回 null。
  /// [PluginContext.modelId] 为规范插件 id（经别名打开时与传入的 [modelId] 可能不同）。
  Widget? tryBuildPage(String modelId, PortServiceInfo service) {
    final builder = _builders[modelId];
    if (builder == null) return null;
    final canonical = resolveCanonicalPluginId(modelId);
    final ctx = PluginContext(modelId: canonical, service: service);
    return _buildPluginPageSafe(
      builder,
      ctx,
      modelId,
      canonical,
      observer,
      pageBuildFailureBuilder,
    );
  }

  /// 与 [tryBuildPage] 相同，但在未注册时抛出。
  Widget buildPage(String modelId, PortServiceInfo service) {
    final w = tryBuildPage(modelId, service);
    if (w == null) {
      throw StateError('No plugin registered for model: $modelId');
    }
    return w;
  }

  /// 按 [PluginInvokeRequest.pluginId]（可为别名）与 [PluginInvokeRequest.params] 构建根页。
  ///
  /// [requireInvokeParamsSatisfied] 为 true 时，若 [invokeParamsSatisfied] 为 false 则返回 null（与导航层 [ensureInvokeParams] 对齐）。
  Widget? tryInvoke(
    PluginInvokeRequest request, {
    bool requireInvokeParamsSatisfied = false,
  }) {
    if (requireInvokeParamsSatisfied &&
        !invokeParamsSatisfied(request)) {
      return null;
    }
    final builder = _builders[request.pluginId];
    if (builder == null) return null;
    final canonical = resolveCanonicalPluginId(request.pluginId);
    final ctx = PluginContext.fromInvoke(
      request,
      resolvedPluginId: canonical,
    );
    return _buildPluginPageSafe(
      builder,
      ctx,
      request.pluginId,
      canonical,
      observer,
      pageBuildFailureBuilder,
    );
  }

  /// 与 [tryInvoke] 相同，未注册时抛出。
  Widget buildInvoke(
    PluginInvokeRequest request, {
    bool requireInvokeParamsSatisfied = false,
  }) {
    final w = tryInvoke(
      request,
      requireInvokeParamsSatisfied: requireInvokeParamsSatisfied,
    );
    if (w == null) {
      if (requireInvokeParamsSatisfied) {
        throw StateError(
          'Cannot build plugin "${request.pluginId}": not registered or '
          'invoke params do not match metadata (see invokeParamsSatisfied).',
        );
      }
      throw StateError('No plugin registered for id: ${request.pluginId}');
    }
    return w;
  }
}
