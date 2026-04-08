import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/providers/custom_theme.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/utils/openiothub_desktop_layout.dart';
import 'package:provider/provider.dart';

List<Widget> _themeModePickerTiles({
  required BuildContext context,
  required CustomTheme customTheme,
  required AppThemeMode currentMode,
  required OpenIoTHubLocalizations l10n,
  required VoidCallback onDone,
}) {
  return AppThemeMode.values.map((mode) {
    final isSelected = currentMode == mode;
    return ListTile(
      leading: Icon(_getModeIcon(mode)),
      title: Text(_getModeName(mode, l10n)),
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () async {
        await customTheme.setThemeMode(mode);
        if (context.mounted) onDone();
      },
    );
  }).toList();
}

/// 主题模式选择器：弹窗选择主题模式
void showThemeModePicker(BuildContext context) {
  final customTheme = context.read<CustomTheme>();
  final l10n = OpenIoTHubLocalizations.of(context);
  final currentMode = customTheme.themeMode;

  if (openIoTHubUseDesktopHomeLayout) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final dialogL10n = OpenIoTHubLocalizations.of(ctx);
        final tiles = _themeModePickerTiles(
          context: ctx,
          customTheme: customTheme,
          currentMode: currentMode,
          l10n: dialogL10n,
          onDone: () => Navigator.of(ctx).pop(),
        );
        return AlertDialog(
          title: Text(dialogL10n.theme_mode),
          content: SizedBox(
            width: 360,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(
                shrinkWrap: true,
                children: tiles,
              ),
            ),
          ),
        );
      },
    );
    return;
  }

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
            ..._themeModePickerTiles(
              context: ctx,
              customTheme: customTheme,
              currentMode: currentMode,
              l10n: l10n,
              onDone: () => Navigator.of(ctx).pop(),
            ),
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

/// 全页主题模式选择；路由名见 [AppRoutes.themeModePicker]。
class ThemeModePickerPage extends StatelessWidget {
  const ThemeModePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = context.watch<CustomTheme>();
    final currentMode = customTheme.themeMode;
    final l10n = OpenIoTHubLocalizations.of(context);

    final tiles = _themeModePickerTiles(
      context: context,
      customTheme: customTheme,
      currentMode: currentMode,
      l10n: l10n,
      onDone: () => Navigator.of(context).pop(),
    );
    final list = ListView(children: tiles);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.theme_mode)),
      body: openIoTHubDesktopConstrainedBody(
        maxWidth: 480,
        child: openIoTHubUseDesktopHomeLayout
            ? Scrollbar(
                thumbVisibility: true,
                child: list,
              )
            : list,
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
