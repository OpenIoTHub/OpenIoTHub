//Serial315433:https://github.com/iotdevice/serial-315-433
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub/plugin/openiothub_plugin.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:openiothub/utils/network/dns_lookup.dart';

import 'package:openiothub/models/port_service_info.dart';

class Serial315433Page extends StatefulWidget {
  const Serial315433Page({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.serial-315-433";
  final PortServiceInfo device;

  @override
  State<Serial315433Page> createState() => Serial315433PageState();
}

class Serial315433PageState extends State<Serial315433Page> {
  static const String _up = "up";
  static const String _down = "down";

  @override
  void initState() {
    super.initState();
    debugPrint("init iot device list");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.info!["name"]!),
        actions: <Widget>[
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
      body: openIoTHubDesktopConstrainedBody(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_drop_up),
                  color: Colors.green,
                  iconSize: 100.0,
                  onPressed: () {
                    _clickBotton(_up);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  color: Colors.deepOrange,
                  iconSize: 100.0,
                  onPressed: () {
                    _clickBotton(_down);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                  ),
                ),
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
                        await http
                            .get(Uri.parse(url))
                            .timeout(const Duration(seconds: 2));
                        widget.device.info!["name"] = nameController.text;
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      } catch (e) {
                        debugPrint(e.toString());
                      }
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
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  _clickBotton(String cmd) async {
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await getIpByDomain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/botton',
              queryParameters: {
                "status": cmd,
              }))
          .timeout(const Duration(seconds: 2));
      debugPrint(response.body);
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
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
