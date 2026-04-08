import 'package:flutter/material.dart';

/// 应用统一间距与圆角
///
/// 列表、卡片、页面边距等应优先使用此类常量，避免魔法数字。
class AppSpacing {
  AppSpacing._();

  // ---------- 基础间距 (4 的倍数) ----------
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // ---------- 列表相关 ----------
  /// 列表项水平内边距（左右）
  static const double listHorizontal = 16.0;

  /// 列表项垂直内边距（上下）
  static const double listVertical = 12.0;

  /// ListTile contentPadding 水平
  static const EdgeInsets listTileContentPadding = EdgeInsets.fromLTRB(
    16,
    0,
    16,
    0,
  );

  /// 列表分隔线左侧缩进（与 leading 对齐）
  static const double listDividerIndent = 70.0;

  /// 设置/个人中心等列表左侧缩进（略小于主列表）
  static const double settingsListIndent = 50.0;

  /// 列表项内部小块水平间距（如图标与文字）；紧凑列表 contentPadding 同此值
  static const double listItemInnerPadding = 10.0;

  /// 紧凑列表/弹窗内 ListTile 的 contentPadding
  static const EdgeInsets listTileDensePadding = EdgeInsets.all(10.0);

  // ---------- 页面边距 ----------
  static const double pageHorizontal = 16.0;
  static const double pageVertical = 16.0;

  // ---------- 圆角 ----------
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusCard = 8.0;

  // ---------- 空状态 / 引导页 ----------
  static const double emptyStateMinHeightOffset = 200.0;
  static const double emptyIllustrationSize = 160.0;
  static const double emptyStateSpacing = 16.0;
  static const double emptyStateButtonSpacing = 12.0;

  /// 列表页顶部留白（如工具列表）
  static const double listPageTopPadding = 20.0;

  /// 桌面侧栏右侧主内容区与窗口边缘的内边距（鼠标操作留白、避免贴边）
  static const EdgeInsets desktopShellContentInsets = EdgeInsets.fromLTRB(
    20,
    10,
    24,
    16,
  );
}

/// 便捷 EdgeInsets
class AppInsets {
  AppInsets._();

  static const EdgeInsets listTile = EdgeInsets.fromLTRB(
    AppSpacing.listHorizontal,
    0,
    AppSpacing.listHorizontal,
    0,
  );
  static const EdgeInsets listTileWithVertical = EdgeInsets.fromLTRB(
    AppSpacing.listHorizontal,
    AppSpacing.listVertical,
    AppSpacing.listHorizontal,
    AppSpacing.listVertical,
  );
  static const EdgeInsets page = EdgeInsets.all(AppSpacing.pageHorizontal);
  static const EdgeInsets listItemRow = EdgeInsets.fromLTRB(
    AppSpacing.listItemInnerPadding,
    AppSpacing.listVertical,
    AppSpacing.listItemInnerPadding,
    AppSpacing.listVertical,
  );
}
