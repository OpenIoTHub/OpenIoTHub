import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:provider/provider.dart';

import './commonDeviceServiceTypesList.dart';

class CommonDeviceListPage extends StatefulWidget {
  CommonDeviceListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CommonDeviceListPageState createState() => _CommonDeviceListPageState();
}

class _CommonDeviceListPageState extends State<CommonDeviceListPage> {
  List<SessionConfig> _SessionList = [];
  List<Device> _CommonDeviceList = [];
  Timer _timerPeriod;

  @override
  void initState() {
    super.initState();
    getAllCommonDevice();
    _timerPeriod = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      getAllCommonDevice();
    });
    print("init common devie List");
  }

  @override
  void dispose() {
    super.dispose();
    if (_timerPeriod != null) {
      _timerPeriod.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _CommonDeviceList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(Icons.devices,
              color: Provider.of<CustomTheme>(context).themeValue == "dark"
                  ? CustomThemes.dark.accentColor
                  : CustomThemes.light.accentColor),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(pair.description, style: Constants.titleTextStyle),
            ],
          ),
          trailing: Constants.rightArrowIcon,
        );
        return InkWell(
          onTap: () {
            _pushDeviceServiceTypes(pair);
          },
          child: listItemContent,
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  getAllCommonDevice().then((v) {
                    setState(() {});
                  });
                }),
            IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  getAllSession().then((v) {
                    final titles = _SessionList.map(
                      (pair) {
                        var listItemContent = Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.cloud_done),
                              Expanded(
                                  child: Text(
                                pair.description,
                                style: Constants.titleTextStyle,
                              )),
                              Constants.rightArrowIcon
                            ],
                          ),
                        );
                        return InkWell(
                          onTap: () {
                            _addDevice(pair).then((v) {
                              Navigator.of(context).pop();
                            });
                          },
                          child: listItemContent,
                        );
                      },
                    );
                    final divided = ListTile.divideTiles(
                      context: context,
                      tiles: titles,
                    ).toList();
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                                title: Text("选择一个内网："),
                                content: ListView(
                                  children: divided,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("取消"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ])).then((v) {
                      getAllCommonDevice().then((v) {
                        setState(() {});
                      });
                    });
                  });
                }),
          ],
        ),
        body: ListView(children: divided));
  }

  Future _addDevice(SessionConfig config) async {
    TextEditingController _description_controller =
        TextEditingController.fromValue(TextEditingValue(text: "内网设备"));
    TextEditingController _remote_ip_controller =
        TextEditingController.fromValue(TextEditingValue(text: "127.0.0.1"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("添加设备："),
                content: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _description_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '备注',
                        helperText: '自定义备注',
                      ),
                    ),
                    TextFormField(
                      controller: _remote_ip_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '远程内网的IP',
                        helperText: '内网设备的IP',
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("添加"),
                    onPressed: () {
                      var device = Device();
                      device.runId = config.runId;
                      device.description = _description_controller.text;
                      device.addr = _remote_ip_controller.text;
                      createOneCommonDevice(device).then((v) {
                        getAllCommonDevice().then((v) {
                          Navigator.of(context).pop();
                        });
                      });
                    },
                  )
                ]));
  }

  void _pushDeviceServiceTypes(Device device) async {
    // 查看设备下的服务 CommonDeviceServiceTypesList
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return CommonDeviceServiceTypesList(
            device: device,
          );
        },
      ),
    ).then((result) {
      setState(() {
        getAllSession();
      });
    });
  }

  Future getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('Greeter client received: ${response.sessionConfigs}');
      setState(() {
        _SessionList = response.sessionConfigs;
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future createOneCommonDevice(Device device) async {
    try {
      await CommonDeviceApi.createOneDevice(device);
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("创建设备失败："),
                  content: Text("失败原因：$e"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  Future getAllCommonDevice() async {
    try {
      final response = await CommonDeviceApi.getAllDevice();
      print("=====getAllDevice:${response.devices}");
      setState(() async {
        await _CommonDeviceList.clear();
        _CommonDeviceList = response.devices;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("获取内网列表失败："),
                  content: Text("失败原因：$e"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }
}
