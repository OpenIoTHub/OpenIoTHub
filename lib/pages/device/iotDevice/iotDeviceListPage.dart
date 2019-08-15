import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nat_explorer/api/SessionApi.dart';
import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/pages/device/iotDevice/iotDevice.dart';
import 'package:nat_explorer/pages/user/tools/smartConfigTool.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:android_intent/android_intent.dart';
//统一导入全部设备类型
import 'package:nat_explorer/pages/device/iotDevice/subDeviceType/devices.dart';

class IoTDeviceListPage extends StatefulWidget {
  IoTDeviceListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IoTDeviceListPageState createState() => _IoTDeviceListPageState();
}

class _IoTDeviceListPageState extends State<IoTDeviceListPage> {
  Utf8Decoder u8decodeer = Utf8Decoder();
  static const double ARROW_ICON_WIDTH = 16.0;
  final titleTextStyle = TextStyle(fontSize: 16.0);
  final rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );
  List<IoTDevice> _IoTDeviceList = [];

  @override
  void initState() {
    super.initState();
    getAllIoTDevice().then((_) {
      Future.delayed(const Duration(seconds: 2), () => getAllIoTDevice());
    });
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _IoTDeviceList.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.devices),
              Expanded(
                  child: Text(
                pair.portConfig.description,
                style: titleTextStyle,
              )),
              rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            _pushDeviceServiceTypes(pair);
          },
          child: listItemContent,
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
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  refreshmDNSServices();
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: (){
              // 通过smartconfig添加设备
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return EspSmartConfigTool(title: "添加设备");
                  },
                ),
              ).then((v){
                refreshmDNSServices();
              });
            },
            child: IconButton(icon: Icon(Icons.add),color: Colors.black, onPressed: null,iconSize: 40,),
        ),
        body: ListView(children: divided));
  }

//显示是设备的UI展示或者操作界面
  void _pushDeviceServiceTypes(IoTDevice device) async {
    // 查看设备的UI，1.native，2.web
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          String model = jsonDecode(device.response.body)["model"];
          String uiFirst = jsonDecode(device.response.body)["ui-first"];
          switch (model) {
            case "com.iotserv.devices.esp8266-switch":
              {
                if (uiFirst == "native") {
                  return EspPluginDemoPage(device: device);
                } else if (uiFirst == "web") {
                  _openWithWeb(device);
                }
              }
              break;
            default:
              {
                _openWithWeb(device);
              }
              break;
          }
        },
      ),
    ).then((result) {
      setState(() {
        getAllIoTDevice();
      });
    });
  }

  Future getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('Greeter client received: ${response.sessionConfigs}');
      return response.sessionConfigs;
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future getAllIoTDevice() async {
    // TODO 从各内网筛选出当前已经映射的mDNS服务中是物联网设备的，注意通过api刷新mDNS服务
    try {
      getAllSession().then((s) {
        for (int i = 0; i < s.length; i++) {
          SessionApi.getAllTCP(s[i]).then((t) {
            for (int j = 0; j < t.portConfigs.length; j++) {
              if (j == 0) {
                _IoTDeviceList.clear();
              }
              //  是否是iotdevice
              if (t.portConfigs[j].description.contains("_iotdevice.")) {
                // TODO 是否含有/info，将portConfig里面的description换成、info中的name（这个name由设备管理）
                addToIoTDeviceList(t.portConfigs[j]);
              }
            }
          });
        }
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("获取物联网列表失败："),
                  content: Text("失败原因：$e"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  Future refreshmDNSServices() async {
    try {
      getAllSession().then((s) {
        for (int i = 0; i < s.length; i++) {
          SessionApi.refreshmDNSServices(s[i]);
        }
      }).then((_) {
        getAllIoTDevice();
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  addToIoTDeviceList(PortConfig portConfig) async {
    String url = "http://${Config.webgRpcIp}:${portConfig.localProt}/info";
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
    } catch (e) {
      print(e.toString());
      return;
    }
    if (response.statusCode == 200) {
      portConfig.description = jsonDecode(u8decodeer.convert(response.bodyBytes))["name"];
      setState(() {
        _IoTDeviceList.add(
            IoTDevice(portConfig: portConfig, response: response));
      });
    }
  }

  _launchURL(String url) async {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    await intent.launch();
  }

  _openWithWeb(IoTDevice device) async {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return WebviewScaffold(
        url: "http://${Config.webgRpcIp}:${device.portConfig.localProt}",
        appBar: new AppBar(title: new Text("网页浏览器"), actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: () {
                _launchURL("http://${Config.webgRpcIp}:${device.portConfig.localProt}");
              })
        ]),
      );
    })).then((_) {
      Navigator.of(context).pop();
    });
  }
}
