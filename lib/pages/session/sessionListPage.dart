import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:provider/provider.dart';
import 'package:openiothub_common_pages/commPages/findmDNSClientList.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:openiothub/pages/session/sessionmDNSServiceListPage.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';

class SessionListPage extends StatefulWidget {
  SessionListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SessionListPageState createState() => _SessionListPageState();
}

class _SessionListPageState extends State<SessionListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;

  List<SessionConfig> _SessionList = [];
  Timer _timerPeriod;

  @override
  void initState() {
    super.initState();
    getAllSession();
    _timerPeriod = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      getAllSession();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timerPeriod != null) {
      _timerPeriod.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _SessionList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(Icons.cloud_done,
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
            _pushmDNSServices(pair);
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
          leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  getAllSession();
                }),
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  _pushFindmDNSClientListPage();
                }),
            IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  TextEditingController _token_controller =
                      TextEditingController.fromValue(
                          TextEditingValue(text: ""));
                  TextEditingController _description_controller =
                      TextEditingController.fromValue(
                          TextEditingValue(text: "我的网络"));
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                              title: Text("手动添加网关："),
                              content: ListView(
                                children: <Widget>[
                                  TextFormField(
                                    controller: _token_controller,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: '请输入远程网关Token',
                                      helperText: 'token',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _description_controller,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: '请输入备注',
                                      helperText: '备注',
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
                                  child: Text("添加"),
                                  onPressed: () {
                                    SessionConfig config = SessionConfig();
                                    config.token = _token_controller.text;
                                    config.description =
                                        _description_controller.text;
                                    createOneSession(config).then((restlt) {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                )
                              ])).then((restlt) {
                    setState(() {
                      getAllSession();
                    });
                  });
                }),
          ],
        ),
        body: ListView(children: divided));
  }

  void _pushmDNSServices(SessionConfig config) async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return MDNSServiceListPage(sessionConfig: config);
        },
      ),
    ).then((result) {
      setState(() {
        getAllSession();
      });
    });
  }

  void _pushFindmDNSClientListPage() async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return FindmDNSClientListPage();
        },
      ),
    ).then((result) {
      setState(() {
        getAllSession();
      });
    });
  }

  Future createOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.createOneSession(config);
      print('Greeter client received: ${response}');
    } catch (e) {
      print('Caught error: $e');
    }
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

  Future getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('Greeter client received: ${response.sessionConfigs}');
      setState(() {
        _SessionList = response.sessionConfigs;
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future refreshmDNSServices(SessionConfig sessionConfig) async {
    try {
      await SessionApi.refreshmDNSServices(sessionConfig);
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }
}
