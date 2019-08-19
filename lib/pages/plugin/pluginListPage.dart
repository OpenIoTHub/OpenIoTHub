import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nat_explorer/api/SessionApi.dart';
import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/pages/plugin/subPluginType/pluginModel.dart';

import 'package:nat_explorer/pages/user/tools/smartConfigTool.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:android_intent/android_intent.dart';
//统一导入全部插件类型
import 'package:nat_explorer/pages/plugin/subPluginType/plugins.dart';

class PluginListPage extends StatefulWidget {
  PluginListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PluginListPageState createState() => _PluginListPageState();
}

class _PluginListPageState extends State<PluginListPage> {
  Utf8Decoder u8decodeer = Utf8Decoder();
  static const double ARROW_ICON_WIDTH = 16.0;
  final titleTextStyle = TextStyle(fontSize: 16.0);
  final rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );
  List<Plugin> _PluginList = [];

  @override
  void initState() {
    super.initState();
    getAllPlugin().then((_) {
      Future.delayed(const Duration(seconds: 2), () => getAllPlugin());
    });
    print("init plugin List");
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _PluginList.map(
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
            _pushpluginServiceTypes(pair);
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
        body: ListView(children: divided));
  }

//显示是设备的UI展示或者操作界面
  void _pushpluginServiceTypes(Plugin plugin) async {
    // 查看设备的UI，1.native，2.web
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          String model = plugin.info["model"];
          String uiFirst = plugin.info["ui-first"];
          switch (model) {
            case "com.iotserv.plugins.esp8266-switch":
              {
                if (uiFirst == "native") {
                  return EspPluginDemoPage(plugin: plugin);
                } else if (uiFirst == "web") {
                  _openWithWeb(plugin);
                }
              }
              break;
            default:
              {
                _openWithWeb(plugin);
              }
              break;
          }
        },
      ),
    ).then((result) {
      setState(() {
        getAllPlugin();
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

  Future getAllPlugin() async {
    // TODO 从各内网筛选出当前已经映射的mDNS服务中是物联网设备的，注意通过api刷新mDNS服务
    try {
      getAllSession().then((s) {
        for (int i = 0; i < s.length; i++) {
          SessionApi.getAllTCP(s[i]).then((t) {
            for (int j = 0; j < t.portConfigs.length; j++) {
              if (j == 0) {
                _PluginList.clear();
              }
              //  是否是Plugin
              if (t.portConfigs[j].description.contains("_plugin.")) {
                // TODO 是否含有/info，将portConfig里面的description换成、info中的name（这个name由设备管理）
                addToPluginList(t.portConfigs[j]);
              }
            }
          });
        }
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("获取插件列表失败："),
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
        getAllPlugin();
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  addToPluginList(PortConfig portConfig) async {
    String url = "http://${Config.webgRpcIp}:${portConfig.localProt}/info";
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
    } catch (e) {
      print(e.toString());
      return;
    }
    if (response.statusCode == 200) {
      dynamic info = jsonDecode(u8decodeer.convert(response.bodyBytes));
      portConfig.description = info["name"];
      setState(() {
        _PluginList.add(
            Plugin(portConfig: portConfig, info: info));
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

  _openWithWeb(Plugin plugin) async {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return WebviewScaffold(
        url: "http://${Config.webgRpcIp}:${plugin.portConfig.localProt}",
        appBar: new AppBar(title: new Text("网页浏览器"), actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: () {
                _launchURL("http://${Config.webgRpcIp}:${plugin.portConfig.localProt}");
              })
        ]),
      );
    })).then((_) {
      Navigator.of(context).pop();
    });
  }
}
