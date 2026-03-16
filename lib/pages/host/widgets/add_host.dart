import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/common_pages/utils/toast.dart';
import 'package:openiothub/network/openiothub/common_device_api.dart';
import 'package:openiothub/network/openiothub/session_api.dart';
import 'package:openiothub/network/utils/uuid.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub/core/app_spacing.dart';

class AddHostWidget extends StatefulWidget {
  const AddHostWidget({super.key});

  @override
  State<AddHostWidget> createState() => _AddHostWidgetState();
}

class _AddHostWidgetState extends State<AddHostWidget> {
  List<SessionConfig> _sessionList = [];
  Map<String, String> _hostAddrMap = {};
  String selectedHostAddrDropdownValue = '';
  String selectedRunIdDropdownValue = '';

  TextEditingController nameController =
      TextEditingController.fromValue(TextEditingValue(text: ""));
  TextEditingController descriptionController =
      TextEditingController.fromValue(TextEditingValue(text: ""));
  TextEditingController remoteIpController =
      TextEditingController.fromValue(TextEditingValue(text: ""));

  @override
  void initState() {
    super.initState();
    getAllSession().then((_) {
      getHostList(_sessionList.first.runId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (nameController.text.isEmpty) {
      setState(() {
        nameController.text =
            OpenIoTHubLocalizations.of(context).internal_network_devices;
      });
    }
    if (descriptionController.text.isEmpty) {
      setState(() {
        descriptionController.text =
            OpenIoTHubLocalizations.of(context).internal_network_devices;
      });
    }
    if (remoteIpController.text.isEmpty) {
      setState(() {
        remoteIpController.text = "127.0.0.1";
      });
    }

    if (selectedRunIdDropdownValue.isEmpty && _sessionList.isNotEmpty) {
      selectedRunIdDropdownValue = _sessionList.first.runId;
    }

    return AlertDialog(
        title: Text(OpenIoTHubLocalizations.of(context).add_device),
        content: SizedBox(
            width: 250,
            height: 400,
            child: ListView(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: _sessionList.isEmpty ? null : _sessionList.first.runId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRunIdDropdownValue = newValue!;
                      getHostList(selectedRunIdDropdownValue);
                    });
                  },
                  items: _sessionList.map<DropdownMenuItem<String>>(
                      (SessionConfig sessionConfig) {
                    return DropdownMenuItem<String>(
                      value: sessionConfig.runId,
                      child: Text(sessionConfig.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: OpenIoTHubLocalizations.of(context).choose_an_network),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: AppSpacing.listTileDensePadding,
                    labelText: OpenIoTHubLocalizations.of(context).name,
                    helperText:
                        OpenIoTHubLocalizations.of(context).custom_remarks,
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    contentPadding: AppSpacing.listTileDensePadding,
                    labelText: OpenIoTHubLocalizations.of(context).description,
                    helperText:
                        OpenIoTHubLocalizations.of(context).custom_remarks,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedHostAddrDropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedHostAddrDropdownValue = newValue!;
                    });
                  },
                  items: buildMenuItems(_hostAddrMap),
                  decoration:
                      InputDecoration(labelText: OpenIoTHubLocalizations.of(context).choose_an_host_address),
                ),
                TextFormField(
                  // TODO 从可选项中选择主机地址，也可以进行填写
                  controller: remoteIpController,
                  decoration: InputDecoration(
                    contentPadding: AppSpacing.listTileDensePadding,
                    labelText: OpenIoTHubLocalizations.of(context)
                        .ip_address_of_remote_intranet,
                    helperText: OpenIoTHubLocalizations.of(context)
                        .ip_address_of_internal_network_devices,
                  ),
                  enabled: selectedHostAddrDropdownValue.isEmpty,
                ),
              ],
            )),
        actions: <Widget>[
          TextButton(
            child: Text(OpenIoTHubLocalizations.of(context).cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(OpenIoTHubLocalizations.of(context).add),
            onPressed: () async {
              var device = Device();
              device.runId = selectedRunIdDropdownValue;
              device.uuid = getOneUUID();
              device.name = nameController.text;
              device.description = descriptionController.text;
              if (selectedHostAddrDropdownValue.isEmpty) {
                device.addr = remoteIpController.text;
              } else {
                device.addr = selectedHostAddrDropdownValue;
              }
              await createOneCommonDevice(device);
              Navigator.of(context).pop();
            },
          )
        ]);
  }

  List<DropdownMenuItem<String>> buildMenuItems(Map<String, String> items) {
    List<DropdownMenuItem<String>> menuItems = [];
    items.forEach((addr, name) {
      menuItems.add(DropdownMenuItem<String>(
        value: addr, // 下拉菜单项的值，可以是任何对象，通常用于标识选择
        child: Text(
            "$addr(${name.contains(RegExp("@")) ?
            name.split("@").last.substring(0, name.split("@").last.length > 15 ? 15 : name.split("@").last.length)
                : name.substring(0, name.length > 15 ? 15 : name.length)}...)"), // 显示给用户的文本
      ));
    });
    return menuItems;
  }

  Future createOneCommonDevice(Device device) async {
    try {
      await CommonDeviceApi.createOneDevice(device);
    } catch (e) {
      showFailed(
          "${OpenIoTHubLocalizations.of(context).create_device_failed}：$e",
          context);
    }
  }

  Future getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('Greeter client received: ${response.sessionConfigs}');
      setState(() {
        _sessionList = response.sessionConfigs;
      });
    } catch (e) {
      showFailed("getAllSession：$e", context);
    }
    return _sessionList;
  }

  // TODO 从mdns获取所有主机地址，并添加“手动填写”， “127.0.0.1”
  Future getHostList(String runId) async {
    SessionApi.getAllTCP(SessionConfig(runId: runId)).then((v) {
      setState(() {
        setState(() {
          _hostAddrMap.clear();
          _hostAddrMap.addAll({"": OpenIoTHubLocalizations.of(context).fill_in_below, "127.0.0.1": "localhost"});
        });
        v.portConfigs.forEach((PortConfig portConfig) {
          if (!_hostAddrMap.containsKey(portConfig.device.addr)) {
            setState(() {
              _hostAddrMap.addAll({
                portConfig.device.addr: portConfig.description.isEmpty
                    ? portConfig.name
                    : portConfig.description
              });
            });
          }
        });
      });
    });
  }
}
