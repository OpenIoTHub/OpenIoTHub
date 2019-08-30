//RGBALed:https://github.com/iotdevice/phicomm_dc1
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/pages/device/iotDevice/iotDeviceModel.dart';
import 'package:nat_explorer/pages/device/iotDevice/subDeviceType/commWidgets/info.dart';
import 'package:nat_explorer/pages/device/iotDevice/subDeviceType/commWidgets/uploadOTA.dart';

class RGBALedPage extends StatefulWidget {
  RGBALedPage({Key key, this.device}) : super(key: key);

  final IoTDevice device;

  @override
  _RGBALedPageState createState() => _RGBALedPageState();
}

class _RGBALedPageState extends State<RGBALedPage> {
  static const Color onColor = Colors.green;
  static const Color offColor = Colors.red;

  bool _requsting = false;

  static const String color = "color";
  static const String brightness = "brightness";

  List<String> _valueKeyList = [
  color,
  ];

  Map<String, dynamic> _status = Map.from({
    color: Colors.white,
  });

  @override
  void initState() {
    super.initState();
    _getCurrentStatus();
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
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _status[color],
                onColorChanged: _changeColorStatus,
                enableLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            Switch(
              onChanged: (_) {
                _changeSwitchStatus();
              },
              value: true,
              activeColor: onColor,
              inactiveThumbColor: offColor,
            ),
          ]),
    );
  }

  _getCurrentStatus() async {
    String url = "${widget.device.baseUrl}/status";
    http.Response response;
    try {
      if(!_requsting){
        _requsting = true;
        response = await http.get(url).timeout(const Duration(seconds: 2));
        if(response!=null){
          print(response.body);
        }
      }
    } catch (e) {
      print(e.toString());
      return;
    }
    _requsting = false;
//    同步状态到界面
    if (response.statusCode == 200) {
//      _valueKeyList.forEach((value) {
//        setState(() {
//          _status[value] = jsonDecode(response.body)[value];
//        });
//      });
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
                            "${widget.device.baseUrl}/rename?name=${_name_controller.text}";
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
            device: widget.device,
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
                      url: "${widget.device.baseUrl}/update",
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

  _changeSwitchStatus() async {
    Color tempColor = Color.fromARGB(0, 255, 255, 255);
    String url;
    if (tempColor.red == 0 && tempColor.green == 0 && tempColor.blue == 0) {
      url =
      "${widget.device.baseUrl}/set?c=${tempColor.value.toRadixString(16)}";
    } else {
      url =
      "${widget.device.baseUrl}/set?c=0";
    }
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      if(response !=null){
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
      return;
    }
    _getCurrentStatus();
  }

  _changeColorStatus(Color color) async {
    Color tempColor = Color.fromARGB(0, color.red, color.green, color.blue);
    String url =
        "${widget.device.baseUrl}/set?c=${tempColor.value.toRadixString(16)}";
    http.Response response;
    try {
      if(!_requsting){
        _requsting = true;
        response = await http.get(url).timeout(const Duration(seconds: 2));
      }
    } catch (e) {
      print(e.toString());
      return;
    }
    _requsting = false;
    _getCurrentStatus();
  }
}
