import 'dart:async' as DeviceServiceTypesList;

import 'package:flutter/material.dart';
import 'package:openiothub/pages/commonDevice/services/httpPortListPage.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';

import './services/ftpPortListPage.dart';
import './services/tcpPortListPage.dart';
import './services/udpPortListPage.dart';

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
  final titles = ["TCP端口", "UDP端口", "FTP端口"];

  // , "HTTP端口"
  final List listData = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
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
          return Divider(
            height: 1.0,
          );
          break;
        case TAG_END:
          return Divider(
            height: 1.0,
          );
          break;
        case TAG_CENTER:
          return Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
            child: Divider(
              height: 1.0,
            ),
          );
          break;
        case TAG_BLANK:
          return Container(
            height: 20.0,
          );
          break;
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
    if (title == "TCP端口") {
      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
        return TcpPortListPage(
          device: widget.device,
          key: UniqueKey(),
        );
      }));
    } else if (title == "UDP端口") {
      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
        return UdpPortListPage(
          device: widget.device,
          key: UniqueKey(),
        );
      }));
    } else if (title == "FTP端口") {
      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
        return FtpPortListPage(
          device: widget.device,
          key: UniqueKey(),
        );
      }));
    } else if (title == "HTTP端口") {
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
    return Scaffold(
        appBar: AppBar(title: Text("服务"), actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                //TODO 删除小米网关设备
                _deleteCurrentDevice();
              }),
          IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              onPressed: () {
                //网络唤醒
                _wakeOnLAN();
              }),
//            TODO 设备的详情
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
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
                title: Text("删除设备"),
                content: Text("确认删除此设备？"),
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
                title: Text("唤醒设备"),
                content: Text("第一次使用请选择\'设置物理地址\'，设置过物理地址可以直接点击\'唤醒设备\'。"),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("重设物理地址"),
                    onPressed: () {
                      _setMacAddr().then((_) {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  TextButton(
                    child: Text("唤醒设备"),
                    onPressed: () {
                      CommonDeviceApi.wakeOnLAN(widget.device).then((_) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  Future _setMacAddr() async {
    TextEditingController _mac_controller = TextEditingController.fromValue(
        TextEditingValue(text: "54-07-2F-BB-BB-2F"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("设置物理地址"),
                content: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _mac_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '物理地址',
                        helperText: '机器有线网卡的物理地址',
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("设置"),
                    onPressed: () {
                      var device = widget.device;
                      device.mac = _mac_controller.text;
                      CommonDeviceApi.setDeviceMac(device).then((_) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  void _pushDetail() async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    final List _result = [];
    _result.add("本设备id:${widget.device.uuid}");
    _result.add("内网id:${widget.device.runId}");
    _result.add("描述:${widget.device.description}");
    _result.add("地址:${widget.device.addr}");
    _result.add("物理地址:${widget.device.mac}");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _result.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
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
              title: Text('设备详情'),
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
