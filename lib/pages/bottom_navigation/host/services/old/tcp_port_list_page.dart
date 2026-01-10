import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/openWithChoice/OpenWithChoice.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub/widgets/toast.dart';

class TcpPortListPage extends StatefulWidget {
  TcpPortListPage({required Key key, required this.device}) : super(key: key);

  Device device;

  @override
  _TcpPortListPageState createState() => _TcpPortListPageState();
}

class _TcpPortListPageState extends State<TcpPortListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  List<PortConfig> _ServiceList = [];

  @override
  void initState() {
    super.initState();
    refreshmTcpList();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: (pair.name.isEmpty ? pair.description : pair.name)[0],
            shape: TDAvatarShape.square,
            backgroundColor:
                pair.remotePortStatus ? Colors.green : Colors.deepOrange,
          ),
          title: Text(pair.name.isEmpty ? pair.description : pair.name),
          subtitle: Text(
            "${pair.remotePort}:${pair.localProt}",
            style: Constants.subTitleTextStyle,
          ),
          trailing: Constants.rightArrowIcon,
          contentPadding: const EdgeInsets.fromLTRB(16, 0.0, 16, 0.0),
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
        title: Text(OpenIoTHubLocalizations.of(context).tcp_port_list_title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {
                //刷新端口列表
                refreshmTcpList();
              }),
          IconButton(
              icon: const Icon(
                Icons.add_circle,
                // color: Colors.white,
              ),
              onPressed: () {
//                添加TCP端口
                _addTCP(widget.device).then((v) {
                  refreshmTcpList();
                });
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  void _pushDetail(PortConfig config) async {
    final List result = [];
    result.add("UUID:${config.uuid}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).remote_port}:${config.remotePort}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).local_port}:${config.localProt}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).description}:${config.description}");
    result
        .add("${OpenIoTHubLocalizations.of(context).domain}:${config.domain}");
    // TODO
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
                        //删除
                        _deleteCurrentTCP(config);
                      }),
                  IconButton(
                      icon: const Icon(
                        Icons.open_in_browser,
                        // color: Colors.white,
                      ),
                      onPressed: () {
                        //                TODO 使用某种方式打开此端口，检查这个软件是否已经安装
//                    _launchURL("http://127.0.0.1:${config.localProt}");
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                    title: Text(
                                        OpenIoTHubLocalizations.of(context)
                                            .opening_method),
                                    content: SizedBox.expand(
                                        child: OpenWithChoice(config)),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                            OpenIoTHubLocalizations.of(context)
                                                .cancel),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                            OpenIoTHubLocalizations.of(context)
                                                .add),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ]));
                      }),
                ]),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Future refreshmTcpList() async {
    try {
      CommonDeviceApi.getAllTCP(widget.device).then((v) {
        setState(() {
          _ServiceList = v.portConfigs;
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Caught error: $e');
      }
    }
  }

  Future _addTCP(Device device) async {
    TextEditingController descriptionController =
        TextEditingController.fromValue(TextEditingValue(
            text: OpenIoTHubLocalizations.of(context).my_tcp_port));
    TextEditingController remotePortController =
        TextEditingController.fromValue(const TextEditingValue(text: "80"));
    TextEditingController localPortController =
        TextEditingController.fromValue(const TextEditingValue(text: "0"));
    TextEditingController domainController = TextEditingController.fromValue(
        const TextEditingValue(text: "www.example.com"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).add_port),
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText:
                            OpenIoTHubLocalizations.of(context).description,
                        helperText:
                            OpenIoTHubLocalizations.of(context).custom_remarks,
                      ),
                    ),
                    TextFormField(
                      controller: remotePortController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubLocalizations.of(context)
                            .the_port_number_that_the_remote_machine_needs_to_access,
                        helperText:
                            OpenIoTHubLocalizations.of(context).remote_port,
                      ),
                    ),
                    TextFormField(
                      controller: localPortController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubLocalizations.of(context)
                            .map_to_the_port_number_of_this_mobile_phone,
                        helperText: OpenIoTHubLocalizations.of(context)
                            .this_phone_has_an_idle_port_number_of_1024_or_above,
                      ),
                    ),
                    TextFormField(
                      controller: domainController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubLocalizations.of(context).domain,
                        helperText:
                            OpenIoTHubLocalizations.of(context).domain_notes,
                      ),
                    ),
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
                      var tcpConfig = PortConfig();
                      tcpConfig.device = device;
                      tcpConfig.description = descriptionController.text;
                      try {
                        tcpConfig.remotePort =
                            int.parse(remotePortController.text);
                        tcpConfig.localProt =
                            int.parse(localPortController.text);
                      } catch (e) {
                        show_failed(
                            "${OpenIoTHubLocalizations.of(context).check_if_the_port_is_a_number}:$e",context);
                        return;
                      }
                      tcpConfig.networkProtocol = "tcp";
                      if (domainController.text != "www.example.com") {
                        tcpConfig.domain = domainController.text;
                        tcpConfig.applicationProtocol = "http";
                      } else {
                        tcpConfig.applicationProtocol = "unknown";
                      }
                      CommonDeviceApi.createOneTCP(tcpConfig).then((restlt) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  Future _deleteCurrentTCP(PortConfig config) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).delete_tcp),
                content: SizedBox.expand(
                    child: Text(OpenIoTHubLocalizations.of(context)
                        .confirm_to_delete_this_tcp)),
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
                      CommonDeviceApi.deleteOneTCP(config).then((result) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ])).then((v) {
      Navigator.of(context).pop();
    }).then((v) {
      refreshmTcpList();
    });
  }
}
