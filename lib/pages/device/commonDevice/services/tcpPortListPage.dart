import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nat_explorer/api/CommonDeviceApi.dart';
import 'package:nat_explorer/pages/openWithChoice/OpenWithChoice.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class TcpPortListPage extends StatefulWidget {
  TcpPortListPage({Key key, this.device}) : super(key: key);

  Device device;

  @override
  _TcpPortListPageState createState() => _TcpPortListPageState();
}

class _TcpPortListPageState extends State<TcpPortListPage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;
  final rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );
  List<PortConfig> _ServiceList = [];
  @override
  void initState() {
    super.initState();
    refreshmTcpList();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map(
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
                "${pair.description}(${pair.remotePort})",
                style: _biggerFont,
              )),
              rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            //打开此端口的详情
            _pushDetail(pair);
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
        title: Text("TCP端口列表"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                //刷新端口列表
                refreshmTcpList();
              }),
          IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              onPressed: () {
//                添加TCP端口
                _addTCP(widget.device).then((v){
                  refreshmTcpList();
                });
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  void _pushDetail(PortConfig config) async {
    final List _result = [];
    _result.add("端口:${config.remotePort}");
    _result.add("映射到端口:${config.localProt}");
    _result.add("描述:${config.description}");
    _result.add("转发连接状态:${config.remotePortStatus ? "在线" : "离线"}");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _result.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: _biggerFont,
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
              title: Text('端口详情'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      //删除
                      _deleteCurrentTCP(config);
                    }),
                IconButton(
                  icon: Icon(
                    Icons.open_in_browser,
                    color: Colors.white,
                  ),
                  onPressed: () {
    //                TODO 使用某种方式打开此端口，检查这个软件是否已经安装
//                    _launchURL("http://127.0.0.1:${config.localProt}");
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                            title: Text("添加端口："),
                            content: OpenWithChoice(),
                        ));
                  }),
              ]
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Future refreshmTcpList() async {
    try {
      CommonDeviceApi.getAllTCP(widget.device).then((v) {
        setState(() {
          _ServiceList = v.portConfigs;
        });
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future _addTCP(Device device) async {
    TextEditingController _description_controller =
    TextEditingController.fromValue(TextEditingValue(text: "我的TCP"));
    TextEditingController _remote_port_controller =
    TextEditingController.fromValue(TextEditingValue(text: "80"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text("添加端口："),
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
                  controller: _remote_port_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '端口号',
                    helperText: '该机器的端口号',
                  ),
                )
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
                  var tcpConfig = PortConfig();
                  tcpConfig.device = device;
                  tcpConfig.description = _description_controller.text;
                  tcpConfig.remotePort =
                      int.parse(_remote_port_controller.text);
                  CommonDeviceApi.createOneTCP(tcpConfig).then((restlt) {
                    Navigator.of(context).pop();
                  });
                },
              )
            ]));
  }

  Future _deleteCurrentTCP(PortConfig config) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text("删除TCP"),
            content: new Text("确认删除此TCP？"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("删除"),
                onPressed: () {
                  CommonDeviceApi.deleteOneTCP(config).then((result) {
                    Navigator.of(context).pop();
                  });
                },
              )
            ]))
        .then((v) {
              Navigator.of(context).pop();
            }
    ).then((v){
      refreshmTcpList();
    });
  }

  _launchURL(String url) async {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    await intent.launch();
  }
}
