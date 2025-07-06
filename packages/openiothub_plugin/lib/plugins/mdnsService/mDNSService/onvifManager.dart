//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:openiothub_plugin/utils/ip.dart';

import '../../../models/PortServiceInfo.dart';

//手动注册一些端口到mdns的声明，用于接入一些传统的设备或者服务或者帮助一些不方便注册mdns的设备或服务注册
//需要选择模型和输入相关配置参数
class OvifManagerPage extends StatefulWidget {
  OvifManagerPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.OnvifCameraManager";
  final PortServiceInfo device;

  @override
  _OvifManagerPageState createState() => _OvifManagerPageState();
}

class _OvifManagerPageState extends State<OvifManagerPage> {
  OpenIoTHubPluginLocalizations? localizations;
  List<dynamic> _list = [];

  @override
  void initState() {
    _getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    localizations = OpenIoTHubPluginLocalizations.of(context);
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
    String url = "http://${widget.device.addr}:${widget.device.port}/list";
    http.Response response;
    try {
      response = await http
          .get(Uri(
            scheme: 'http',
            host: widget.device.addr.endsWith(".local")
                ? await get_ip_by_domain(widget.device.addr)
                : widget.device.addr,
            port: widget.device.port,
            path: '/list',
          ))
          .timeout(const Duration(seconds: 2));
      print(response.body);
      Map<String, dynamic> rst = jsonDecode(response.body);
      if (rst["Code"] != 0) {
        return;
      }
      setState(() {
        _list = rst["OnvifDevices"];
      });
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _comfirmDeleteDevice(String XAddr) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(localizations!.confirm),
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
                    onPressed: () {
                      _deleteOneDevice(XAddr)
                          .then((value) => Navigator.of(context).pop());
                    },
                  )
                ]));
  }

  Future _deleteOneDevice(String XAddr) async {
    String url =
        "http://${widget.device.addr}:${widget.device.port}/delete?XAddr=$XAddr";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/delete',
              queryParameters: {
                "XAddr": XAddr,
              }))
          .timeout(const Duration(seconds: 2));
      print(response.body);
      _getList();
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  Future _addDeviceDialog() {
    TextEditingController _Name_controller = TextEditingController.fromValue(
        TextEditingValue(text: localizations!.onvif_camera));
    TextEditingController _XAddr_controller = TextEditingController.fromValue(
        TextEditingValue(text: "192.168.123.211:8899"));
    TextEditingController _UserName_controller =
        TextEditingController.fromValue(TextEditingValue(text: "admin"));
    TextEditingController _Password_controller =
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
                      controller: _Name_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: localizations!.name,
                        helperText: localizations!.custom_name,
                      ),
                    ),
                    TextFormField(
                      controller: _XAddr_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: localizations!.x_addr_addr,
                        helperText: localizations!.onvif_device_host_port,
                      ),
                    ),
                    TextFormField(
                        controller: _UserName_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: localizations!.username,
                          helperText: localizations!.onvif_username,
                        )),
                    TextFormField(
                        controller: _Password_controller,
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
                    onPressed: () {
                      _addOneDevice(
                              _Name_controller.text,
                              _XAddr_controller.text,
                              _UserName_controller.text,
                              _Password_controller.text)
                          .then((restlt) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  Future _addOneDevice(String Name, XAddr, UserName, Password) async {
    String url =
        "http://${widget.device.addr}:${widget.device.port}/add?Name=$Name&XAddr=$XAddr&UserName=$UserName&Password=$Password";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/add',
              queryParameters: {
                "Name": Name,
                "XAddr": XAddr,
                "UserName": UserName,
                "Password": Password,
              }))
          .timeout(const Duration(seconds: 2));
      print(response.body);
      _getList();
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}
