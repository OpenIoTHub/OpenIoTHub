/// 与 [PluginRegistry.observer] 配合，用于埋点、日志、崩溃上报或远程开关等横切逻辑。
///
/// 子类按需覆写；默认均为空实现。
abstract class PluginRegistryObserver {
  const PluginRegistryObserver();

  /// 即将调用插件 [PluginPageBuilder]；[lookupKey] 为调用方传入的 id（可为别名），[canonicalPluginId] 为规范 id。
  void onWillBuildPage(String canonicalPluginId, String lookupKey) {}

  /// 插件页 [Widget] 已成功构建（尚未挂载）。
  void onDidBuildPage(String canonicalPluginId, String lookupKey) {}

  /// 构建过程抛出异常；注册表会返回占位页而非让整棵路由树崩溃。
  void onBuildPageFailed(
    String canonicalPluginId,
    String lookupKey,
    Object error,
    StackTrace stack,
  ) {}
}

/// 将多个 [PluginRegistryObserver] 串联到 [PluginRegistry.observer] 一处，避免互相覆盖。
///
/// 调用顺序与 [children] 列表顺序一致。
final class CompositePluginRegistryObserver extends PluginRegistryObserver {
  CompositePluginRegistryObserver(this.children);

  final List<PluginRegistryObserver> children;

  @override
  void onWillBuildPage(String canonicalPluginId, String lookupKey) {
    for (final c in children) {
      c.onWillBuildPage(canonicalPluginId, lookupKey);
    }
  }

  @override
  void onDidBuildPage(String canonicalPluginId, String lookupKey) {
    for (final c in children) {
      c.onDidBuildPage(canonicalPluginId, lookupKey);
    }
  }

  @override
  void onBuildPageFailed(
    String canonicalPluginId,
    String lookupKey,
    Object error,
    StackTrace stack,
  ) {
    for (final c in children) {
      c.onBuildPageFailed(canonicalPluginId, lookupKey, error, stack);
    }
  }
}
