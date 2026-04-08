import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openiothub/utils/ads/locale_name.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

void main() {
  testWidgets('isCnMainlandLocale true for zh_CN app locale', (tester) async {
    late bool mainland;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'CN'),
        localizationsDelegates: OpenIoTHubLocalizations.localizationsDelegates,
        supportedLocales: OpenIoTHubLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            mainland = context.isCnMainlandLocale;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();
    expect(mainland, isTrue);
  });

  testWidgets('isCnMainlandLocale false for en_US app locale', (tester) async {
    late bool mainland;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en', 'US'),
        localizationsDelegates: OpenIoTHubLocalizations.localizationsDelegates,
        supportedLocales: OpenIoTHubLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            mainland = context.isCnMainlandLocale;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();
    expect(mainland, isFalse);
  });
}
