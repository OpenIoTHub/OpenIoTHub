#!/bin/bash
set -e

echo "Generating main app localizations..."
flutter gen-l10n

# l10n.yaml at project root overrides CLI args, so temporarily rename it
mv l10n.yaml l10n.yaml.bak

echo "Generating common_pages localizations..."
flutter gen-l10n \
  --arb-dir=lib/common_pages/l10n \
  --output-dir=lib/common_pages/l10n/generated \
  --output-class=OpenIoTHubCommonLocalizations \
  --output-localization-file=openiothub_common_localizations.dart \
  --template-arb-file=intl_en.arb \
  --preferred-supported-locales='["en"]' \
  --no-synthetic-package \
  --no-nullable-getter \
  --format

echo "Generating plugin localizations..."
flutter gen-l10n \
  --arb-dir=lib/plugin/l10n \
  --output-dir=lib/plugin/l10n/generated \
  --output-class=OpenIoTHubPluginLocalizations \
  --output-localization-file=openiothub_plugin_localizations.dart \
  --template-arb-file=intl_en.arb \
  --preferred-supported-locales='["en"]' \
  --no-synthetic-package \
  --no-nullable-getter \
  --format

mv l10n.yaml.bak l10n.yaml

echo "All localizations generated successfully!"
