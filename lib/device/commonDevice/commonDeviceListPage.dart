import 'package:flutter/material.dart';
import 'package:nat_explorer/api/CommonDeviceApi.dart';
import 'package:nat_explorer/api/SessionApi.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:android_intent/android_intent.dart';

import 'commonDeviceServiceTypesList.dart';

class CommonDeviceListPage extends StatefulWidget {
  CommonDeviceListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CommonDeviceListPageState createState() => _CommonDeviceListPageState();
}

class _CommonDeviceListPageState extends State<CommonDeviceListPage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<SessionConfig> _SessionList = [];
  List<Device> _CommonDeviceList = [];

  @override
  void initState() {
    super.initState();
    getAllCommonDevice().then((v) {
      setState(() {});
    });
    print("init common devie List");
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _CommonDeviceList.map(
      (pair) {
        return ListTile(
          title: Text(
            pair.description,
            style: _biggerFont,
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            color: Colors.green,
            onPressed: () {
              _pushDeviceServiceTypes(pair);
            },
          ),
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
                        return ListTile(
                          title: Text(
                            pair.description,
                            style: _biggerFont,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            color: Colors.green,
                            onPressed: () {
                              _addDevice(pair).then((v) {
                                Navigator.of(context).pop();
                              });
                            },
                          ),
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
                                  FlatButton(
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
        TextEditingController.fromValue(TextEditingValue(text: ""));
    TextEditingController _remote_ip_controller =
        TextEditingController.fromValue(TextEditingValue(text: "127.0.0.1"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("添加内网："),
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
                  FlatButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("添加"),
                    onPressed: () {
                      var device = Device();
                      device.runId = config.runId;
                      device.description = _description_controller.text;
                      device.addr =_remote_ip_controller.text;
                      createOneCommonDevice(device).then((v){
                        getAllCommonDevice().then((v){
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
          return CommonDeviceServiceTypesList(device);
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
    }catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
              title: Text("创建设备失败："),
              content: Text("失败原因：$e"),
              actions: <Widget>[
                FlatButton(
                  child: Text("取消"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
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
      setState(() {
        _CommonDeviceList = response.devices;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("获取内网列表失败："),
                  content: Text("失败原因：$e"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  _launchURL(String url) async {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    await intent.launch();
  }
}
