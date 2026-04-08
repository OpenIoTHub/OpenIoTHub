import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 是否在桌面端使用侧栏式主页壳（与移动端底部导航区分）。
/// 使用 [defaultTargetPlatform] 而非 `dart:io`，以便 Web 等目标也能通过分析/编译。
bool get openIoTHubUseDesktopHomeLayout {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

/// 主页 Tab 快捷键角标（仅桌面），用于侧栏 [trailing] 等。
String openIoTHubHomeTabKeyCaption(int indexOneBased) {
  if (!openIoTHubUseDesktopHomeLayout) return '';
  if (indexOneBased < 1 || indexOneBased > 9) return '';
  if (defaultTargetPlatform == TargetPlatform.macOS) {
    return '⌘$indexOneBased';
  }
  return 'Ctrl+$indexOneBased';
}

/// 桌面端将主体靠上对齐；默认 [maxWidth] 为铺满父级（侧栏内容区等）。
/// 表单、登录等可传入有限 [maxWidth]；移动端原样返回 [child]。
Widget openIoTHubDesktopConstrainedBody({
  required Widget child,
  double maxWidth = double.infinity,
}) {
  if (!openIoTHubUseDesktopHomeLayout) return child;
  return Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

/// 桌面端列表：限宽 + 常驻滚动条；移动端仅返回 [scrollable]。
Widget openIoTHubDesktopScrollableListBody({
  required Widget scrollable,
  double maxWidth = double.infinity,
}) {
  final wrapped =
      openIoTHubUseDesktopHomeLayout
          ? Scrollbar(thumbVisibility: true, child: scrollable)
          : scrollable;
  return openIoTHubDesktopConstrainedBody(maxWidth: maxWidth, child: wrapped);
}
