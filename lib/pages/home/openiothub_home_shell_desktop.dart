import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:go_router/go_router.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:openiothub/core/app_spacing.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/providers/custom_theme.dart';
import 'package:openiothub/utils/openiothub_desktop_layout.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

fluent.AccentColor _openIoTHubFluentAccent(Color primary) {
  return fluent.AccentColor.swatch({
    'darkest': Color.alphaBlend(Colors.black.withValues(alpha: 0.45), primary),
    'darker': Color.alphaBlend(Colors.black.withValues(alpha: 0.35), primary),
    'dark': Color.alphaBlend(Colors.black.withValues(alpha: 0.25), primary),
    'normal': primary,
    'light': Color.alphaBlend(Colors.white.withValues(alpha: 0.15), primary),
    'lighter': Color.alphaBlend(Colors.white.withValues(alpha: 0.25), primary),
    'lightest': Color.alphaBlend(Colors.white.withValues(alpha: 0.35), primary),
  });
}

Widget? _fluentKeyCaption(BuildContext context, int indexOneBased) {
  final cap = openIoTHubHomeTabKeyCaption(indexOneBased);
  if (cap.isEmpty) return null;
  final theme = fluent.FluentTheme.of(context);
  return Text(
    cap,
    style: TextStyle(
      fontSize: 11,
      color: theme.inactiveColor.withValues(alpha: 0.72),
    ),
  );
}

Widget? _macosKeyCaption(BuildContext context, int indexOneBased) {
  final cap = openIoTHubHomeTabKeyCaption(indexOneBased);
  if (cap.isEmpty) return null;
  return Text(cap, style: MacosTheme.of(context).typography.caption1);
}

/// 桌面端主页外壳：macOS 使用 [MacosWindow] + [Sidebar]；Windows/Linux 使用 Fluent [NavigationView]。
class OpenIoTHubDesktopHomeShell extends StatelessWidget {
  const OpenIoTHubDesktopHomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final shell = _DesktopHomeShortcuts(
      navigationShell: navigationShell,
      child:
          defaultTargetPlatform == TargetPlatform.macOS
              ? _OpenIoTHubMacosHomeShell(navigationShell: navigationShell)
              : _OpenIoTHubFluentHomeShell(navigationShell: navigationShell),
    );
    return shell;
  }
}

/// 桌面端：Ctrl/Cmd + 1～4 切换主页 Tab（与侧栏顺序一致）。
/// 使用 [HardwareKeyboard] 以便在多数界面下可用；在可编辑文本聚焦时不拦截。
class _DesktopHomeShortcuts extends StatefulWidget {
  const _DesktopHomeShortcuts({
    required this.navigationShell,
    required this.child,
  });

  final StatefulNavigationShell navigationShell;
  final Widget child;

  @override
  State<_DesktopHomeShortcuts> createState() => _DesktopHomeShortcutsState();
}

