import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_api/api/Server/HttpManager.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart' as openiothub;
import 'package:openiothub_grpc_api/proto/server/server.pb.dart';
import 'package:url_launcher/url_launcher.dart';

class HttpPortListPage extends StatefulWidget {
  HttpPortListPage({required Key key, required this.device}) : super(key: key);

  openiothub.Device device;

  @override
  _HttpPortListPageState createState() => _HttpPortListPageState();
}

class _HttpPortListPageState extends State<HttpPortListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  List<HTTPConfig> _HttpList = [];
  late Timer _timerPeriod;

  @override
  void initState() {
    super.initState();
    refreshmHttpList();
    _timerPeriod = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      refreshmHttpList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timerPeriod.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _HttpList.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.devices),
              ),
              Expanded(
                  child: Text(
                "${pair.description}(${pair.remotePort})",
                style: Constants.titleTextStyle,
              )),
              Constants.rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            //打开此端口的详情
            _pushDetail(pair);
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
        title: const Text("Http端口列表"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {
                //刷新端口列表
                refreshmHttpList();
              }),
          IconButton(
              icon: const Icon(
                Icons.add_circle,
                // color: Colors.white,
              ),
              onPressed: () {
//                TODO 添加Http端口
                _addHttp(widget.device).then((v) {
                  refreshmHttpList();
                });
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  void _pushDetail(HTTPConfig config) async {
    final List result = [];
    result.add("端口:${config.remotePort}");
    result.add("域名:${config.domain}");
    result.add("描述:${config.description}");
    result.add("转发连接状态:${config.remotePortStatus ? "在线" : "离线"}");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = result.map(
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
            appBar: AppBar(title: const Text('端口详情'), actions: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    //TODO 删除
                    _deleteCurrentHttp(config);
                  }),
              IconButton(
                  icon: const Icon(
                    Icons.open_in_browser,
                    // color: Colors.white,
                  ),
                  onPressed: () async {
                    //TODO 使用某种方式打开此端口，检查这个软件是否已经安装
                    _launchURL("http://${config.domain}");
                  }),
            ]),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Future refreshmHttpList() async {
    try {
      HttpManager.GetAllHTTP(widget.device).then((v) {
        setState(() {
          _HttpList = v.hTTPConfigs;
        });
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future _addHttp(openiothub.Device device) async {
    TextEditingController descriptionController =
        TextEditingController.fromValue(const TextEditingValue(text: "Http"));
    TextEditingController domainController = TextEditingController.fromValue(
        const TextEditingValue(text: "example.com"));
    TextEditingController portController =
        TextEditingController.fromValue(const TextEditingValue(text: "80"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text("添加端口域名："),
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '备注',
                        helperText: '自定义备注',
                      ),
                    ),
                    TextFormField(
                      controller: domainController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '域名',
                        helperText: '配置该端口的域名',
                      ),
                    ),
                    TextFormField(
                      controller: portController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '端口',
                        helperText: '需要映射的端口',
                      ),
                    )
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child: const Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("添加"),
                    onPressed: () {
                      HTTPConfig HttpConfig = HTTPConfig();
                      HttpConfig.runId = device.runId;
                      HttpConfig.description = descriptionController.text;
                      HttpConfig.remoteIP = device.addr;
                      HttpConfig.remotePort = int.parse(portController.text);
                      HttpConfig.domain = domainController.text;
                      HttpManager.CreateOneHTTP(HttpConfig).then((restlt) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  Future _deleteCurrentHttp(HTTPConfig config) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text("删除Http"),
                content: SizedBox.expand(child: const Text("确认删除此Http？")),
                actions: <Widget>[
                  TextButton(
                    child: const Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("删除"),
                    onPressed: () {
                      HttpManager.DeleteOneHTTP(config).then((result) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ])).then((v) {
      Navigator.of(context).pop();
    }).then((v) {
      refreshmHttpList();
    });
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }
}
