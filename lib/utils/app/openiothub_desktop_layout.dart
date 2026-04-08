import 'dart:math' as math;

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

/// 主页网关 / 主机 / 智能设备卡片网格：按宽度自动分列，单列最小卡片宽度约 [minTileWidth]。
int openIoTHubGridCrossAxisCount(
  double maxWidth, {
  double minTileWidth = 168,
  double horizontalPadding = 12,
  double spacing = 12,
}) {
  final usable = maxWidth - horizontalPadding * 2;
  if (usable <= minTileWidth) return 1;
  final n = ((usable + spacing) / (minTileWidth + spacing)).floor();
  return math.max(1, n);
}

/// 由稳定 key 生成头像底色，避免每次 rebuild 随机变色。
Color openIoTHubStableAccentFromKey(String key) {
  final h = key.hashCode;
  return Color.fromRGBO(
    50 + (h.abs() % 156),
    50 + ((h >> 7).abs() % 156),
    50 + ((h >> 14).abs() % 156),
    1,
  );
}

/// RunId / UUID 等长串：中间省略，控制展示长度（含省略号）。
String openIoTHubMiddleEllipsis(String s, {int maxChars = 24}) {
  if (s.length <= maxChars) return s;
  const ell = '…';
  final avail = maxChars - ell.length;
  if (avail < 2) return s.substring(0, maxChars);
  final left = avail ~/ 2;
  final right = avail - left;
  return '${s.substring(0, left)}$ell${s.substring(s.length - right)}';
}

/// 主页卡片：列数随宽度变化，每张卡片高度由内容决定（非固定 aspectRatio）。
Widget openIoTHubHomeCardWrap({
  required double maxWidth,
  required List<Widget> cards,
  double horizontalPadding = 12,
  double topPadding = 12,
  double bottomPadding = 24,
  double spacing = 12,
}) {
  final n = openIoTHubGridCrossAxisCount(
    maxWidth,
    horizontalPadding: horizontalPadding,
    spacing: spacing,
  );
  final inner = maxWidth - horizontalPadding * 2;
  final tileW = (inner - spacing * (n - 1)) / n;
  return Padding(
    padding: EdgeInsets.fromLTRB(
      horizontalPadding,
      topPadding,
      horizontalPadding,
      bottomPadding,
    ),
    child: Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        for (final c in cards) SizedBox(width: tileW, child: c),
      ],
    ),
  );
}
