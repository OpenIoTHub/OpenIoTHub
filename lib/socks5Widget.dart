import 'package:flutter/material.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:android_intent/android_intent.dart';

class SOCKS5ListPage extends StatefulWidget {
  SOCKS5ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SOCKS5ListPageState createState() => _SOCKS5ListPageState();
}

class _SOCKS5ListPageState extends State<SOCKS5ListPage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<SessionConfig> _SessionList = [];
  List<SOCKS5Config> _SOCKS5List = [];

  @override
  void initState() {
    super.initState();
    getAllSOCKS5().then((v) {
      setState(() {});
    });
    print("init SOCKS5");
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _SOCKS5List.map(
          (pair) {
        return new ListTile(
          title: new Text(
            pair.description,
            style: _biggerFont,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.arrow_forward_ios),
            color: Colors.green,
            onPressed: () {
              _pushDetail(pair);
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
            new IconButton(
                icon: new Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    getAllSOCKS5();
                  });
                }),
            new IconButton(
                icon: new Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  getAllSession().then((v) {
                    final titles = _SessionList.map(
                          (pair) {
                        return new ListTile(
                          title: new Text(
                            pair.description,
                            style: _biggerFont,
                          ),
                          trailing: new IconButton(
                            icon: new Icon(Icons.arrow_forward_ios),
                            color: Colors.green,
                            onPressed: () {
                              _addSOCKS5(pair).then((v) {
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
                        builder: (_) => new AlertDialog(
                            title: new Text("选择一个内网："),
                            content: new ListView(
                              children: divided,
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("取消"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ])).then((v) {
                      getAllSOCKS5().then((v) {
                        setState(() {});
                      });
                    });
                  });
                }),
          ],
        ),
        body: ListView(children: divided));
  }

  Future _addSOCKS5(SessionConfig config) async {
    TextEditingController _description_controller =
    TextEditingController.fromValue(TextEditingValue(text: ""));
    TextEditingController _local_port_controller =
    TextEditingController.fromValue(TextEditingValue(text: "0"));
    TextEditingController _password_controller =
    TextEditingController.fromValue(TextEditingValue(text: "0"));
    TextEditingController _encType_controller =
    TextEditingController.fromValue(TextEditingValue(text: "127.0.0.1"));
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text("添加内网："),
            content: new ListView(
              children: <Widget>[
                new TextFormField(
                  controller: _description_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '备注',
                    helperText: '自定义备注',
                  ),
                ),
                new TextFormField(
                  controller: _local_port_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '绑定的本地端口',
                    helperText: '默认0就行了',
                  ),
                ),
                new TextFormField(
                  controller: _password_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '密码',
                    helperText: '密码',
                  ),
                ),
                new TextFormField(
                  controller: _encType_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '加密方式',
                    helperText: '加密方式',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("添加"),
                onPressed: () {
                  var socks5Config = new SOCKS5Config();
                  socks5Config.runId = config.runId;
                  socks5Config.description = _description_controller.text;
                  socks5Config.port = int.parse(_local_port_controller.text);
                  socks5Config.password = _password_controller.text;
                  socks5Config.encType = _encType_controller.text;
                  createOneSOCKS5(socks5Config).then((restlt) {
//                                :TODO 添加内网之后刷新列表
                    Navigator.of(context).pop();
                  });
                },
              )
            ]));
  }

  void _pushDetail(SOCKS5Config config) async {
    final _result = new Set<String>();
    _result.add("所属内网ID:${config.runId}");
    _result.add("描述:${config.description}");
    _result.add("端口:${config.port}");
    _result.add("密码:${config.password}");
    _result.add("加密方式:${config.encType}");
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _result.map(
                (pair) {
              return new ListTile(
                title: new Text(
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
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('详情'),
              actions: <Widget>[
                new IconButton(
                    icon: new Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                              title: new Text("删除SOCKS5"),
                              content: new Text("确认删除此SOCKS5？"),
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
                                    deleteOneSOCKS5(config).then((result) {
                                      Navigator.of(context).pop();
                                    });
//                                  ：TODO 删除之后刷新列表
                                  },
                                )
                              ])).then((v) {
                        Navigator.of(context).pop();
                      });
                    }),
              ],
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    ).then((result) {
      getAllSOCKS5().then((v) {
        setState(() {});
      });
    });
  }

  createOneSOCKS5(SOCKS5Config config) async {
    final channel = new ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = new SOCKS5Client(channel);
    try {
      final response = await stub.createOneSOCKS5(config);
      print('Greeter client received: ${response}');
      await channel.shutdown();
      return response;
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
      return false;
    }
  }

  deleteOneSOCKS5(SOCKS5Config config) async {
    final channel = new ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = new SOCKS5Client(channel);
    try {
      final response = await stub.deleteOneSOCKS5(config);
      print('Greeter client received: ${response}');
      await channel.shutdown();
      return true;
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
      return false;
    }
  }

  Future getAllSOCKS5() async {
    final channel = new ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = new SOCKS5Client(channel);
    try {
      final response = await stub.getAllSOCKS5(new Empty());
      print('Greeter client received: ${response.sOCKS5Configs}');
      await channel.shutdown();
      _SOCKS5List = response.sOCKS5Configs;
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
      return false;
    }
  }

  Future getAllSession() async {
    final channel = new ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = new SessionClient(channel);
    try {
      final response = await stub.getAllSession(new Empty());
      print('Greeter client received: ${response.sessionConfigs}');
      await channel.shutdown();
      setState(() {
        _SessionList = response.sessionConfigs;
      });
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              title: new Text("获取内网列表失败："),
              content: new Text("失败原因：$e"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("取消"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("确认"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]));
    }
  }

  _launchURL(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    await intent.launch();
  }
}
