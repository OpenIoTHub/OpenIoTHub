import 'package:flutter/material.dart';

import 'app_spacing.dart';

/// 应用统一装饰（边框、分割线等）
///
/// 与主题配合使用，保证列表、卡片、按钮轮廓等视觉一致。
class AppDecorations {
  AppDecorations._();

  /// 分割线/轮廓线颜色（浅色模式下为灰色；深色模式建议用 Theme.dividerColor）
  static const Color dividerColor = Colors.grey;

  /// 分割线边框，用于 ListTile、Button 轮廓等
  static const BorderSide dividerBorder = BorderSide(
    color: dividerColor,
    width: 1,
  );

  /// 标准圆角矩形边框（如卡片、弹窗）
  static BorderRadius get cardBorderRadius =>
      BorderRadius.circular(AppSpacing.radiusCard);

  /// 小号圆角
  static BorderRadius get smallBorderRadius =>
      BorderRadius.circular(AppSpacing.radiusSm);
}
