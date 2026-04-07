//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub/plugin/openiothub_plugin.dart';
import 'package:openiothub/plugin/utils/ip.dart';

import 'package:openiothub/plugin/models/port_service_info.dart';

//手动注册一些端口到mdns的声明，用于接入一些传统的设备或者服务或者帮助一些不方便注册mdns的设备或服务注册
//需要选择模型和输入相关配置参数
class OvifManagerPage extends StatefulWidget {
  const OvifManagerPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.OnvifCameraManager";
  final PortServiceInfo device;

  @override
  State<OvifManagerPage> createState() => OvifManagerPageState();
}

class OvifManagerPageState extends State<OvifManagerPage> {
  OpenIoTHubLocalizations? localizations;
  List<dynamic> _list = [];

  @override
  void initState() {
    _getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    localizations = OpenIoTHubLocalizations.of(context);
    final tiles = _list.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.devices),
              ),
              Expanded(
                  child: Text(
                "${pair["Name"]}(${pair["XAddr"]})",
                style: Constants.titleTextStyle,
              )),
              Constants.rightArrowIcon
            ],
          ),
        );
        return InkWell(
          child: listItemContent,
          onTap: () {
            //删除
            _comfirmDeleteDevice(pair["XAddr"]);
          },
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.onvif_camera_manager),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {
                _getList();
              }),
          IconButton(
              icon: Icon(
                Icons.add_circle,
                // color: Colors.white,
              ),
              onPressed: () {
                _addDeviceDialog();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.green,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  _info() async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  Future _getList() async {
    http.Response response;
    try {
      response = await http
          .get(Uri(
            scheme: 'http',
            host: widget.device.addr.endsWith(".local")
                ? await getIpByDomain(widget.device.addr)
                : widget.device.addr,
            port: widget.device.port,
            path: '/list',
          ))
          .timeout(const Duration(seconds: 2));
      debugPrint(response.body);
      Map<String, dynamic> rst = jsonDecode(response.body);
      if (rst["Code"] != 0) {
        return;
      }
      if (!mounted) return;
      setState(() {
        _list = rst["OnvifDevices"];
      });
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  _comfirmDeleteDevice(String xAddr) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(localizations!.plugin_confirm),
                content: SizedBox.expand(
                  child: Text(localizations!.confirm_delete_onvif_device),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(localizations!.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(localizations!.delete),
                    onPressed: () async {
                      await _deleteOneDevice(xAddr);
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  Future _deleteOneDevice(String xAddr) async {
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await getIpByDomain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/delete',
              queryParameters: {
                "XAddr": xAddr,
              }))
          .timeout(const Duration(seconds: 2));
      debugPrint(response.body);
      _getList();
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  Future _addDeviceDialog() {
    TextEditingController nameController = TextEditingController.fromValue(
        TextEditingValue(text: localizations!.onvif_camera));
    TextEditingController xAddrController = TextEditingController.fromValue(
        TextEditingValue(text: "192.168.123.211:8899"));
    TextEditingController userNameController =
        TextEditingController.fromValue(TextEditingValue(text: "admin"));
    TextEditingController passwordController =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: SizedBox.expand(
                  child: Text(localizations!.add_onvif_camera),
                ),
                content: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: localizations!.name,
                        helperText: localizations!.custom_name,
                      ),
                    ),
                    TextFormField(
                      controller: xAddrController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: localizations!.x_addr_addr,
                        helperText: localizations!.onvif_device_host_port,
                      ),
                    ),
                    TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: localizations!.username,
                          helperText: localizations!.onvif_username,
                        )),
                    TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: localizations!.password,
                          helperText: localizations!.onvif_password,
                        ))
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(localizations!.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(localizations!.add),
                    onPressed: () async {
                      await _addOneDevice(
                        nameController.text,
                        xAddrController.text,
                        userNameController.text,
                        passwordController.text,
                      );
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  Future _addOneDevice(String name, xAddr, userName, password) async {
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await getIpByDomain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/add',
              queryParameters: {
                "Name": name,
                "XAddr": xAddr,
                "UserName": userName,
                "Password": password,
              }))
          .timeout(const Duration(seconds: 2));
      debugPrint(response.body);
      _getList();
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }
}