class _DesktopHomeShortcutsState extends State<_DesktopHomeShortcuts> {
  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (!HardwareKeyboard.instance.isControlPressed &&
        !HardwareKeyboard.instance.isMetaPressed) {
      return false;
    }
    final primaryCtx = FocusManager.instance.primaryFocus?.context;
    if (primaryCtx != null &&
        primaryCtx.findAncestorWidgetOfExactType<EditableText>() != null) {
      return false;
    }
    final idx = _digitTabIndex(event.logicalKey);
    if (idx == null) return false;
    widget.navigationShell.goBranch(
      idx,
      initialLocation: idx == widget.navigationShell.currentIndex,
    );
    return true;
  }

  static int? _digitTabIndex(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.digit1) return 0;
    if (key == LogicalKeyboardKey.digit2) return 1;
    if (key == LogicalKeyboardKey.digit3) return 2;
    if (key == LogicalKeyboardKey.digit4) return 3;
    return null;
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _OpenIoTHubFluentHomeShell extends StatelessWidget {
  const _OpenIoTHubFluentHomeShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _placeholderBody = SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final l10n = OpenIoTHubLocalizations.of(context);
    return Consumer<CustomTheme>(
      builder: (context, customTheme, _) {
        final brightness = Theme.of(context).brightness;
        return fluent.FluentTheme(
          data: fluent.FluentThemeData(
            brightness: brightness,
            accentColor: _openIoTHubFluentAccent(customTheme.primaryColor),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1000;
              return fluent.NavigationView(
                transitionBuilder:
                    (child, animation) =>
                        fluent.SuppressPageTransition(child: child),
                paneBodyBuilder:
                    (_, __) => Padding(
                      padding: AppSpacing.desktopShellContentInsets,
                      child: navigationShell,
                    ),
                pane: fluent.NavigationPane(
                  selected: navigationShell.currentIndex,
                  onChanged: (index) {
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                  displayMode:
                      wide
                          ? fluent.PaneDisplayMode.open
                          : fluent.PaneDisplayMode.compact,
                  size: const fluent.NavigationPaneSize(openWidth: 256),
                  header: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 12,
                      end: 8,
                      bottom: 8,
                    ),
                    child: Text(
                      l10n.app_title,
                      style:
                          fluent.FluentTheme.of(
                            context,
                          ).typography.bodyStrong ??
                          const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  items: [
                    fluent.PaneItem(
                      icon: const Icon(TDIcons.internet, size: 18),
                      title: Text(l10n.tab_gateway),
                      trailing: _fluentKeyCaption(context, 1),
                      body: _placeholderBody,
                    ),
                    fluent.PaneItem(
                      icon: const Icon(TDIcons.desktop, size: 18),
                      title: Text(l10n.tab_host),
                      trailing: _fluentKeyCaption(context, 2),
                      body: _placeholderBody,
                    ),
                    fluent.PaneItem(
                      icon: const Icon(TDIcons.control_platform, size: 18),
                      title: Text(l10n.tab_smart),
                      trailing: _fluentKeyCaption(context, 3),
                      body: _placeholderBody,
                    ),
                    fluent.PaneItem(
                      icon: const Icon(TDIcons.user, size: 18),
                      title: Text(l10n.tab_user),
                      trailing: _fluentKeyCaption(context, 4),
                      body: _placeholderBody,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// macOS：不使用 [MacosWindow] 的 [Sidebar] 参数。
///
/// 内置侧栏会通过 [TransparentMacOSSidebar] 挂 NSVisualEffectView；首帧几何未稳定时
/// 会出现左右伪阴影，点菜单或调整窗口大小触发重算后才正常。此处用纯 Flutter 侧栏 + 同色底，
/// 避免该原生子视图，外观仍用 [SidebarItems] / [MacosScrollbar]。
class _OpenIoTHubMacosHomeShell extends StatefulWidget {
  const _OpenIoTHubMacosHomeShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<_OpenIoTHubMacosHomeShell> createState() =>
      _OpenIoTHubMacosHomeShellState();
}

class _OpenIoTHubMacosHomeShellState extends State<_OpenIoTHubMacosHomeShell> {
  static const double _kSidebarWidth = 220;

  /// 与 [Sidebar.topOffset] 默认一致，为交通灯留出高度。
  static const double _kSidebarTopOffset = 51;

  late final ScrollController _sidebarScrollController;

  @override
  void initState() {
    super.initState();
    _sidebarScrollController = ScrollController();
  }

  @override
  void dispose() {
    _sidebarScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = OpenIoTHubLocalizations.of(context);
    return Consumer<CustomTheme>(
      builder: (context, customTheme, _) {
        final brightness = Theme.of(context).brightness;
        final macosData = MacosThemeData(
          brightness: brightness,
          primaryColor: customTheme.primaryColor,
        );
        return MacosTheme(
          data: macosData,
          child: MacosWindow(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ColoredBox(
                  color: MacosTheme.of(context).canvasColor,
                  child: SizedBox(
                    width: _kSidebarWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: _kSidebarTopOffset),
                        Expanded(
                          child: MacosScrollbar(
                            controller: _sidebarScrollController,
                            child: SidebarItems(
                              scrollController: _sidebarScrollController,
                              currentIndex: widget.navigationShell.currentIndex,
                              onChanged: (index) {
                                widget.navigationShell.goBranch(
                                  index,
                                  initialLocation:
                                      index ==
                                      widget.navigationShell.currentIndex,
                                );
                              },
                              itemSize: SidebarItemSize.large,
                              items: [
                                SidebarItem(
                                  leading: const Icon(
                                    TDIcons.internet,
                                    size: 18,
                                  ),
                                  label: Text(l10n.tab_gateway),
                                  trailing: _macosKeyCaption(context, 1),
                                ),
                                SidebarItem(
                                  leading: const Icon(
                                    TDIcons.desktop,
                                    size: 18,
                                  ),
                                  label: Text(l10n.tab_host),
                                  trailing: _macosKeyCaption(context, 2),
                                ),
                                SidebarItem(
                                  leading: const Icon(
                                    TDIcons.control_platform,
                                    size: 18,
                                  ),
                                  label: Text(l10n.tab_smart),
                                  trailing: _macosKeyCaption(context, 3),
                                ),
                                SidebarItem(
                                  leading: const Icon(TDIcons.user, size: 18),
                                  label: Text(l10n.tab_user),
                                  trailing: _macosKeyCaption(context, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: MacosTheme.of(context).dividerColor,
                ),
                Expanded(child: widget.navigationShell),
              ],
            ),
          ),
        );
      },
    );
  }
}
