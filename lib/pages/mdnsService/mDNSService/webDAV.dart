//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nat_explorer/constants/Config.dart';
import '../../../model/portService.dart';
import '../commWidgets/info.dart';
import 'package:webdav/webdav.dart';

class WebDAVPage extends StatefulWidget {
  WebDAVPage({Key key, this.serviceInfo}) : super(key: key);

  static final String modelName = "com.iotserv.devices.webdav";
  final PortService serviceInfo;

  @override
  _WebDAVPageState createState() => _WebDAVPageState();
}

class _WebDAVPageState extends State<WebDAVPage> {
  String currentPath = "/";
  List<FileInfo> listFile = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = listFile.map(
          (pair) {
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(pair.displayName),
            ],
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
        title: Text(widget.serviceInfo.info["name"]),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _refreshList();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: ListView(children: divided),
    );

  }

  _refreshList() async {
    Client webDAV = Client(widget.serviceInfo.noProxy
        ? widget.serviceInfo.portConfig.device.addr
        : Config.webgRpcIp, "", "", "/", protocol: "http",
        port: widget.serviceInfo.noProxy ? widget.serviceInfo.portConfig
            .remotePort : widget.serviceInfo.portConfig.localProt);
    try{
      List<FileInfo> listFileRst = await webDAV.ls("/");
      print("listFileRst:$listFileRst");
      setState(() {
        listFile = listFileRst;
      });
    }catch (e){
      print(e.toString());
    }
  }

  _info() async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            device: widget.serviceInfo,
          );
        },
      ),
    );
  }

}
