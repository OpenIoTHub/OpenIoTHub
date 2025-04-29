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

import 'createService.dart';

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
    refreshPortConfigList();
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
            "${pair.networkProtocol} ${pair.remotePort}:${pair.localProt}",
            style: Constants.subTitleTextStyle,
          ),
          trailing: TDButton(
              // text: 'More',
              icon: Icons.more_horiz,
              size: TDButtonSize.small,
              type: TDButtonType.outline,
              shape: TDButtonShape.rectangle,
              theme: TDButtonTheme.light,
              onTap: () {
                _pushPortConfigDetail(pair);
              }),
          contentPadding: const EdgeInsets.fromLTRB(16, 0.0, 16, 0.0),
        );
        return InkWell(
          onTap: () {
            //选择打开方式
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                        title: Text(
                            OpenIoTHubLocalizations.of(context).opening_method),
                        content: SizedBox.expand(child: OpenWithChoice(pair)),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                                OpenIoTHubLocalizations.of(context).cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ]));
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
                    _addOnePortConfig(widget.device).then((v) {
                      refreshPortConfigList();
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
        body: RefreshIndicator(
            onRefresh: () async {
              await refreshPortConfigList();
              return;
            },
            child: ListView(children: divided)));
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

  void _pushPortConfigDetail(PortConfig config) async {
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
    result.add(
        "${OpenIoTHubLocalizations.of(context).network_protocol}:${config.networkProtocol}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).application_protocol}:${config.applicationProtocol}");
    // TODO
    result.add(
        "${OpenIoTHubLocalizations.of(context).forwarding_connection_status}:${config.remotePortStatus ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CreateServiceWidget(device: widget.device,);
        },
      ),
    );
  }

  Future refreshPortConfigList() async {
    try {
      _ServiceList.clear();
      CommonDeviceApi.getAllTCP(widget.device).then((v) {
        setState(() {
          _ServiceList = v.portConfigs;
        });
      });
      CommonDeviceApi.getAllUDP(widget.device).then((v) {
        setState(() {
          _ServiceList.addAll(v.portConfigs);
        });
      });
      CommonDeviceApi.getAllFTP(widget.device).then((v) {
        setState(() {
          _ServiceList.addAll(v.portConfigs);
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Caught error: $e');
      }
    }
  }

  Future _addOnePortConfig(device) async {
    return showDialog(
        context: context,
        builder: (con) => CreateServiceWidget(device: device,));
  }

  Future _deleteOnePortConfig(PortConfig config) async {
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
      refreshPortConfigList();
    });
  }
}

class ListItem {
  String icon;
  String title;

  ListItem({required this.icon, required this.title});
}
