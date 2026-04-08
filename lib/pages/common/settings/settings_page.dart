import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub/pages/common/openiothub_common_pages.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/app/service/internal_plugin_service.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:openiothub/widgets/theme/theme_color_picker.dart';
import 'package:openiothub/widgets/theme/theme_mode_picker.dart';
import 'package:openiothub/widgets/locale/language_picker.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({required Key key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool foreground = false;
  bool autoStartGateway = false;
  bool wakeLock = false;

  //  New
  final TextEditingController _grpcServiceHost = TextEditingController(
    text: Config.webgRpcIp,
  );
  final TextEditingController _grpcServicePort = TextEditingController(
    text: Config.webgRpcPort.toString(),
  );

  final TextEditingController _iotManagerGrpcServiceHost =
      TextEditingController(text: Config.iotManagerGrpcIp);

  @override
  Widget build(BuildContext context) {
    List<Widget> listView = <Widget>[
      languageSettingTile(context),
      themeModeSettingTile(context),
      themeColorSettingTile(context),
      TDInput(
        controller: _grpcServiceHost,
        backgroundColor: Colors.white,
        leftLabel: OpenIoTHubLocalizations.of(context).grpc_server_addr,
        hintText: OpenIoTHubLocalizations.of(context).grpc_server_ip_or_domain,
        onChanged: (String v) {
          Config.webgRpcIp = v;
        },
      ),
      TDInput(
        controller: _grpcServicePort,
        backgroundColor: Colors.white,
        leftLabel: OpenIoTHubLocalizations.of(context).grpc_service_port,
        hintText: OpenIoTHubLocalizations.of(context).input_grpc_service_port,
        onChanged: (String v) {
          Config.webgRpcPort = int.parse(v);
        },
      ),
      TDInput(
        controller: _iotManagerGrpcServiceHost,
        backgroundColor: Colors.white,
        leftLabel: OpenIoTHubLocalizations.of(context).iot_manager_addr,
        hintText: OpenIoTHubLocalizations.of(context).input_iot_manager_addr,
        onChanged: (String v) {
          Config.iotManagerGrpcIp = v;
        },
      ),
    ];
    if (Platform.isAndroid) {
      listView.add(
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                OpenIoTHubLocalizations.of(context).activate_front_desk_service,
                style: Constants.titleTextStyle,
              ),
            ],
          ),
          trailing: Switch(
            onChanged: (bool newValue) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool(
                SharedPreferencesKey.forgeRoundTaskEnable,
                newValue,
              );
              setState(() {
                foreground = newValue;
              });
              if (newValue) {
                try {
                  InternalPluginService.instance.init();
                  // 前台服务仅在应用进入后台时启动，见 [handleAndroidForegroundServiceLifecycle]。
                } catch (e) {
                  debugPrint('$e');
                }
              } else {
                try {
                  InternalPluginService.instance.stop();
                } catch (e) {
                  debugPrint('$e');
                }
              }
            },
            value: foreground,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
          ),
        ),
      );
      listView.add(
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                OpenIoTHubLocalizations.of(context).auto_start_gateway,
                style: Constants.titleTextStyle,
              ),
            ],
          ),
          trailing: Switch(
            onChanged: (bool newValue) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool(
                SharedPreferencesKey.startGatewayWhenAppStart,
                newValue,
              );
              setState(() {
                autoStartGateway = newValue;
              });
            },
            value: autoStartGateway,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
          ),
        ),
      );
      listView.add(
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                OpenIoTHubLocalizations.of(context).wake_lock_enabled,
                style: Constants.titleTextStyle,
              ),
            ],
          ),
          trailing: Switch(
            onChanged: (bool newValue) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool(
                SharedPreferencesKey.wakeLockEnabled,
                newValue,
              );
              setState(() {
                wakeLock = newValue;
              });
              WakelockPlus.toggle(enable: newValue);
            },
            value: wakeLock,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
          ),
        ),
      );
    }
    final list = ListView(children: listView);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: openIoTHubDesktopConstrainedBody(
        maxWidth: 680,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              openIoTHubUseDesktopHomeLayout
                  ? Scrollbar(thumbVisibility: true, child: list)
                  : list,
        ),
      ),
    );
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
    bool? forgeRound = prefs.getBool(SharedPreferencesKey.forgeRoundTaskEnable);
    if (forgeRound != null && forgeRound) {
      setState(() {
        foreground = true;
      });
    }
  }

  Future _getAutoStartGatewayStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? autoStart = prefs.getBool(
      SharedPreferencesKey.startGatewayWhenAppStart,
    );
    if (autoStart == null || autoStart) {
      setState(() {
        autoStartGateway = true;
      });
    }
  }

  Future _getWakeLockStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? wakeLockEnabled = prefs.getBool(SharedPreferencesKey.wakeLockEnabled);
    if (wakeLockEnabled != null && wakeLockEnabled) {
      setState(() {
        wakeLock = true;
      });
    }
  }
}
