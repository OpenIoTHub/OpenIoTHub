import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startInternalPluginService() {
  FlutterForegroundTask.setTaskHandler(InternalPluginServiceHandler());
}

class InternalPluginServiceHandler extends TaskHandler {
  int _count = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // some code
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    _count++;

    FlutterForegroundTask.updateService(notificationText: "云亿连(OpenIoTHub) is Running");

    // Send data to main isolate.
    FlutterForegroundTask.sendDataToMain("云亿连(OpenIoTHub) is Running");
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    return;
  }
}
