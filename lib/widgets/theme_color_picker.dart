import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/utils/theme_utils.dart';
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
                '主题色',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            ...ThemeUtils.supportColors.map((color) {
              final isSelected = currentColor.value == color.value;
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
                title: Text(_getColorName(color)),
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
      );
    },
  );
}

/// 用于设置页等的「主题色」列表项，点击打开选择器
Widget themeColorSettingTile(BuildContext context) {
  final customTheme = context.watch<CustomTheme>();
  final currentColor = customTheme.primaryColor;
  final colorName = _getColorName(currentColor);

  return ListTile(
    leading: const Icon(Icons.palette),
    title: const Text('主题色'),
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

/// 路由名称，供设置页 pushNamed 使用
const String kRouteThemeColorPicker = '/theme-color-picker';

/// 全页主题色选择：用于 /theme-color-picker 路由，设置页通过 pushNamed 打开
class ThemeColorPickerPage extends StatelessWidget {
  const ThemeColorPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = context.watch<CustomTheme>();
    final currentColor = customTheme.primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text('主题色')),
      body: ListView(
        children: [
          ...ThemeUtils.supportColors.map((color) {
            final isSelected = currentColor.value == color.value;
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
              title: Text(_getColorName(color)),
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
String _getColorName(Color color) {
  if (color.value == Colors.blue.value) return '蓝色';
  if (color.value == Colors.purple.value) return '紫色';
  if (color.value == Colors.orange.value) return '橙色';
  if (color.value == Colors.deepPurpleAccent.value) return '深紫色';
  if (color.value == Colors.redAccent.value) return '红色';
  if (color.value == Colors.lightBlue.value) return '浅蓝色';
  if (color.value == Colors.amber.value) return '琥珀色';
  if (color.value == Colors.green.value) return '绿色';
  if (color.value == Colors.lime.value) return '青柠色';
  if (color.value == Colors.indigo.value) return '靛蓝色';
  if (color.value == Colors.cyan.value) return '青色';
  if (color.value == Colors.teal.value) return '青绿色';
  if (color.value == ThemeUtils.lightGrey.value) return '浅灰色';
  return '未知颜色';
}
