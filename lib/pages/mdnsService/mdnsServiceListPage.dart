import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nat_explorer/api/SessionApi.dart';
import 'package:nat_explorer/api/Utils.dart';
import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/constants/Constants.dart';
import 'package:nat_explorer/model/custom_theme.dart';
import 'package:provider/provider.dart';
import '../../model/portService.dart';
import 'package:nat_explorer/pages/openWithChoice/webPage/webPage.dart';
import 'package:nat_explorer/pages/user/tools/smartConfigTool.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:android_intent/android_intent.dart';
import 'package:webview_flutter/webview_flutter.dart';

//统一导入全部设备类型
import './modelsMap.dart';
import 'commWidgets/info.dart';

class MdnsServiceListPage extends StatefulWidget {
  MdnsServiceListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MdnsServiceListPageState createState() => _MdnsServiceListPageState();
}

class _MdnsServiceListPageState extends State<MdnsServiceListPage> {
  Utf8Decoder u8decodeer = Utf8Decoder();
  Map<String, PortService> _IoTDeviceMap = Map<String, PortService>();

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
    print("_IoTDeviceMap:$_IoTDeviceMap");
    final tiles = _IoTDeviceMap.values.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(Icons.devices,color: Provider.of<CustomTheme>(context).themeValue == "dark"
              ? CustomThemes.dark.accentColor
              : CustomThemes.light.accentColor),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(pair.info["name"],style: Constants.titleTextStyle),
            ],
          ),
          trailing: Constants.rightArrowIcon,
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
              builder: (_) => EspSmartConfigTool(
                title: "添加设备",
                needCallBack: true,
              ),
            ).then((v) {
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
  void _pushDeviceServiceTypes(PortService device) async {
    // 查看设备的UI，1.native，2.web
    // 写成独立的组件，支持刷新
    String model = device.info["model"];
    String uiFirst = device.info["ui-first"];

    if (uiFirst == "native" && ModelsMap.modelsMap.containsKey(model)) {
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
    } else if (uiFirst == "none") {
//      TODO 没有可供显示的界面
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return InfoPage(
              device: device,
            );
          },
        ),
      );
    } else {
//      TODO 模型没有注册需要更新本软件或者打开方式不支持
    }
