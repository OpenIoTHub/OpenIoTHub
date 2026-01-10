import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';

import 'package:openiothub/widgets/toast.dart';

class UdpPortListPage extends StatefulWidget {
  UdpPortListPage({required Key key, required this.device}) : super(key: key);

  Device device;

  @override
  _UdpPortListPageState createState() => _UdpPortListPageState();
}

class _UdpPortListPageState extends State<UdpPortListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  List<PortConfig> _ServiceList = [];

  @override
  void initState() {
    super.initState();
    refreshmUDPList();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map(
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
        title: Text(OpenIoTHubLocalizations.of(context).udp_port_list_title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {
                //刷新端口列表
                refreshmUDPList();
              }),
          IconButton(
              icon: const Icon(
                Icons.add_circle,
                // color: Colors.white,
              ),
              onPressed: () {
//                TODO 添加UDP端口
                _addUDP(widget.device).then((v) {
                  refreshmUDPList();
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
                        _deleteCurrentUDP(config);
                      }),
//                IconButton(
//                  icon: Icon(
//                    Icons.open_in_browser,
//                    color: Colors.white,
//                  ),
//                  onPressed: () {
//    //                TODO 使用某种方式打开此端口
//                    _launchURL("http://127.0.0.1:${config.localProt}");
//                  }),
                ]),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Future refreshmUDPList() async {
    try {
      CommonDeviceApi.getAllUDP(widget.device).then((v) {
        setState(() {
          _ServiceList = v.portConfigs;
        });
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future _addUDP(Device device) async {
    TextEditingController descriptionController =
        TextEditingController.fromValue(TextEditingValue(
            text: OpenIoTHubLocalizations.of(context).my_udp_port));
    TextEditingController remotePortController =
        TextEditingController.fromValue(const TextEditingValue(text: ""));
    TextEditingController localPortController =
        TextEditingController.fromValue(const TextEditingValue(text: ""));
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
                      var UDPConfig = PortConfig();
                      UDPConfig.device = device;
                      UDPConfig.description = descriptionController.text;
                      try {
                        UDPConfig.remotePort =
                            int.parse(remotePortController.text);
                        UDPConfig.localProt =
                            int.parse(localPortController.text);
                      } catch (e) {
                        show_failed(
                            "${OpenIoTHubLocalizations.of(context).check_if_the_port_is_a_number}:$e",context);
                        return;
                      }
                      UDPConfig.networkProtocol = "udp";
                      UDPConfig.applicationProtocol = "unknown";
                      CommonDeviceApi.createOneUDP(UDPConfig).then((restlt) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  Future _deleteCurrentUDP(PortConfig config) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).delete_udp),
                content: SizedBox.expand(
                    child: Text(OpenIoTHubLocalizations.of(context)
                        .confirm_to_delete_this_udp)),
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
                      CommonDeviceApi.deleteOneUDP(config).then((result) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ])).then((v) {
      Navigator.of(context).pop();
    }).then((v) {
      refreshmUDPList();
    });
  }
}
