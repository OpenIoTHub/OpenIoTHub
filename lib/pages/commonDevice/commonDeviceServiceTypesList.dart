import 'dart:async' as DeviceServiceTypesList;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/pages/commonDevice/services/httpPortListPage.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import './services/ftpPortListPage.dart';
import './services/tcpPortListPage.dart';
import './services/udpPortListPage.dart';

import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

class CommonDeviceServiceTypesList extends StatefulWidget {
  CommonDeviceServiceTypesList({required Key key, required this.device})
      : super(key: key);

  Device device;

  @override
  _CommonDeviceServiceTypesListState createState() =>
      _CommonDeviceServiceTypesListState();
}

class _CommonDeviceServiceTypesListState
    extends State<CommonDeviceServiceTypesList> {
  static const String TAG_START = "startDivider";
  static const String TAG_END = "endDivider";
  static const String TAG_CENTER = "centerDivider";
  static const String TAG_BLANK = "blankDivider";

  static const double IMAGE_ICON_WIDTH = 30.0;

  final imagePaths = [
    "assets/images/ic_discover_softwares.png",
    "assets/images/ic_discover_git.png",
    "assets/images/ic_discover_gist.png",
    "assets/images/ic_discover_scan.png",
    "assets/images/ic_discover_shake.png",
    "assets/images/ic_discover_nearby.png",
    "assets/images/ic_discover_pos.png",
  ];
  List<String> titles = [];

  // , "HTTP端口"
  final List listData = [];

  @override
  void initState() {
    super.initState();
  }

  initData(BuildContext context) {
    titles = [
      OpenIoTHubLocalizations.of(context).tcp_port,
      OpenIoTHubLocalizations.of(context).udp_port,
      OpenIoTHubLocalizations.of(context).ftp_port
    ];
    listData.add(TAG_START);
    listData.add(ListItem(title: titles[0], icon: imagePaths[0]));
//    listData.add(TAG_CENTER);
    listData.add(TAG_END);
    listData.add(TAG_BLANK);
    listData.add(TAG_START);
    listData.add(ListItem(title: titles[1], icon: imagePaths[1]));
    listData.add(TAG_END);
    listData.add(TAG_BLANK);
    listData.add(TAG_START);
    listData.add(ListItem(title: titles[2], icon: imagePaths[2]));
    listData.add(TAG_END);
    // listData.add(TAG_BLANK);
    // listData.add(TAG_START);
    // listData.add(ListItem(title: titles[3], icon: imagePaths[3]));
    // listData.add(TAG_END);
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  renderRow(BuildContext ctx, int i) {
    var item = listData[i];
    if (item is String) {
      switch (item) {
        case TAG_START:
          return const TDDivider();
        case TAG_END:
          return const TDDivider();
        case TAG_CENTER:
          return const Padding(
            padding: EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
            child: TDDivider(),
          );
        case TAG_BLANK:
          return Container(
            height: 20.0,
          );
      }
    } else if (item is ListItem) {
      var listItemContent = Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Row(
          children: <Widget>[
            getIconImage(item.icon),
            Expanded(
                child: Text(
              item.title,
              style: Constants.titleTextStyle,
            )),
            Constants.rightArrowIcon
          ],
        ),
      );
      return InkWell(
        onTap: () {
          handleListItemClick(ctx, item);
        },
        child: listItemContent,
      );
    }
  }

  void handleListItemClick(BuildContext ctx, ListItem item) {
    String title = item.title;
    if (title == OpenIoTHubLocalizations.of(context).tcp_port) {
      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
        return TcpPortListPage(
          device: widget.device,
          key: UniqueKey(),
        );
      }));
    } else if (title == OpenIoTHubLocalizations.of(context).udp_port) {
      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
        return UdpPortListPage(
          device: widget.device,
          key: UniqueKey(),
        );
      }));
    } else if (title == OpenIoTHubLocalizations.of(context).ftp_port) {
      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
        return FtpPortListPage(
          device: widget.device,
          key: UniqueKey(),
        );
      }));
    } else if (title == OpenIoTHubLocalizations.of(context).http_port) {
      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
        return HttpPortListPage(
          device: widget.device,
          key: UniqueKey(),
        );
      }));
    }
  }

  DeviceServiceTypesList.Future scan() async {
    try {} on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    initData(context);
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, i) => renderRow(context, i),
          ),
        ));
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
}

class ListItem {
  String icon;
  String title;

  ListItem({required this.icon, required this.title});
}
