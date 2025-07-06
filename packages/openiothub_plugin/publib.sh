dart pub global run intl_utils:generate
dart run build_runner build
export https_proxy=127.0.0.1:1087
unset PUB_HOSTED_URL
flutter packages pub publish -f --server=https://pub.dartlang.org