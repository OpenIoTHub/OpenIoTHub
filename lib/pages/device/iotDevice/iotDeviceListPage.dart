import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nat_explorer/api/SessionApi.dart';
import 'package:nat_explorer/api/Utils.dart';
import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/pages/device/iotDevice/iotDeviceModel.dart';
import 'package:nat_explorer/pages/user/tools/smartConfigTool.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:android_intent/android_intent.dart';

//统一导入全部设备类型
import './subDeviceType/modelsMap.dart';

class IoTDeviceListPage extends StatefulWidget {
  IoTDeviceListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IoTDeviceListPageState createState() => _IoTDeviceListPageState();
}

class _IoTDeviceListPageState extends State<IoTDeviceListPage> {
  bool onRefreshing = false;
  Utf8Decoder u8decodeer = Utf8Decoder();
  static const double ARROW_ICON_WIDTH = 16.0;
  final titleTextStyle = TextStyle(fontSize: 16.0);
  final rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );
  Map<String, IoTDevice> _IoTDeviceMap = Map<String, IoTDevice>();

  @override
  void initState() {
    super.initState();
    getAllIoTDevice().then((_) {
      Future.delayed(const Duration(seconds: 5), () => getAllIoTDevice());
    });
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _IoTDeviceMap.values.map(
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
          onPressed: () {
            // 通过smartconfig添加设备
            return showDialog(
                context: context,
                builder: (_) => EspSmartConfigTool(title: "添加设备", needCallBack: true,),
            )
            .then((v) {
              refreshmDNSServices();
            });
          },
          child: IconButton(
            icon: Icon(Icons.add),
            color: Colors.black,
            onPressed: null,
            iconSize: 40,
          ),
        ),
        body: ListView(children: divided));
  }

//显示是设备的UI展示或者操作界面
  void _pushDeviceServiceTypes(IoTDevice device) async {
    // 查看设备的UI，1.native，2.web
    // 写成独立的组件，支持刷新
    String model = device.info["model"];
    String uiFirst = device.info["ui-first"];

    if (ModelsMap.modelsMap.containsKey(model)) {
      if (uiFirst == "native") {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ModelsMap.modelsMap[model](device);
            },
          ),
        );
      } else if (uiFirst == "web") {
        await _openWithWeb(device);
      } else if (uiFirst == "miniProgram") {
//                小程序方式打开
      }
      await _IoTDeviceMap.clear();
      getAllIoTDevice();
    } else {
//      TODO：模型没有注册
      print("请尝试更新软件");
    }
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
    onRefreshing = true;
    // TODO 从各内网筛选出当前已经映射的mDNS服务中是物联网设备的，注意通过api刷新mDNS服务
    try {
      // 先从本机所处网络获取设备，再获取代理的设备
      MDNSService config = MDNSService();
      config.name = '_iotdevice._tcp';
      UtilApi.getAllmDNSServiceList(config).then((v){
        v.mDNSServices.forEach((m){
          PortConfig portConfig = PortConfig();
          Device device = Device();
          device.addr = m.iP;
          portConfig.device = device;
          portConfig.remotePort = m.port;
          addToIoTDeviceList(portConfig, true);
        });
      });
      // 从远程获取设备
      getAllSession().then((s) {
        for (int i = 0; i < s.length; i++) {
          SessionApi.getAllTCP(s[i]).then((t) {
            for (int j = 0; j < t.portConfigs.length; j++) {
              //  是否是iotdevice
              if (t.portConfigs[j].description.contains("_iotdevice.")) {
                // TODO 是否含有/info，将portConfig里面的description换成、info中的name（这个name由设备管理）
                addToIoTDeviceList(t.portConfigs[j], false);
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
    await Future.delayed(const Duration(seconds: 1), () => {});
    onRefreshing = false;
  }

  Future refreshmDNSServices() async {
    try {
      await getAllIoTDevice();
      getAllSession().then((s) {
        for (int i = 0; i < s.length; i++) {
          SessionApi.refreshmDNSServices(s[i]);
        }
      }).then((_) async {
        await _IoTDeviceMap.clear();
        getAllIoTDevice();
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  addToIoTDeviceList(PortConfig portConfig, bool noProxy) async {
//TODO    尝试从mDNS的Text中获取数据
    dynamic mDNSInfo = jsonDecode(portConfig.mDNSInfo);

    String baseUrl;
    if (noProxy){
      baseUrl = "http://${portConfig.device.addr}:${portConfig.remotePort}";
    }else{
      baseUrl = "http://${Config.webgRpcIp}:${portConfig.localProt}";
    }
    String infoUrl = "$baseUrl/info";
    http.Response response;
    try {
      response = await http.get(infoUrl).timeout(const Duration(seconds: 2));
    } catch (e) {
      print(e.toString());
      return;
    }
    if (response.statusCode == 200) {
      dynamic info = jsonDecode(u8decodeer.convert(response.bodyBytes));
      portConfig.description = info["name"];
//      在没有重复的情况下直接加入列表，有重复则本内外的替代远程的
      if(!_IoTDeviceMap.containsKey(info["mac"])) {
        _IoTDeviceMap[info["mac"]] =
            IoTDevice(portConfig: portConfig, info: info, noProxy: noProxy, baseUrl: baseUrl);
      }else if (!_IoTDeviceMap[info["mac"]].noProxy&&noProxy){
        _IoTDeviceMap[info["mac"]] =
            IoTDevice(portConfig: portConfig, info: info, noProxy: noProxy, baseUrl: baseUrl);
      }
      setState(() {

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
                _launchURL(
                    "http://${Config.webgRpcIp}:${device.portConfig.localProt}");
              })
        ]),
      );
    })).then((_) {
      Navigator.of(context).pop();
    });
  }
}
