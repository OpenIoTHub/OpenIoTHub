import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/mDNSInfo.dart';
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
              color: Provider.of<CustomTheme>(context).isLightTheme()
                  ? CustomThemes.light.accentColor
                  : CustomThemes.dark.accentColor),
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: AppBar(title: Text("网页浏览器"), actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _info(pair);
                      }),
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
        title: Text("本网络内的mdns列表"),
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
                            title: Text("删除网关"),
                            content: Text("确认删除此网关？"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("取消"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("删除"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteOneSession(widget.sessionConfig);
//                                  ：TODO 删除之后刷新列表
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
          divided.add(TextButton(
              onPressed: () async {
                String uuid = config.runId;
                var gatewayJwtValue = await GatewayManager.GetGatewayJwtByGatewayUuid(config.runId);
                String gatewayJwt = gatewayJwtValue.value;
                String data = '''
gatewayuuid: ${getOneUUID()}
logconfig:
  enablestdout: true
  logfilepath: ""
loginwithtokenmap:
  $uuid: $gatewayJwt
''';
                Clipboard.setData(ClipboardData(text: data));
                Fluttertoast.showToast(
                    msg: "网关的token已经复制到了剪切板！你可以将这个token复制到网关的配置文件了");
              },
              child: Text("复制网关Token")));
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
    //先通知远程的网关删除配置再删除本地的代理（拦截同时删除服务器配置）
    try {
      SessionApi.deleteRemoteGatewayConfig(config);
    } catch (e) {
      Fluttertoast.showToast(msg: "删除远程网关的配置失败$e");
    }
    try {
      SessionApi.deleteOneSession(config);
    } catch (e) {
      Fluttertoast.showToast(msg: "删除本地网关的映射失败$e");
    }
    Fluttertoast.showToast(msg: "网关成功!");
    Navigator.of(context).pop();
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

  _info(PortConfig portConfig) async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MDNSInfoPage(
            portConfig: portConfig,
          );
        },
      ),
    );
  }
}