//    await _IoTDeviceMap.clear();
    getAllIoTDevice();
  }

  Future<List<SessionConfig>> getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('Greeter client received: ${response.sessionConfigs}');
      return response.sessionConfigs;
    } catch (e) {
      List<SessionConfig> list = [];
      print('Caught error: $e');
      return list;
    }
  }

  Future getAllIoTDevice() async {
    // TODO 从搜索到的mqtt组件中获取设备
    try {
      // 先从本机所处网络获取设备，再获取代理的设备
      MDNSService config = MDNSService();
      config.name = Config.mdnsCloudService;
      UtilApi.getAllmDNSServiceList(config).then((v) {
        v.mDNSServices.forEach((m) {
          PortConfig portConfig = PortConfig();
          Device device = Device();
          device.addr = m.iP;
          portConfig.device = device;
          portConfig.remotePort = m.port;
          portConfig.mDNSInfo = m.mDNSInfo;
          addToIoTDeviceList(portConfig, true);
        });
      });
      // 从远程获取设备
      getAllSession().then((s) {
        s.forEach((SessionConfig s) {
          SessionApi.getAllTCP(s).then((t) {
            for (int j = 0; j < t.portConfigs.length; j++) {
              //  是否是iotdevice
              Map<String, dynamic> mDNSInfo =
                  jsonDecode(t.portConfigs[j].mDNSInfo);
//              print("mDNSInfo:$mDNSInfo");
//              {
//                "name": "esp-switch-80:7D:3A:72:64:6F",
//                "type": "_iotdevice._tcp",
//                "domain": "local",
//                "hostname": "esp-switch-80:7D:3A:72:64:6F.local.",
//                "port": 80,
//                "text": null,
//                "ttl": 4500,
//                "AddrIPv4": ["192.168.0.3"],
//                "AddrIPv6": null
//              }
              if (mDNSInfo['type'] == Config.mdnsCloudService) {
                // TODO 是否含有/info，将portConfig里面的description换成、info中的name（这个name由设备管理）
                addToIoTDeviceList(t.portConfigs[j], false);
              }
            }
          });
        });
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
      await getAllIoTDevice();
      getAllSession().then((s) {
        for (int i = 0; i < s.length; i++) {
          SessionApi.refreshmDNSServices(s[i]);
        }
      }).then((_) async {
//        await _IoTDeviceMap.clear();
        getAllIoTDevice();
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future<void> addToIoTDeviceList(PortConfig portConfig, bool noProxy) async {
    if (portConfig == null) {
      return;
    }
    print("===text1:${portConfig.toString()}");
    Map<String, dynamic> info = Map<String, dynamic>();
    //尝试从mDNS的Text中获取数据
    if (portConfig.mDNSInfo != null && portConfig.mDNSInfo != "") {
      Map<String, dynamic> mDNSInfo = jsonDecode(portConfig.mDNSInfo);
      if (mDNSInfo != null &&
          mDNSInfo.containsKey("text") &&
          mDNSInfo["text"] != null) {
        print("===text2:${mDNSInfo["text"].toString()}");
        List text = mDNSInfo["text"];
        for (int i = 0; i < text.length; i++) {
          List<String> s = text[i].split("=");
          if (s.length == 2) {
            info[s[0]] = await UtilApi.convertOctonaryUtf8(s[1]);
            print(
                "key:${s[0]},value:${await UtilApi.convertOctonaryUtf8(s[1])}\n");
          }
        }
      }
    }
    //尝试从http api获取信息，可能会产生覆盖
    String baseUrl;
    if (noProxy) {
      baseUrl = "http://${portConfig.device.addr}:${portConfig.remotePort}";
    } else {
      baseUrl = "http://${Config.webgRpcIp}:${portConfig.localProt}";
    }
    print("===text3:${info}");
//    将一些不符合条件的服务排除在列表之外
    if (!info.containsKey("name") ||
        info["name"] == null ||
        info["name"] == '') {
      return;
    }
    portConfig.description = info["name"];

//      在没有重复的情况下直接加入列表，有重复则本内外的替代远程的
    if (!_IoTDeviceMap.containsKey(info["id"])) {
      setState(() {
        _IoTDeviceMap[info["id"]] = PortService(
            portConfig: portConfig,
            info: info,
            noProxy: noProxy,
            baseUrl: baseUrl);
      });
    } else if (!_IoTDeviceMap[info["id"]].noProxy && noProxy) {
      setState(() {
        _IoTDeviceMap[info["id"]] = PortService(
            portConfig: portConfig,
            info: info,
            noProxy: noProxy,
            baseUrl: baseUrl);
      });
    }
//    TODO 判断此配置的合法性 verify()
  }

  _launchURL(String url) async {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    await intent.launch();
  }

  _openWithWeb(PortService device) async {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
//      return WebviewScaffold(
//        url: device.baseUrl,
//        appBar: new AppBar(title: new Text("网页浏览器"), actions: <Widget>[
//          IconButton(
//              icon: Icon(
//                Icons.open_in_browser,
//                color: Colors.white,
//              ),
//              onPressed: () {
//                _launchURL(device.baseUrl);
//              })
//        ]),
//        withZoom: true,
//        resizeToAvoidBottomInset:true,
//      );

      return Scaffold(
          appBar: new AppBar(title: new Text("网页浏览器"), actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.open_in_browser,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await Navigator.of(context).pop();
                  _launchURL(device.baseUrl);
                })
          ]),
          body: Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: device.baseUrl,
            );
          }));

//      return WebPage(title: "浏览器",url: device.baseUrl,);
    }));
  }
}
