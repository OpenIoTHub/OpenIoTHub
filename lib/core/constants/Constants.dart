import 'package:flutter/material.dart';

import 'AppSpacing.dart';

class Constants {
  static final String DOC_WEBSITE_URL = "https://space.bilibili.com/1222749704";
  static final double ARROW_ICON_WIDTH = 16.0;

  /// 列表标题样式（与主题 titleMedium 对齐）
  static final titleTextStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
  /// 列表副标题样式（与主题 bodySmall 灰色对齐）
  static final subTitleTextStyle = const TextStyle(color: Colors.grey);
  static final rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  /// 列表 ListTile 水平内边距，与 [AppSpacing.listTileContentPadding] 一致
  static const listTileContentPadding = AppSpacing.listTileContentPadding;
  /// 列表分隔线左侧缩进
  static const double listDividerIndent = AppSpacing.listDividerIndent;
}
