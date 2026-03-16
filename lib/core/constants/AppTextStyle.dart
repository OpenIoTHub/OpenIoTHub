import 'package:flutter/material.dart';

/// 应用统一文字样式
///
/// 与 ThemeData.textTheme 配合使用；此处提供不依赖 Theme 的静态样式，
/// 用于与 [Constants.titleTextStyle] / [Constants.subTitleTextStyle] 对齐。
class AppTextStyle {
  AppTextStyle._();

  /// 列表标题：16sp 加粗
  static const TextStyle listTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  /// 列表副标题：灰色
  static const TextStyle listSubtitle = TextStyle(
    color: Colors.grey,
  );

  /// 小号说明文字
  static const TextStyle caption = TextStyle(
    color: Colors.grey,
    fontSize: 12.0,
  );
}
