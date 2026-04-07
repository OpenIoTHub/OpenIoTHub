import 'dart:ffi';
import 'dart:io';

import 'openiothub_mobile_service_bindings_generated.dart';

void run() => _nativeBindings.Run();

final DynamicLibrary _nativeDylib = () {
  const androidLibName = 'gojni';
  const linuxWindowsLibName = 'mobile';
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.process();
    // return DynamicLibrary.executable();
    // return DynamicLibrary.open('Client.xcframework');
    // return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid) {
    return DynamicLibrary.open('lib$androidLibName.so');
  }
  if (Platform.isLinux) {
    return DynamicLibrary.open('lib$linuxWindowsLibName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$linuxWindowsLibName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_nativeDylib].
final OpeniothubMobileServiceBindings _nativeBindings =
    OpeniothubMobileServiceBindings(_nativeDylib);
