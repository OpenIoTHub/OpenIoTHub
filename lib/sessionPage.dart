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
        return ListTile(
          title: Text(
            pair.description,
            style: _biggerFont,
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
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
                      TextEditingController.fromValue(
                          TextEditingValue(text: ""));
                  TextEditingController _description_controller =
                      TextEditingController.fromValue(
                          TextEditingValue(text: ""));
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                              title: Text("添加内网："),
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
    final _result = Set<String>();
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
    final channel = ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = SessionManagerClient(channel);
    try {
      final response = await stub.createOneSession(config);
      print('Greeter client received: ${response}');
      await channel.shutdown();
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
    }
  }

  Future deleteOneSession(SessionConfig config) async {
    final channel = ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = SessionManagerClient(channel);
    try {
      final response = await stub.deleteOneSession(config);
      print('Greeter client received: ${response}');
      channel.shutdown();
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
      channel.shutdown();
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
    final channel = ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = SessionManagerClient(channel);
    try {
      final response = await stub.getAllSession(new Empty());
      print('Greeter client received: ${response.sessionConfigs}');
      channel.shutdown();
      setState(() {
        _SessionList = response.sessionConfigs;
      });
    } catch (e) {
      print('Caught error: $e');
      channel.shutdown();
    }
  }
}
