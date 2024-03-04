import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/util/ThemeUtils.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/findmDNSClientList.dart';
import 'package:openiothub_common_pages/wifiConfig/smartConfigTool.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../commonPages/scanQR.dart';
import './commonDeviceServiceTypesList.dart';

class CommonDeviceListPage extends StatefulWidget {
  const CommonDeviceListPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  _CommonDeviceListPageState createState() => _CommonDeviceListPageState();
}

class _CommonDeviceListPageState extends State<CommonDeviceListPage> {
  List<SessionConfig> _SessionList = [];
  List<Device> _CommonDeviceList = [];
  late Timer _timerPeriod;

  @override
  void initState() {
    super.initState();
    getAllCommonDevice();
    _timerPeriod = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      getAllCommonDevice();
    });
    print("init common devie List");
  }

  @override
  void dispose() {
    super.dispose();
    _timerPeriod.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _CommonDeviceList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(Icons.devices,
              color: Provider.of<CustomTheme>(context).isLightTheme()
                  ? CustomThemes.light.primaryColorLight
                  : CustomThemes.dark.primaryColorDark),
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
            _pushDeviceServiceTypes(pair);
          },
          child: listItemContent,
        );
      },
    );
    final divided = ListView.separated(
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        return tiles.elementAt(index);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          indent: 50,
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: _build_actions(),
      ),
      body: tiles.isNotEmpty
          ? divided
          : Container(
              child: Column(children: [
                ThemeUtils.isDarkMode(context)
                    ? Center(child: Image.asset('assets/images/empty_list_black.png'),)
                    : Center(child:Image.asset('assets/images/empty_list.png'),),
                TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.grey, width: 1)),
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                    ),
                    onPressed: () {
                      _addRemoteHostFromSession();
                    },
                    child: const Text("请先添加主机"))
              ]),
            ),
    );
  }

  Future _addDevice(SessionConfig config) async {
    TextEditingController descriptionController =
        TextEditingController.fromValue(const TextEditingValue(text: "内网设备"));
    TextEditingController remoteIpController = TextEditingController.fromValue(
        const TextEditingValue(text: "127.0.0.1"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text("添加设备："),
                content: ListView(
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
                      controller: remoteIpController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '远程内网的IP',
                        helperText: '内网设备的IP',
                      ),
                    ),
                  ],
                ),
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
                      var device = Device();
                      device.runId = config.runId;
                      device.uuid = getOneUUID();
                      device.description = descriptionController.text;
                      device.addr = remoteIpController.text;
                      createOneCommonDevice(device).then((v) {
                        getAllCommonDevice().then((v) {
                          Navigator.of(context).pop();
                        });
                      });
                    },
                  )
                ]));
  }

  void _pushDeviceServiceTypes(Device device) async {
    // 查看设备下的服务 CommonDeviceServiceTypesList
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return CommonDeviceServiceTypesList(
            device: device,
            key: UniqueKey(),
          );
        },
      ),
    ).then((result) {
      setState(() {
        getAllSession();
      });
    });
  }

  Future getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('Greeter client received: ${response.sessionConfigs}');
      setState(() {
        _SessionList = response.sessionConfigs;
      });
    } catch (e) {
      showToast("getAllSession：$e");
    }
  }

  Future createOneCommonDevice(Device device) async {
    try {
      await CommonDeviceApi.createOneDevice(device);
    } catch (e) {
      showToast("创建设备失败：$e");
    }
  }

  Future getAllCommonDevice() async {
    try {
      final response = await CommonDeviceApi.getAllDevice();
      print("=====getAllDevice:${response.devices}");
      setState(() {
        _CommonDeviceList = response.devices;
      });
    } catch (e) {
      if (kDebugMode) {
        print("openiothub获取设备失败:$e");
      }
      // showToast( "获取设备列表失败：${e}");
    }
  }

  void _addRemoteHostFromSession() {
    getAllSession().then((v) {
      final tiles = _SessionList.map(
        (pair) {
          var listItemContent = Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            child: Row(
              children: <Widget>[
                const Icon(Icons.cloud_done),
                Expanded(
                    child: Text(
                  "${pair.name}(${pair.description})",
                  style: Constants.titleTextStyle,
                )),
                Constants.rightArrowIcon
              ],
            ),
          );
          return InkWell(
            onTap: () {
              _addDevice(pair).then((v) {
                Navigator.of(context).pop();
              });
            },
            child: listItemContent,
          );
        },
      );
      final divided = ListView.separated(
        itemCount: tiles.length,
        itemBuilder: (context, index) {
          return tiles.elementAt(index);
        },
        separatorBuilder: (context, index) {
          return const Divider(
            indent: 50,
          );
        },
      );
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: const Text("请选择远程主机所在网络："),
                  content: divided,
                  actions: <Widget>[
                    TextButton(
                      child: const Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ])).then((v) {
        getAllCommonDevice().then((v) {
          setState(() {});
        });
      });
    });
  }

  static _buildPopupMenuItem(IconData icon, String title) {
    return Row(children: <Widget>[
      Icon(
        icon,
        // color: Colors.white,
      ),
      //Image.asset(CommonUtils.getBaseIconUrlPng("main_top_add_friends"), width: 18, height: 18,),

      Container(width: 12.0),
      Text(
        title,
        // style: TextStyle(color: Color(0xFFFFFFFF)),
      )
    ]);
  }

  List<Widget>? _build_actions() {
    return <Widget>[
      PopupMenuButton(
        tooltip: "",
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              child: _buildPopupMenuItem(
                  Icons.wifi_tethering, S.current.config_device_wifi),
              value: "config_device_wifi",
            ),
            const PopupMenuDivider(
              height: 1.0,
            ),
            PopupMenuItem(
              child:
              _buildPopupMenuItem(Icons.qr_code_scanner, S.current.scan_QR),
              value: "scan_QR",
            ),
            const PopupMenuDivider(
              height: 1.0,
            ),
            PopupMenuItem(
              child:
              _buildPopupMenuItem(Icons.search, S.current.find_local_gateway),
              value: "find_local_gateway",
            ),
            const PopupMenuDivider(
              height: 1.0,
            ),
            PopupMenuItem(
              child:
              _buildPopupMenuItem(Icons.add, S.current.add_remote_host),
              value: "add_remote_host",
            ),
          ];
        },
        padding: EdgeInsets.only(top: 0.0),
        elevation: 5.0,
        icon: const Icon(Icons.add_circle_outline),
        onSelected: (String selected) {
          switch (selected) {
            case 'config_device_wifi':
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SmartConfigTool(
                      title: S.current.config_device_wifi,
                      needCallBack: true,
                      key: UniqueKey(),
                    );
                  },
                ),
              );
              break;
            case 'scan_QR':
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ScanQRPage();
                  },
                ),
              );
              break;
            case 'find_local_gateway':
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    // 写成独立的组件，支持刷新
                    return FindmDNSClientListPage(
                      key: UniqueKey(),
                    );
                  },
                ),
              );
              break;
            case 'add_remote_host':
              _addRemoteHostFromSession();
              break;
          }
        },
      ),
    ];
  }
}
