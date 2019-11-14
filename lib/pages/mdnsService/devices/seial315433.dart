//Serial315433:https://github.com/iotdevice/serial-315-433
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/portService.dart';
import '../commWidgets/info.dart';
import '../commWidgets/uploadOTA.dart';

class Serial315433Page extends StatefulWidget {
  Serial315433Page({Key key, this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.serial-315-433";
  final PortService device;

  @override
  _Serial315433PageState createState() => _Serial315433PageState();
}

class _Serial315433PageState extends State<Serial315433Page> {
  static const String _up = "up";
  static const String _down = "down";

  @override
  void initState() {
    super.initState();
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.info["name"]),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                _setting();
              }),
          IconButton(
              icon: Icon(
                Icons.file_upload,
                color: Colors.white,
              ),
              onPressed: () {
                _ota();
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
      body: Column(
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
          ]),
    );
  }

  _setting() async {
    // TODO 设备设置
    TextEditingController _name_controller = TextEditingController.fromValue(
        TextEditingValue(text: widget.device.info["name"]));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("设置名称："),
                content: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _name_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '名称',
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
                    child: Text("修改"),
                    onPressed: () async {
                      try {
                        String url =
                            "http://${widget.device.ip}:${widget.device.port}/rename?name=${_name_controller.text}";
                        await http.get(url).timeout(const Duration(seconds: 2));
                        widget.device.info["name"] = _name_controller.text;
                      } catch (e) {
                        print(e.toString());
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
          );
        },
      ),
    );
  }

  _clickBotton(String cmd) async {
    String url = "http://${widget.device.ip}:${widget.device.port}/botton?status=$cmd";
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _ota() async {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("升级固件："),
                content: Container(
                    height: 150,
                    child: UploadOTAPage(
                      url: "http://${widget.device.ip}:${widget.device.port}/update",
                    )),
                actions: <Widget>[
                  FlatButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }
}
