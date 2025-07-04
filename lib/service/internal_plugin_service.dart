import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'internal_plugin_service_handler.dart';

typedef TaskMessageCallback = void Function(String message);

class InternalPluginService {
  InternalPluginService._();

  static final InternalPluginService instance = InternalPluginService._();

  // ------------- Service API -------------
  Future<void> _requestPlatformPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      // Use this utility only if you provide services that require long-term survival,
      // such as exact alarm service, healthcare service, or Bluetooth communication.
      //
      // This utility requires the "android.permission.SCHEDULE_EXACT_ALARM" permission.
      // Using this permission may make app distribution difficult due to Google policy.
      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        // When you call this function, will be gone to the settings page.
        // So you need to explain to the user why set it.
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }
  }

  void init() {
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'openiothub_service',
        channelName: 'OpenIoTHub Service',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> start() async {
    await _requestPlatformPermissions();

    final ServiceRequestResult result =
        await FlutterForegroundTask.startService(
      serviceId: 100,
      notificationTitle: '云亿连(OpenIoTHub)',
      notificationText: '',
      callback: startInternalPluginService,
    );

    if (result is ServiceRequestFailure) {
      throw result.error;
    }
  }

  Future<void> stop() async {
    final ServiceRequestResult result =
        await FlutterForegroundTask.stopService();

    if (result is ServiceRequestFailure) {
      throw result.error;
    }
  }

  Future<bool> get isRunningService => FlutterForegroundTask.isRunningService;

  // ------------- Service callback -------------
  final List<TaskMessageCallback> _callbacks = [];

  void _onReceiveTaskData(Object data) {
    if (data is! String) {
      return;
    }

    for (final TaskMessageCallback callback in _callbacks.toList()) {
      callback(data);
    }
  }

  void addTaskMessageCallback(TaskMessageCallback callback) {
    if (!_callbacks.contains(callback)) {
      _callbacks.add(callback);
    }
  }

  void removeTaskMessageCallback(TaskMessageCallback callback) {
    _callbacks.remove(callback);
  }
}
