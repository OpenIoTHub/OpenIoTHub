import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

import 'package:openiothub_plugin/openiothub_plugin.dart';

class MDNSInfoPage extends StatelessWidget {
  MDNSInfoPage({required Key key, required this.portConfig}) : super(key: key);
  PortConfig portConfig;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //设备信息
    final List _result = [];
    _result.add("${OpenIoTHubPluginLocalizations.of(context).mdns_info}:${portConfig.mDNSInfo}");

    final tiles = _result.map(
      (pair) {
        return ListTile(
          title: Text(
            pair,
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
        title: Text(OpenIoTHubPluginLocalizations.of(context).device_info),
      ),
      body: ListView(children: divided),
    );
  }
}
