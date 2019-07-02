import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:nat_explorer/sessionmDNSServiceListPage.dart';
import './api/SessionApi.dart';

class SessionListPage extends StatefulWidget {
  SessionListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SessionListPageState createState() => _SessionListPageState();
}

class _SessionListPageState extends State<SessionListPage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<SessionConfig> _SessionList = [];

  @override
  void initState() {
    super.initState();
    getAllSession().then((v) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _SessionList.map(
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
              _pushmDNSServices(pair);
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
          leading: IconButton(
              icon: Icon(
                Icons.pages,
                color: Colors.white,
              ),
              onPressed: () {}),
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  getAllSession();
                }),
            IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  TextEditingController _token_controller =
                  TextEditingController.fromValue(TextEditingValue(text: ""));
                  TextEditingController _description_controller =
                  TextEditingController.fromValue(TextEditingValue(text: "我的网络"));
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                              title: Text("添加网络："),
                              content: ListView(
                                children: <Widget>[
                                  TextFormField(
                                    controller: _token_controller,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: '请输入内网端Token',
                                      helperText: 'token',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _description_controller,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: '请输入备注',
                                      helperText: '备注',
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
                                    SessionConfig config = SessionConfig();
                                    config.token = _token_controller.text;
                                    config.description =
                                        _description_controller.text;
                                    createOneSession(config).then((restlt) {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                )
                              ])).then((restlt) {
                    setState(() {
                      getAllSession();
                    });
                  });
                }),
          ],
        ),
        body: ListView(children: divided));
  }

  void _pushmDNSServices(SessionConfig config) async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    PortList portList = await SessionApi.getAllTCP(config);
    final List<PortConfig> _result = portList.portConfigs;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _result.map(
                (pair) {
              return ListTile(
                title: Text(
                  '${pair.device.addr}:${pair.remotePort} -> ${pair.localProt}',
                  style: _biggerFont,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: Colors.green,
                  onPressed: () {
                    //直接打开内置web浏览器浏览页面
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return WebviewScaffold(
                        url: "http://127.0.0.1:${pair.localProt}",
                        appBar: new AppBar(
                          title: new Text("网页浏览器"),
                        ),
                      );
                    }));
                  },
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          //:TODO 写成独立的组件，支持刷新
          return MDNSServiceListPage(sessionConfig: config);
        },
      ),
    ).then((result) {
      setState(() {
        getAllSession();
      });
    });
  }

  void _pushDetail(SessionConfig config) async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    final List _result = [];
    _result.add("ID:${config.runId}");
    _result.add("描述:${config.description}");
    _result.add("连接码:${config.token}");
    _result.add("转发连接状态:${config.statusToClient ? "在线" : "离线"}");
    _result.add(
        "P2P连接状态:${config.statusP2PAsClient || config.statusP2PAsServer ? "在线" : "离线"}");
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
              title: Text('详情'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                  title: Text("删除内网"),
                                  content: Text("确认删除此内网？"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("取消"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("删除"),
                                      onPressed: () {
                                        var ses = SessionConfig();
                                        ses.runId = config.runId;
                                        deleteOneSession(ses).then((result) {
                                          setState(() {
                                            getAllSession();
                                          });
                                        });
//                                  ：TODO 删除之后刷新列表
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]));
                    }),
              ],
            ),
            body: ListView(children: divided),
          );
        },
      ),
    ).then((result) {
      setState(() {
        getAllSession();
      });
    });
  }

  Future createOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.createOneSession(config);
      print('Greeter client received: ${response}');
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future deleteOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.deleteOneSession(config);
      print('Greeter client received: ${response}');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("删除结果："),
                  content: Text("删除成功！"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ])).then((result) {
                      Navigator.of(context).pop();
                    }
      );
    } catch (e) {
      print('Caught error: $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("删除结果："),
                  content: Text("删除失败！$e"),
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

  Future refreshmDNSServices(SessionConfig sessionConfig) async {
    try {
      await SessionApi.refreshmDNSServices(sessionConfig);
    } catch (e) {
      print('Caught error: $e');
    }
  }
}
