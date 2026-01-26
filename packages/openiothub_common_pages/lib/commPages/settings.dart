import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:provider/provider.dart';

import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub/configs/consts.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/service/internal_plugin_service.dart';
import 'package:openiothub/widgets/theme_color_picker.dart';
import 'package:openiothub/widgets/theme_mode_picker.dart';
import 'package:openiothub/widgets/language_picker.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    required Key key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool foreground = false;
  bool auto_start_gateway = false;
  bool wakeLock = false;

//  New
  final TextEditingController _grpcServiceHost =
      TextEditingController(text: Config.webgRpcIp);
  final TextEditingController _grpcServicePort =
      TextEditingController(text: Config.webgRpcPort.toString());

  final TextEditingController _iotManagerGrpcServiceHost =
      TextEditingController(text: Config.iotManagerGrpcIp);

  @override
  Widget build(BuildContext context) {
    final l10n = OpenIoTHubLocalizations.of(context);
    List<Widget> listView = <Widget>[
      languageSettingTile(context),
      themeModeSettingTile(context),
      themeColorSettingTile(context),
      TDInput(
        controller: _grpcServiceHost,
        backgroundColor: Colors.white,
        leftLabel: OpenIoTHubCommonLocalizations.of(context).grpc_server_addr,
        hintText: OpenIoTHubCommonLocalizations.of(context).grpc_server_ip_or_domain,
        onChanged: (String v) {
          Config.webgRpcIp = v;
        },
      ),
      TDInput(
        controller: _grpcServicePort,
        backgroundColor: Colors.white,
        leftLabel: OpenIoTHubCommonLocalizations.of(context).grpc_service_port,
        hintText: OpenIoTHubCommonLocalizations.of(context).input_grpc_service_port,
        onChanged: (String v) {
          Config.webgRpcPort = int.parse(v);
        },
      ),
      TDInput(
        controller: _iotManagerGrpcServiceHost,
        backgroundColor: Colors.white,
        leftLabel: OpenIoTHubCommonLocalizations.of(context).iot_manager_addr,
        hintText: OpenIoTHubCommonLocalizations.of(context).input_iot_manager_addr,
        onChanged: (String v) {
          Config.iotManagerGrpcIp = v;
        },
      ),
    ];
    if (Platform.isAndroid) {
      listView.add(ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(OpenIoTHubCommonLocalizations.of(context).activate_front_desk_service, style: Constants.titleTextStyle),
          ],
        ),
        trailing: Switch(
          onChanged: (bool newValue) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool(SharedPreferencesKey.FORGE_ROUND_TASK_ENABLE, newValue);
            setState(() {
              foreground = newValue;
            });
            if (newValue) {
              // _requestPlatformPermissions();
              try{
                InternalPluginService.instance.init();
                InternalPluginService.instance.start();
              } catch (e) {
                print(e);
              }
            }else{
              try{
                InternalPluginService.instance.stop();
              } catch (e) {
                print(e);
              }
            }
          },
          value: foreground,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
        ),
      ));
      listView.add(ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(OpenIoTHubCommonLocalizations.of(context).auto_start_gateway, style: Constants.titleTextStyle),
          ],
        ),
        trailing: Switch(
          onChanged: (bool newValue) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool(SharedPreferencesKey.START_GATEWAY_WHEN_APP_START, newValue);
            setState(() {
              auto_start_gateway = newValue;
            });
          },
          value: auto_start_gateway,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
        ),
      ));
      listView.add(ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(OpenIoTHubCommonLocalizations.of(context).wake_lock_enabled, style: Constants.titleTextStyle),
          ],
        ),
        trailing: Switch(
          onChanged: (bool newValue) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool(SharedPreferencesKey.WAKE_LOCK, newValue);
            setState(() {
              wakeLock = newValue;
            });
            WakelockPlus.toggle(enable: newValue);
          },
          value: wakeLock,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
        ),
      ));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: listView,
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _getForgeServiceStatus();
    _getAutoStartGatewayStatus();
    _getWakeLockStatus();
  }

  Future _getForgeServiceStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? FORGE_ROUND = await prefs.getBool(SharedPreferencesKey.FORGE_ROUND_TASK_ENABLE);
    if (FORGE_ROUND != null && FORGE_ROUND) {
      setState(() {
        foreground = true;
      });
    }
  }

  Future _getAutoStartGatewayStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? autoStart = prefs.getBool(SharedPreferencesKey.START_GATEWAY_WHEN_APP_START);
    if (autoStart == null || autoStart) {
      setState(() {
        auto_start_gateway = true;
      });
    }
  }

  Future _getWakeLockStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? WAKE_LOCK_ENABLED = await prefs.getBool(SharedPreferencesKey.WAKE_LOCK);
    if (WAKE_LOCK_ENABLED != null && WAKE_LOCK_ENABLED) {
      setState(() {
        wakeLock = true;
      });
    }
  }

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
}
