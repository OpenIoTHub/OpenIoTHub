import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/providers/custom_theme.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:provider/provider.dart';

/// 主题色选择器：弹窗选择主题色
void showThemeColorPicker(BuildContext context) {
  final customTheme = context.read<CustomTheme>();
  final l10n = OpenIoTHubLocalizations.of(context);
  final currentColor = customTheme.primaryColor;

  showModalBottomSheet<void>(
    context: context,
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                l10n.theme_color,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...ThemeUtils.supportColors.map((color) {
                    final isSelected =
                        currentColor.toARGB32() == color.toARGB32();
                    return ListTile(
                      leading: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.grey,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                      ),
                      title: Text(_getColorName(color, l10n)),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () async {
                        await customTheme.setThemeColor(color);
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// 用于设置页等的「主题色」列表项，点击打开选择器
Widget themeColorSettingTile(BuildContext context) {
  final customTheme = context.watch<CustomTheme>();
  final currentColor = customTheme.primaryColor;
  final l10n = OpenIoTHubLocalizations.of(context);
  final colorName = _getColorName(currentColor, l10n);

  return ListTile(
    leading: const Icon(Icons.palette),
    title: Text(l10n.theme_color),
    subtitle: Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: currentColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1),
          ),
        ),
        const SizedBox(width: 8),
        Text(colorName),
      ],
    ),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => showThemeColorPicker(context),
  );
}

/// 全页主题色选择；路由名见 [AppRoutes.themeColorPicker]。
class ThemeColorPickerPage extends StatelessWidget {
  const ThemeColorPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = context.watch<CustomTheme>();
    final currentColor = customTheme.primaryColor;
    final l10n = OpenIoTHubLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.theme_color)),
      body: ListView(
        children: [
          ...ThemeUtils.supportColors.map((color) {
            final isSelected =
                currentColor.toARGB32() == color.toARGB32();
            return ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.grey,
                    width: isSelected ? 3 : 1,
                  ),
                ),
              ),
              title: Text(_getColorName(color, l10n)),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () async {
                await customTheme.setThemeColor(color);
                if (context.mounted) Navigator.of(context).pop();
              },
            );
          }),
        ],
      ),
    );
  }
}

/// 获取颜色名称
String _getColorName(Color color, OpenIoTHubLocalizations l10n) {
  final c = color.toARGB32();
  if (c == Colors.blue.toARGB32()) return l10n.color_blue;
  if (c == Colors.purple.toARGB32()) return l10n.color_purple;
  if (c == Colors.orange.toARGB32()) return l10n.color_orange;
  if (c == Colors.deepPurpleAccent.toARGB32()) return l10n.color_deep_purple;
  if (c == Colors.redAccent.toARGB32()) return l10n.color_red;
  if (c == Colors.lightBlue.toARGB32()) return l10n.color_light_blue;
  if (c == Colors.amber.toARGB32()) return l10n.color_amber;
  if (c == Colors.green.toARGB32()) return l10n.color_green;
  if (c == Colors.lime.toARGB32()) return l10n.color_lime;
  if (c == Colors.indigo.toARGB32()) return l10n.color_indigo;
  if (c == Colors.cyan.toARGB32()) return l10n.color_cyan;
  if (c == Colors.teal.toARGB32()) return l10n.color_teal;
  if (c == ThemeUtils.lightGrey.toARGB32()) return l10n.color_light_grey;
  return l10n.color_unknown;
}
