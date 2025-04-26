import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_plugin/plugins/openWithChoice/OpenWithChoice.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ServicesListPage extends StatefulWidget {
  ServicesListPage({required Key key, required this.device}) : super(key: key);

  final Device device;

  @override
  _ServicesListPageState createState() => _ServicesListPageState();
}

class _ServicesListPageState extends State<ServicesListPage> {
  List<PortConfig> _ServiceList = [];

  @override
  void initState() {
    super.initState();
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
            _pushTcpDetail(pair);
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
            title: Text(OpenIoTHubLocalizations.of(context).service),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    //TODO 删除小米网关设备
                    _deleteCurrentDevice();
                  }),
              IconButton(
                  icon: const Icon(
                    Icons.power_settings_new,
                    // color: Colors.white,
                  ),
                  onPressed: () {
                    //网络唤醒
                    _wakeOnLAN();
                  }),
              IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    // color: Colors.white,
                  ),
                  onPressed: () {
                    // 添加TCP、UDP、Http端口
                    _addTCP(widget.device).then((v) {
                      refreshmTcpList();
                    });
                  }),
//            TODO 设备的详情
              IconButton(
                  icon: const Icon(
                    Icons.info,
                    // color: Colors.white,
                  ),
                  onPressed: () {
                    //网络唤醒
                    _pushDetail();
                  }),
            ]),
        body: Text(""));
  }

  Future _deleteCurrentDevice() async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).delete_device),
                content: SizedBox.expand(
                    child: Text(OpenIoTHubLocalizations.of(context)
                        .confirm_delete_device)),
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
                      CommonDeviceApi.deleteOneDevice(widget.device)
                          .then((result) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ])).then((v) {
      Navigator.of(context).pop();
    });
  }

  Future _wakeOnLAN() async {
    if (widget.device.mac == '') {
      return _setMacAddr();
    }
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).wake_up_device),
                content: SizedBox.expand(
                    child: Text(OpenIoTHubLocalizations.of(context)
                        .wake_up_device_notes1)),
                actions: <Widget>[
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context)
                        .reset_physical_address),
                    onPressed: () {
                      _setMacAddr().then((_) {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  TextButton(
                    child: Text(
                        OpenIoTHubLocalizations.of(context).wake_up_device),
                    onPressed: () {
                      CommonDeviceApi.wakeOnLAN(widget.device).then((_) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  Future _setMacAddr() async {
    TextEditingController macController = TextEditingController.fromValue(
        const TextEditingValue(text: "54-07-2F-BB-BB-2F"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
                    OpenIoTHubLocalizations.of(context).set_physical_address),
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: macController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubLocalizations.of(context)
                            .physical_address,
                        helperText: OpenIoTHubLocalizations.of(context)
                            .the_physical_address_of_the_machine,
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
                    child: Text(OpenIoTHubLocalizations.of(context).set),
                    onPressed: () {
                      var device = widget.device;
                      device.mac = macController.text;
                      CommonDeviceApi.setDeviceMac(device).then((_) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  void _pushDetail() async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    final List result = [];
    result.add(
        "${OpenIoTHubLocalizations.of(context).device_id}:${widget.device.uuid.substring(24)}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).gateway_id}:${widget.device.runId.substring(24)}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).description}:${widget.device.description}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).addr}:${widget.device.addr}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).physical_address}:${widget.device.mac}");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = result.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                ),
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: pair));
                  showToast(
                      OpenIoTHubLocalizations.of(context).copy_successful);
                },
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text(OpenIoTHubLocalizations.of(context).device_details),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pushTcpDetail(PortConfig config) async {
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
                        showToast(
                            "${OpenIoTHubLocalizations.of(context).check_if_the_port_is_a_number}:$e");
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

class ListItem {
  String icon;
  String title;

  ListItem({required this.icon, required this.title});
}
