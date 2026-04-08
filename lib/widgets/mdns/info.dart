import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/manager/mqttDeviceManager.pb.dart';

import 'package:openiothub/utils/common/toast.dart';

import 'package:openiothub/models/port_service_info.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({required Key key, required this.portService}) : super(key: key);

  final PortServiceInfo portService;

  @override
  Widget build(BuildContext context) {
    final l10n = OpenIoTHubLocalizations.of(context);
    //设备信息
    final List stdKey = [
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
    final List result = [];
    result.add("${l10n.device_name}:${portService.info!["name"]}");
    result.add("${l10n.device_model}:${portService.info!["model"]!.replaceAll("#", ".")}");
    result.add("${l10n.mac_addr}:${portService.info!["mac"]}");
    result.add("id:${portService.info!["id"]}");
    result.add("${l10n.firmware_author}:${portService.info!["author"]}");
    result.add("${l10n.email}:${portService.info!["email"]}");
    result.add("${l10n.home_page}:${portService.info!["home-page"]}");
    result.add("${l10n.firmware_repository}:${portService.info!["firmware-respository"]}");
    result.add("${l10n.firmware_version}:${portService.info!["firmware-version"]}");
    result.add("${l10n.is_local}:${portService.isLocal ? l10n.yes : l10n.no}");
    result.add("${l10n.device_ip}:${portService.addr}");
    result.add("${l10n.device_port}:${portService.port}");

    portService.info!.forEach((key, value) {
      if (!stdKey.contains(key)) {
        result.add("$key:$value");
      }
    });

    final tiles = result.map(
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
        title: Text(l10n.device_info),
        actions: actions,
      ),
      body: ListView(children: divided),
    );
  }

  Future<void> _renameDialog(BuildContext context) async {
    final l10n = OpenIoTHubLocalizations.of(context);
    TextEditingController newNameController =
        TextEditingController.fromValue(
            TextEditingValue(text: portService.info!["name"]!));
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("${l10n.modify_device_name}："),
                content: SizedBox.expand(
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: newNameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: l10n.input_new_device_name,
                          helperText: l10n.name,
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(l10n.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(l10n.modify),
                    onPressed: () async {
                      await _rename(
                          portService.info!["id"]!, newNameController.text);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  Future<void> _rename(String id, name) async {
    CnameManager.setCname(id, name);
  }
}

Future<void> _deleteDialog(BuildContext context, PortServiceInfo portService) async {
  await showDialog(
      context: context,
      builder: (_) => AlertDialog(
              title: Text("${OpenIoTHubLocalizations.of(context).delete_device}："),
              content: SizedBox.expand(
                child: ListView(
                  children: <Widget>[
                    Text(OpenIoTHubLocalizations.of(context)
                        .plugin_confirm_delete_device),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(OpenIoTHubLocalizations.of(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(OpenIoTHubLocalizations.of(context).delete),
                  onPressed: () async {
                    await _delete(context, portService);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                )
              ]));
}

Future<void> _delete(BuildContext context, PortServiceInfo portService) async {
  MqttDeviceInfo mqttDeviceInfo = MqttDeviceInfo();
  mqttDeviceInfo.deviceId = portService.info!["id"]!;
  await MqttDeviceManager.delMqttDevice(mqttDeviceInfo);
  if (!context.mounted) return;
  showSuccess(OpenIoTHubLocalizations.of(context).plugin_delete_success, context);
}
