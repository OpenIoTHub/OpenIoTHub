
import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'openiothub_mobile_service_bindings_generated.dart';

void run() => _bindings_prebuild.Run();

final DynamicLibrary _dylib_prebuild = () {
  var _android_libName_prebuild = "gojni";
  var _linux_windows_libName_prebuild = "mobile";
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.process();
    // return DynamicLibrary.executable();
    // return DynamicLibrary.open('Client.xcframework');
    // return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid) {
    return DynamicLibrary.open('lib$_android_libName_prebuild.so');
  }
  if (Platform.isLinux) {
    return DynamicLibrary.open('lib$_linux_windows_libName_prebuild.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_linux_windows_libName_prebuild.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final OpeniothubMobileServiceBindings _bindings_prebuild = OpeniothubMobileServiceBindings(_dylib_prebuild);
