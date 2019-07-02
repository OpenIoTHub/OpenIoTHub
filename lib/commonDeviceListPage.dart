import 'package:flutter/material.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:android_intent/android_intent.dart';

class CommonDeviceListPage extends StatefulWidget {
  CommonDeviceListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CommonDeviceListPageState createState() => _CommonDeviceListPageState();
}

class _CommonDeviceListPageState extends State<CommonDeviceListPage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<SessionConfig> _SessionList = [];
  List<PortConfig> _CommonDeviceList = [];

  @override
  void initState() {
    super.initState();
    getAllTCP().then((v) {
      setState(() {});
    });
    print("init tcp");
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _CommonDeviceList.map(
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
              _pushDetail();
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
                    getAllTCP();
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
                              _addTCP(pair).then((v) {
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
                      getAllTCP().then((v) {
                        setState(() {});
                      });
                    });
                  });
                }),
          ],
        ),
        body: ListView(children: divided));
  }

  Future _addTCP(SessionConfig config) async {
    TextEditingController _description_controller =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    TextEditingController _local_ip_controller =
        TextEditingController.fromValue(TextEditingValue(text: "0.0.0.0"));
    TextEditingController _local_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "0"));
    TextEditingController _remote_ip_controller =
        TextEditingController.fromValue(TextEditingValue(text: "127.0.0.1"));
    TextEditingController _remote_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: ""));
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
                      controller: _local_ip_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '绑定的本地IP',
                        helperText: '默认0.0.0.0就行了',
                      ),
                    ),
                    new TextFormField(
                      controller: _local_port_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '本地绑定的端口',
                        helperText: '可以填写0随机一个',
                      ),
                    ),
                    new TextFormField(
                      controller: _remote_ip_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '远程内网的IP',
                        helperText: '内网设备的IP',
                      ),
                    ),
                    new TextFormField(
                      controller: _remote_port_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '内网待穿透的端口号',
                        helperText: '根据内网实际端口号填写',
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
                      var tcpConfig = new PortConfig();
                      tcpConfig.description = _description_controller.text;
                      tcpConfig.localProt =
                          int.parse(_local_port_controller.text);
                      tcpConfig.remotePort =
                          int.parse(_remote_port_controller.text);
                    },
                  )
                ]));
  }

  void _pushDetail() async {

  }

  createOneTCP() async {

  }

  deleteOneTCP() async {

  }

  Future getAllTCP() async {

  }

  Future getAllSession() async {
    final channel = new ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = new SessionManagerClient(channel);
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
