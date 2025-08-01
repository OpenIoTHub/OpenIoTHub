#export http_proxy=http://127.0.0.1:1087
pod repo update
cd macos
pod update
cd ios
pod update
#
flutter pub upgrade --major-versions
flutter gen-l10n
dart run flutter_launcher_icons
