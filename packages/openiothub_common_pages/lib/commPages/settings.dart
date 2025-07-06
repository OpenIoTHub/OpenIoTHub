import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub_common_pages/openiothub_common_pages.dart';

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

//  New
  final TextEditingController _grpcServiceHost =
      TextEditingController(text: Config.webgRpcIp);
  final TextEditingController _grpcServicePort =
      TextEditingController(text: Config.webgRpcPort.toString());

  final TextEditingController _iotManagerGrpcServiceHost =
      TextEditingController(text: Config.iotManagerGrpcIp);

  @override
  Widget build(BuildContext context) {
    List<Widget> listView = <Widget>[
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
            await prefs.setBool("foreground", newValue);
            setState(() {
              foreground = newValue;
            });
          },
          value: foreground,
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
    _initConfig();
    super.initState();
  }

  Future<void> _initConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey("foreground")) {
      setState(() async {
        foreground = (await prefs.getBool("foreground"))!;
      });
    } else {
      prefs.setBool("foreground", false);
    }
  }
}
