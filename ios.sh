rm -rf Runner
flutter build ios --debug --no-codesign
mkdir Runner
mkdir Runner/Payload
cp -r build/ios/iphoneos/Runner.app Runner/Payload/Runner.app
cd Runner
zip -r Runner.ipa Payload