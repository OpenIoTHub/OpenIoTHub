import 'dart:io';

int getTitleCharLens(){
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return 65;
  }
  return 30;
}