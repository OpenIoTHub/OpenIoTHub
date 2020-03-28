rm -rf Runner
#flutter build ios --debug --no-codesign
flutter build ios
mkdir Runner
mkdir Runner/Payload
cp -r build/ios/iphoneos/Runner.app Runner/Payload/Runner.app
cd Runner
zip -r Runner.ipa Payload
open Payload