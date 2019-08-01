import 'dart:io';

class RunBin {
//  TODO 用这种方式替换库运行的可能性
  static runBin() async {
    const path = "assets/bin/natcloud";
    ProcessResult processResult = await Process.run(
        "chmod", ["777", path]);
    print(processResult.stdout);
    Process.run(path,[]);
  }
}