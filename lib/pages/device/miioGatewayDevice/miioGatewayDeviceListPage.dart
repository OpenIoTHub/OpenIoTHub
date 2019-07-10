import 'package:flutter/material.dart';
import 'package:nat_explorer/api/MiioGatewayDeviceApi.dart';
import 'package:nat_explorer/api/SessionApi.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:android_intent/android_intent.dart';
import 'miioGatewaySubDeviceTypesList.dart';

class MiioGatewayDeviceListPage extends StatefulWidget {
  MiioGatewayDeviceListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MiioGatewayDeviceListPageState createState() => _MiioGatewayDeviceListPageState();
}

class _MiioGatewayDeviceListPageState extends State<MiioGatewayDeviceListPage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<SessionConfig> _SessionList = [];
  List<MiioGatewayDevice> _MiioGatewayDeviceList = [];

  @override
  void initState() {
    super.initState();
    getAllMiioGatewayDevice().then((v) {
      setState(() {});
    });
    print("init MiioGateway devie List");
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _MiioGatewayDeviceList.map(
      (pair) {
        return ListTile(
          title: Text(
            pair.addr,
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
                  getAllMiioGatewayDevice().then((v) {
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
                      getAllMiioGatewayDevice().then((v) {
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
    TextEditingController _remote_ip_controller =
        TextEditingController.fromValue(TextEditingValue(text: "127.0.0.1"));
    TextEditingController _token_controller =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("添加设备："),
                content: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _remote_ip_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '远程内网的IP',
                        helperText: '内网设备的IP',
                      ),
                    ),
                    TextFormField(
                      controller: _token_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: 'token',
                        helperText: '秘钥',
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
                      var device = MiioGatewayDevice();
                      device.runId = config.runId;
                      device.key = _token_controller.text;
                      device.addr =_remote_ip_controller.text;
                      createOneMiioGatewayDevice(device).then((v){
                        getAllMiioGatewayDevice().then((v){
                          Navigator.of(context).pop();
                        });
                      });
                    },
                  )
                ]));
  }

  void _pushDeviceServiceTypes(MiioGatewayDevice device) async {
  // 查看设备下的服务 MiioGatewayDeviceServiceTypesList
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return MiioGatewaySubDeviceTypesList(device: device,);
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

  Future createOneMiioGatewayDevice(MiioGatewayDevice device) async {
    try {
      await MiioGatewayDeviceApi.createOneDevice(device);
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

  Future getAllMiioGatewayDevice() async {
    try {
      final response = await MiioGatewayDeviceApi.getAllDevice();
      setState(() {
        _MiioGatewayDeviceList = response.miioGatewayDevices;
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
