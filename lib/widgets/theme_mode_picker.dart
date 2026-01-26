import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:provider/provider.dart';

/// 主题模式选择器：弹窗选择主题模式
void showThemeModePicker(BuildContext context) {
  final customTheme = context.read<CustomTheme>();
  final l10n = OpenIoTHubLocalizations.of(context);
  final currentMode = customTheme.themeMode;

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
                l10n.theme_mode,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            ...AppThemeMode.values.map((mode) {
              final isSelected = currentMode == mode;
              return ListTile(
                leading: Icon(_getModeIcon(mode)),
                title: Text(_getModeName(mode, l10n)),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () async {
                  await customTheme.setThemeMode(mode);
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

/// 用于设置页等的「主题模式」列表项，点击打开选择器
Widget themeModeSettingTile(BuildContext context) {
  final customTheme = context.watch<CustomTheme>();
  final currentMode = customTheme.themeMode;
  final l10n = OpenIoTHubLocalizations.of(context);
  final modeName = _getModeName(currentMode, l10n);

  return ListTile(
    leading: const Icon(Icons.brightness_6),
    title: Text(l10n.theme_mode),
    subtitle: Text(modeName),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => showThemeModePicker(context),
  );
}

/// 路由名称，供设置页 pushNamed 使用
const String kRouteThemeModePicker = '/theme-mode-picker';

/// 全页主题模式选择：用于 /theme-mode-picker 路由，设置页通过 pushNamed 打开
class ThemeModePickerPage extends StatelessWidget {
  const ThemeModePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = context.watch<CustomTheme>();
    final currentMode = customTheme.themeMode;
    final l10n = OpenIoTHubLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.theme_mode)),
      body: ListView(
        children: [
          ...AppThemeMode.values.map((mode) {
            final isSelected = currentMode == mode;
            return ListTile(
              leading: Icon(_getModeIcon(mode)),
              title: Text(_getModeName(mode, l10n)),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () async {
                await customTheme.setThemeMode(mode);
                if (context.mounted) Navigator.of(context).pop();
              },
            );
          }),
        ],
      ),
    );
  }
}

/// 获取主题模式图标
IconData _getModeIcon(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.automatic:
      return Icons.brightness_auto;
    case AppThemeMode.light:
      return Icons.brightness_high;
    case AppThemeMode.dark:
      return Icons.brightness_low;
  }
}

/// 获取主题模式名称
String _getModeName(AppThemeMode mode, OpenIoTHubLocalizations l10n) {
  switch (mode) {
    case AppThemeMode.automatic:
      return l10n.theme_mode_follow_system;
    case AppThemeMode.light:
      return l10n.theme_mode_light;
    case AppThemeMode.dark:
      return l10n.theme_mode_dark;
  }
}
