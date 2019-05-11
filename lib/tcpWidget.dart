import 'package:flutter/material.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class TCPListPage extends StatefulWidget {
  TCPListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TCPListPageState createState() => _TCPListPageState();
}

class _TCPListPageState extends State<TCPListPage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<TCPConfig> _TCPList = [];

  @override
  void initState() {
    super.initState();
    getAllTCP();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _TCPList.map(
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
                    getAllTCP();
                  });
                }),
          ],
        ),
        body: ListView(children: divided));
  }

  void _pushDetail(TCPConfig config) async {
    final _result = new Set<String>();
    _result.add("ID:${config.runId}");
    _result.add("描述:${config.description}");
    _result.add("描述:${config.remoteIP}");
    _result.add("描述:${config.remotePort}");
    _result.add("描述:${config.localIP}");
    _result.add("描述:${config.localProt}");
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
                                    deleteOneTCP(config).then((result) {
                                      setState(() {
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
        getAllTCP();
      });
    });
  }

  deleteOneTCP(TCPConfig config) async {
    final channel = new ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = new TCPClient(channel);
    try {
      final response = await stub.deleteOneTCP(config);
      print('Greeter client received: ${response}');
      await channel.shutdown();
      return true;
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
      return false;
    }

  }

  getAllTCP() async {
    final channel = new ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    final stub = new TCPClient(channel);
    try {
      final response = await stub.getAllTCP(new Empty());
      print('Greeter client received: ${response.tCPConfigs}');
      await channel.shutdown();
      _TCPList = response.tCPConfigs;
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
      return false;
    }
  }

}
