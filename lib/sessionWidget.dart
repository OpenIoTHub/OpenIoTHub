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
  List<SessionConfig> _SessionList;

  @override
  void initState() {
    super.initState();
    getAllSession();
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
                onPressed: () {}),
          ],
        ),
        body: ListView(children: divided));
  }

  void _pushDetail(SessionConfig config) {
    final _result = new Set<String>();
    _result.add("ID:${config.runId}");
    _result.add("描述:${config.description}");
    _result.add("Token:${config.token}");
    _result.add("转发在线:${config.statusToClient}");
    _result.add("P2P在线:${config.statusP2PAsClient&&config.statusP2PAsServer}");
    Navigator.of(context).push(
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
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
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
    } catch (e) {
      print('Caught error: $e');
      await channel.shutdown();
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
    }
  }
}
