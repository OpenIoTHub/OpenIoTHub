import 'package:flutter/material.dart';
import 'package:modules/constants/Config.dart';
import 'package:modules/constants/Constants.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:modules/api/OpenIoTHub/SessionApi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MDNSServiceListPage extends StatefulWidget {
  MDNSServiceListPage({Key key, this.sessionConfig}) : super(key: key);

  SessionConfig sessionConfig;

  @override
  _MDNSServiceListPageState createState() => _MDNSServiceListPageState();
}

class _MDNSServiceListPageState extends State<MDNSServiceListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  List<PortConfig> _ServiceList = [];

  @override
  void initState() {
    super.initState();
    SessionApi.getAllTCP(widget.sessionConfig).then((v) {
      setState(() {
        _ServiceList = v.portConfigs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(Icons.devices,
              color: Provider.of<CustomTheme>(context).themeValue == "dark"
                  ? CustomThemes.dark.accentColor
                  : CustomThemes.light.accentColor),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(pair.description, style: Constants.titleTextStyle),
            ],
          ),
          trailing: Constants.rightArrowIcon,
        );
        return InkWell(
          onTap: () {
            //直接打开内置web浏览器浏览页面
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: new AppBar(title: new Text("网页浏览器"), actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.open_in_browser,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _launchURL(
                            "http://${Config.webgRpcIp}:${pair.localProt}");
                      })
                ]),
                body: WebView(
                    initialUrl: "http://${Config.webgRpcIp}:${pair.localProt}",
                    javascriptMode: JavascriptMode.unrestricted),
              );
            }));
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
        title: Text("本网络内的网关列表"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                refreshmDNSServices(widget.sessionConfig).then((result) {
                  SessionApi.getAllTCP(widget.sessionConfig).then((v) {
                    setState(() {
                      _ServiceList = v.portConfigs;
                    });
                  });
                });
              }),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                            title: Text("删除内网"),
                            content: Text("确认删除此内网？"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("取消"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("删除"),
                                onPressed: () {
                                  deleteOneSession(widget.sessionConfig);
//                                  ：TODO 删除之后刷新列表
                                  Navigator.of(context).pop();
                                },
                              )
                            ]));
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                _pushDetail(widget.sessionConfig);
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  void _pushDetail(SessionConfig config) async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    final List _result = [];
    _result.add("ID:${config.runId}");
    _result.add("描述:${config.description}");
    _result.add("连接码(简化后):${config.token.substring(0, 10)}");
    _result.add("转发连接状态:${config.statusToClient ? "在线" : "离线"}");
    _result.add(
        "P2P连接状态:${config.statusP2PAsClient || config.statusP2PAsServer ? "在线" : "离线"}");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _result.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: Constants.titleTextStyle,
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
              title: Text('网络详情'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Future deleteOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.deleteOneSession(config);
      print('Greeter client received: ${response}');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("删除结果："),
                  content: Text("删除成功！"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ])).then((result) {
        Navigator.of(context).pop();
      });
    } catch (e) {
      print('Caught error: $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("删除结果："),
                  content: Text("删除失败！$e"),
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

  Future refreshmDNSServices(SessionConfig sessionConfig) async {
    try {
      SessionApi.refreshmDNSServices(sessionConfig);
    } catch (e) {
      print('Caught error: $e');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
