import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

class MDNSInfoPage extends StatelessWidget {
  const MDNSInfoPage({super.key, required this.portConfig});

  final PortConfig portConfig;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //设备信息
    final List result = [];
    result.add("${OpenIoTHubLocalizations.of(context).mdns_info}:${portConfig.mDNSInfo}");

    final tiles = result.map(
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
        title: Text(OpenIoTHubLocalizations.of(context).device_info),
      ),
      body: ListView(children: divided),
    );
  }
}
