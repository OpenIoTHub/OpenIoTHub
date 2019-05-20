import 'package:flutter/material.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

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
          leading: new IconButton(
              icon: new Icon(
                Icons.pages,
                color: Colors.white,
              ),
              onPressed: () {}),
          title: Text(widget.title),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  getAllSession();
                }),
            new IconButton(
                icon: new Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  TextEditingController _token_controller =
                      TextEditingController.fromValue(
                          TextEditingValue(text: ""));
                  TextEditingController _description_controller =
                      TextEditingController.fromValue(
                          TextEditingValue(text: ""));
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                              title: new Text("添加内网："),
                              content: new ListView(
                                children: <Widget>[
                                  new TextFormField(
                                    controller: _token_controller,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: '请输入内网端Token',
                                      helperText: 'token',
                                    ),
                                  ),
                                  new TextFormField(
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
                                new FlatButton(
                                  child: new Text("取消"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("添加"),
                                  onPressed: () {
                                    SessionConfig config = new SessionConfig();
                                    config.token = _token_controller.text;
                                    config.description =
                                        _description_controller.text;
                                    createOneSession(config).then((restlt) {
//                                :TODO 添加内网之后刷新列表
                                      Navigator.of(context).pop();
                                    });
                                  },
                                )
                              ])).then((restlt) {
//                                :TODO 添加内网之后刷新列表
                    setState(() {
                      getAllSession();
                    });
                  });
                }),
          ],
        ),
        body: ListView(children: divided));
  }

  void _pushDetail(SessionConfig config) async {
    final _result = new Set<String>();
    _result.add("ID:${config.runId}");
    _result.add("描述:${config.description}");
    _result.add("连接码:${config.token}");
    _result.add("转发连接状态:${config.statusToClient ? "在线" : "离线"}");
    _result.add(
        "P2P连接状态:${config.statusP2PAsClient || config.statusP2PAsServer ? "在线" : "离线"}");
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
                                  title: new Text("删除内网"),
                                  content: new Text("确认删除此内网？"),
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
                                        var ses = new OneSession();
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
            body: new ListView(children: divided),
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
    final channel = new ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = new SessionClient(channel);
    try {
      final response = await stub.createOneSession(config);
      print('Greeter client received: ${response}');
      await channel.shutdown();
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
    }
  }

  Future deleteOneSession(OneSession config) async {
    final channel = new ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = new SessionClient(channel);
    try {
      final response = await stub.deleteOneSession(config);
      print('Greeter client received: ${response}');
      await channel.shutdown();
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                  title: new Text("删除结果："),
                  content: new Text("删除成功！"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ])).then((result) {
        Navigator.of(context).pop();
      });
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                  title: new Text("删除结果："),
                  content: new Text("删除失败！$e"),
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
//      showDialog(
//          context: context,
//          builder: (_) => new AlertDialog(
//                  title: new Text("获取内网列表失败："),
//                  content: new Text("失败原因：$e"),
//                  actions: <Widget>[
//                    new FlatButton(
//                      child: new Text("取消"),
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      },
//                    ),
//                    new FlatButton(
//                      child: new Text("确认"),
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      },
//                    )
//                  ]));
    }
  }
}
