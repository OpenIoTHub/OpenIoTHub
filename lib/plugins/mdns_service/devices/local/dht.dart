//这个模型是用来展示数据量的模型，比如：温度，湿度，光照强度
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub/plugins/openiothub_plugin.dart';
import 'package:openiothub/utils/network/dns_lookup.dart';

import 'package:openiothub/models/port_service_info.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

class DHTPage extends StatefulWidget {
  const DHTPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.dht";
  final PortServiceInfo device;

  @override
  State<DHTPage> createState() => DHTPageState();
}

class DHTPageState extends State<DHTPage> {
  static const String temperature = "temperature";
  static const String humidity = "humidity";

  final List<String> _valueKeyList = [
    temperature,
    humidity,
  ];

  final Map<String, double> _status = Map.from({
    temperature: null,
    humidity: null,
  });

  Map<String, String>? _realName;

  final Map<String, String> _units = Map.from({
    temperature: "℃",
    humidity: "%",
  });

  @override
  void initState() {
    super.initState();
    _getCurrentStatus();
    debugPrint("init iot device list");
  }

  @override
  Widget build(BuildContext context) {
    _realName = Map.from({
      temperature: OpenIoTHubLocalizations.of(context).temperature,
      humidity: OpenIoTHubLocalizations.of(context).humidity,
    });
    final List result = [];
    result.addAll(_valueKeyList);
    final tiles = result.map(
      (pair) {
        switch (pair) {
          case temperature:
          case humidity:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName![pair]!),
                  Text(":"),
                  Text(_status[pair].toString()),
                  Text(_units[pair]!)
                ],
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.info!["name"]!),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {
                _getCurrentStatus();
              }),
          IconButton(
              icon: Icon(
                Icons.settings,
                // color: Colors.white,
              ),
              onPressed: () {
                _setting();
              }),
          IconButton(
              icon: Icon(
                Icons.file_upload,
                // color: Colors.white,
              ),
              onPressed: () {
                _ota();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.green,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: openIoTHubDesktopScrollableListBody(
        scrollable: ListView(children: divided),
      ),
    );
  }

  _getCurrentStatus() async {
    http.Response response;
    try {
      response = await http
          .get(Uri(
            scheme: 'http',
            host: widget.device.addr.endsWith(".local")
                ? await getIpByDomain(widget.device.addr)
                : widget.device.addr,
            port: widget.device.port,
            path: '/status',
          ))
          .timeout(const Duration(seconds: 2));
      debugPrint(response.body);
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
//    同步状态到界面
    if (response.statusCode == 200) {
      for (var value in _valueKeyList) {
        setState(() {
          _status[value] = jsonDecode(response.body)[value];
        });
      }
    } else {
      debugPrint("获取状态失败！");
    }
  }

  _setting() async {
    // TODO 设备设置
    TextEditingController nameController = TextEditingController.fromValue(
        TextEditingValue(text: widget.device.info!["name"]!));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
                    "${OpenIoTHubLocalizations.of(context).setting_name}："),
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText:
                            OpenIoTHubLocalizations.of(context).name,
                      ),
                    )
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text(OpenIoTHubLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child:
                        Text(OpenIoTHubLocalizations.of(context).modify),
                    onPressed: () async {
                      try {
                        String url =
                            "http://${widget.device.addr}:${widget.device.port}/rename?name=${nameController.text}";
                        http
                            .get(Uri.parse(url))
                            .timeout(const Duration(seconds: 2))
                            .then((_) {
                          setState(() {
                            widget.device.info!["name"] = nameController.text;
                          });
                        });
                      } catch (e) {
                        debugPrint(e.toString());
                        return;
                      }
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  _info() async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
            key: GlobalKey(),
          );
        },
      ),
    );
  }

  _ota() async {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
                    "${OpenIoTHubLocalizations.of(context).upgrade_firmware}："),
                content: SizedBox.expand(
                    child: UploadOTAPage(
                  url:
                      "http://${widget.device.addr}:${widget.device.port}/update",
                  key: UniqueKey(),
                )),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text(OpenIoTHubLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }
}
