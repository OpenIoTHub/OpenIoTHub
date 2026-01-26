import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/model/locale_provider.dart';
import 'package:provider/provider.dart';

/// 各语言的本地化显示名称
const Map<String, String> _localeDisplayNames = {
  'en': 'English',
  'zh': '简体中文',
  'zh_TW': '繁體中文',
  'ja': '日本語',
  'ko': '한국어',
  'de': 'Deutsch',
  'es': 'Español',
  'fr': 'Français',
  'it': 'Italiano',
  'ru': 'Русский',
  'ar': 'العربية',
};

String _localeToKey(Locale? locale) {
  if (locale == null) return 'system';
  if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
    return '${locale.languageCode}_${locale.countryCode}';
  }
  return locale.languageCode;
}

bool _localesEqual(Locale? a, Locale? b) {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  return a.languageCode == b.languageCode &&
      (a.countryCode ?? '') == (b.countryCode ?? '');
}

/// 语言选择器：弹窗选择语言，支持「跟随系统」及 11 种语言
void showLanguagePicker(BuildContext context) {
  final localeProvider = context.read<LocaleProvider>();
  final l10n = OpenIoTHubLocalizations.of(context);
  final currentLocale = localeProvider.locale;

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
                l10n.language,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  // 跟随系统
                  ListTile(
                    title: Text(l10n.follow_system),
                    trailing: _localesEqual(currentLocale, null)
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () async {
                      await localeProvider.setLocale(null);
                      if (ctx.mounted) Navigator.of(ctx).pop();
                    },
                  ),
                  const Divider(height: 1),
                  ...LocaleProvider.supportedLocales.map((locale) {
                    final key = _localeToKey(locale);
                    final name = _localeDisplayNames[key] ?? key;
                    final isSelected = _localesEqual(currentLocale, locale);
                    return ListTile(
                      title: Text(name),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () async {
                        await localeProvider.setLocale(locale);
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

/// 用于设置页等的「语言」列表项，点击打开选择器
Widget languageSettingTile(BuildContext context) {
  final localeProvider = context.watch<LocaleProvider>();
  final l10n = OpenIoTHubLocalizations.of(context);
  final key = _localeToKey(localeProvider.locale);
  final label = localeProvider.locale == null
      ? l10n.follow_system
      : (_localeDisplayNames[key] ?? key);

  return ListTile(
    leading: const Icon(Icons.language),
    title: Text(l10n.language),
    subtitle: Text(label),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => showLanguagePicker(context),
  );
}

/// 路由名称，供登录页、设置页 pushNamed 使用
const String kRouteLanguagePicker = '/language-picker';

/// 全页语言选择：用于 /language-picker 路由，登录页与设置页通过 pushNamed 打开
class LanguagePickerPage extends StatelessWidget {
  const LanguagePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final l10n = OpenIoTHubLocalizations.of(context);
    final currentLocale = localeProvider.locale;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.language)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.follow_system),
            trailing: _localesEqual(currentLocale, null)
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () async {
              await localeProvider.setLocale(null);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          const Divider(height: 1),
          ...LocaleProvider.supportedLocales.map((locale) {
            final key = _localeToKey(locale);
            final name = _localeDisplayNames[key] ?? key;
            final isSelected = _localesEqual(currentLocale, locale);
            return ListTile(
              title: Text(name),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () async {
                await localeProvider.setLocale(locale);
                if (context.mounted) Navigator.of(context).pop();
              },
            );
          }),
        ],
      ),
    );
  }
}
