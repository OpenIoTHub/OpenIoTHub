import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/manager/mqttDeviceManager.pbgrpc.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';

import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:openiothub_plugin/utils/toast.dart';

import '../../../models/PortServiceInfo.dart';

class InfoPage extends StatelessWidget {
  InfoPage({required Key key, required this.portService}) : super(key: key);
  OpenIoTHubPluginLocalizations? localizations;
  PortServiceInfo portService;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    localizations = OpenIoTHubPluginLocalizations.of(context);
    //设备信息
    final List _std_key = [
      "name",
      "model",
      "mac",
      "id",
      "author",
      "email",
      "home-page",
      "firmware-respository",
      "firmware-version"
    ];
    final List _result = [];
    _result.add("${localizations!.device_name}:${portService.info!["name"]}");
    _result.add("${localizations!.device_model}:${portService.info!["model"]!.replaceAll("#", ".")}");
    _result.add("${localizations!.mac_addr}:${portService.info!["mac"]}");
    _result.add("id:${portService.info!["id"]}");
    _result.add("${localizations!.firmware_author}:${portService.info!["author"]}");
    _result.add("${localizations!.email}:${portService.info!["email"]}");
    _result.add("${localizations!.home_page}:${portService.info!["home-page"]}");
    _result.add("${localizations!.firmware_repository}:${portService.info!["firmware-respository"]}");
    _result.add("${localizations!.firmware_version}:${portService.info!["firmware-version"]}");
    _result.add("${localizations!.is_local}:${portService.isLocal ? localizations!.yes : localizations!.no}");
    _result.add("${localizations!.device_ip}:${portService.addr}");
    _result.add("${localizations!.device_port}:${portService.port}");

    portService.info!.forEach((key, value) {
      if (!_std_key.contains(key)) {
        _result.add("${key}:${value}");
      }
    });

    final tiles = _result.map(
      (pair) {
        return ListTile(
          title: Text(
            pair,
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    List<Widget> actions = <Widget>[
      IconButton(
          icon: Icon(
            Icons.edit,
            // color: Colors.white,
          ),
          onPressed: () {
            _renameDialog(context);
          }),
    ];
    if (portService.info!.containsKey("enable_delete") &&
        portService.info!["enable_delete"] == true.toString()) {
      actions.add(IconButton(
          icon: Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
          onPressed: () {
            _deleteDialog(context, portService);
          }));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.device_info),
        actions: actions,
      ),
      body: ListView(children: divided),
    );
  }

  _renameDialog(BuildContext context) async {
    TextEditingController _new_name_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: portService.info!["name"]!));
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("${localizations!.modify_device_name}："),
                content: SizedBox.expand(
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _new_name_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: '${localizations!.input_new_device_name}',
                          helperText: '${localizations!.name}',
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(localizations!.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(localizations!.modify),
                    onPressed: () async {
                      await _rename(
                          portService.info!["id"]!, _new_name_controller.text);
                      Navigator.of(context).pop();
                    },
                  )
                ])).then((restlt) {
      Navigator.of(context).pop();
    });
  }

  _rename(String id, name) async {
    CnameManager.SetCname(id, name);
  }
}

_deleteDialog(BuildContext context, PortServiceInfo portService) async {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
              title: Text("${OpenIoTHubPluginLocalizations.of(context).delete_device}："),
              content: SizedBox.expand(
                child: ListView(
                  children: <Widget>[
                    Text("${OpenIoTHubPluginLocalizations.of(context).confirm_delete_device}"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(OpenIoTHubPluginLocalizations.of(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(OpenIoTHubPluginLocalizations.of(context).delete),
                  onPressed: () async {
                    await _delete(context, portService);
                    Navigator.of(context).pop();
                  },
                )
              ])).then((restlt) {
    Navigator.of(context).pop();
  });
}

_delete(BuildContext context, PortServiceInfo portService) async {
  MqttDeviceInfo mqttDeviceInfo = MqttDeviceInfo();
  mqttDeviceInfo.deviceId = portService.info!["id"]!;
  await MqttDeviceManager.DelMqttDevice(mqttDeviceInfo);
  show_success(OpenIoTHubPluginLocalizations.of(context).delete_success, context);
}
