import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/app/providers/custom_theme.dart';
import 'package:openiothub/router/core/app_routes.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:provider/provider.dart';

List<Widget> _themeColorPickerTiles({
  required BuildContext context,
  required CustomTheme customTheme,
  required OpenIoTHubLocalizations l10n,
  required VoidCallback onDone,
  required double leadingSize,
  required double selectedBorderWidth,
}) {
  final systemAccent = customTheme.primaryColor;
  final systemSelected = customTheme.useSystemAccent;

  final systemTile = ListTile(
    leading: Container(
      width: leadingSize,
      height: leadingSize,
      decoration: BoxDecoration(
        color: systemAccent,
        shape: BoxShape.circle,
        border: Border.all(
          color: systemSelected ? Colors.white : Colors.grey,
          width: systemSelected ? selectedBorderWidth : 1,
        ),
      ),
    ),
    title: Text(l10n.theme_mode_follow_system),
    trailing:
        systemSelected ? const Icon(Icons.check, color: Colors.green) : null,
    onTap: () async {
      await customTheme.setUseSystemAccent();
      if (context.mounted) onDone();
    },
  );

  final presetTiles = ThemeUtils.supportColors.map((color) {
    final isSelected =
        !customTheme.useSystemAccent &&
        customTheme.customPrimaryColor.toARGB32() == color.toARGB32();
    return ListTile(
      leading: Container(
        width: leadingSize,
        height: leadingSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey,
            width: isSelected ? selectedBorderWidth : 1,
          ),
        ),
      ),
      title: Text(_getColorName(color, l10n)),
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () async {
        await customTheme.setThemeColor(color);
        if (context.mounted) onDone();
      },
    );
  });

  return [systemTile, ...presetTiles];
}

/// 主题色选择器：弹窗选择主题色
void showThemeColorPicker(BuildContext context) {
  final customTheme = context.read<CustomTheme>();
  final l10n = OpenIoTHubLocalizations.of(context);

  if (openIoTHubUseDesktopHomeLayout) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final dialogL10n = OpenIoTHubLocalizations.of(ctx);
        final tiles = _themeColorPickerTiles(
          context: ctx,
          customTheme: customTheme,
          l10n: dialogL10n,
          onDone: () => Navigator.of(ctx).pop(),
          leadingSize: 24,
          selectedBorderWidth: 2,
        );
        return AlertDialog(
          title: Text(dialogL10n.theme_color),
          content: SizedBox(
            width: 380,
            height: 440,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(children: tiles),
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
                l10n.theme_color,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: _themeColorPickerTiles(
                  context: ctx,
                  customTheme: customTheme,
                  l10n: l10n,
                  onDone: () => Navigator.of(ctx).pop(),
                  leadingSize: 24,
                  selectedBorderWidth: 2,
                ),
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
  final colorName =
      customTheme.useSystemAccent
          ? l10n.theme_mode_follow_system
          : _getColorName(customTheme.customPrimaryColor, l10n);

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
    final l10n = OpenIoTHubLocalizations.of(context);

    final tiles = _themeColorPickerTiles(
      context: context,
      customTheme: customTheme,
      l10n: l10n,
      onDone: () => Navigator.of(context).pop(),
      leadingSize: 32,
      selectedBorderWidth: 3,
    );
    final list = ListView(children: tiles);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.theme_color)),
      body: openIoTHubDesktopConstrainedBody(
        maxWidth: 480,
        child:
            openIoTHubUseDesktopHomeLayout
                ? Scrollbar(thumbVisibility: true, child: list)
                : list,
      ),
    );
  }
}

/// 获取颜色名称
String _getColorName(Color color, OpenIoTHubLocalizations l10n) {
  final c = color.toARGB32();
  if (c == ThemeUtils.windowsAccentBlue.toARGB32() ||
      c == ThemeUtils.macosSystemBlue.toARGB32() ||
      c == ThemeUtils.linuxDesktopAccentBlue.toARGB32()) {
    return l10n.color_blue;
  }
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
