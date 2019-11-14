//这个模型是用来展示数据量的模型，比如：温度，湿度，光照强度
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/portService.dart';
import '../commWidgets/info.dart';
import '../commWidgets/uploadOTA.dart';

class LightLevelPage extends StatefulWidget {
  LightLevelPage({Key key, this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.lightLevel";
  final PortService device;

  @override
  _LightLevelPageState createState() => _LightLevelPageState();
}

class _LightLevelPageState extends State<LightLevelPage> {
  static const String lightLevel = "lightLevel";

  List<String> _valueKeyList = [
    lightLevel,
  ];

  Map<String, double> _status = Map.from({
    lightLevel: null,
  });

  Map<String, String> _realName = Map.from({
    lightLevel: "光照强度",
  });

  Map<String, String> _units = Map.from({
    lightLevel: "lx",
  });

  @override
  void initState() {
    super.initState();
    _getCurrentStatus();
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.addAll(_valueKeyList);
    final tiles = _result.map(
      (pair) {
        switch (pair) {
          case lightLevel:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]),
                  Text(":"),
                  Text(_status[pair].toString()),
                  Text(_units[pair])
                ],
              ),
            );
            break;
          default:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]),
                  Text(":"),
                  Text(_status[pair].toString()),
                ],
              ),
            );
            break;
        }
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.info["name"]),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _getCurrentStatus();
              }),
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
      body: ListView(children: divided),
    );
  }

  _getCurrentStatus() async {
    String url = "http://${widget.device.ip}:${widget.device.port}/status";
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
//    同步状态到界面
    if (response.statusCode == 200) {
      _valueKeyList.forEach((value) {
        setState(() {
          _status[value] = jsonDecode(response.body)[value];
        });
      });
    } else {
      print("获取状态失败！");
    }
  }

  _setting() async {
    // TODO 设备设置
    TextEditingController _name_controller = TextEditingController.fromValue(
        TextEditingValue(text: widget.device.info["name"]));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("设置名称："),
                content: Container(
                    height: 150,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          controller: _name_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: '名称',
                          ),
                        )
                      ],
                    )),
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
                        http
                            .get(url)
                            .timeout(const Duration(seconds: 2))
                            .then((_) {
                          setState(() {
                            widget.device.info["name"] = _name_controller.text;
                          });
                        });
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
