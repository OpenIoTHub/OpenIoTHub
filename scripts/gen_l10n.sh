#!/bin/bash
set -e

echo "Generating localizations..."
flutter gen-l10n

echo "All localizations generated successfully!"
