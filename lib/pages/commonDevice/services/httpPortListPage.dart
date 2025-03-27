import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_api/api/Server/HttpManager.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart' as openiothub;
import 'package:openiothub_grpc_api/proto/server/server.pb.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
        title: Text(OpenIoTHubLocalizations.of(context).http_port_list_title),
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
    result.add(
        "${OpenIoTHubLocalizations.of(context).remote_port}:${config.remotePort}");
    result
        .add("${OpenIoTHubLocalizations.of(context).domain}:${config.domain}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).description}:${config.description}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).forwarding_connection_status}:${config.remotePortStatus ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}");
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
            appBar: AppBar(
                title: Text(OpenIoTHubLocalizations.of(context).port_details),
                actions: <Widget>[
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
                title: Text(
                    OpenIoTHubLocalizations.of(context).add_port_domain_name),
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubLocalizations.of(context).notes,
                        helperText:
                            OpenIoTHubLocalizations.of(context).custom_remarks,
                      ),
                    ),
                    TextFormField(
                      controller: domainController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubLocalizations.of(context).domain,
                        helperText: OpenIoTHubLocalizations.of(context)
                            .configure_the_domain_name_for_this_port,
                      ),
                    ),
                    TextFormField(
                      controller: portController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText:
                            OpenIoTHubLocalizations.of(context).remote_port,
                        helperText: OpenIoTHubLocalizations.of(context)
                            .ports_that_need_to_be_mapped,
                      ),
                    )
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).add),
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
                title:
                    Text(OpenIoTHubLocalizations.of(context).delete_this_http),
                content: SizedBox.expand(
                    child: Text(OpenIoTHubLocalizations.of(context)
                        .are_you_sure_to_delete_this_http)),
                actions: <Widget>[
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).delete),
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
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }
}
