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

#小米不支持前台服务插件
#华为不支持穿山甲
#谷歌不支持优量汇和穿山甲
#荣耀不支持“广告不支持终止下载”,可能不支持穿山甲