import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/commonDevice/services/old/commonDeviceServiceTypesList.dart';
import 'package:openiothub/util/ThemeUtils.dart';
import 'package:openiothub/widgets/BuildGlobalActions.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

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
    _timerPeriod = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
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
          leading: TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: pair.description[0],
            shape: TDAvatarShape.square,
            backgroundColor: Color.fromRGBO(
              Random().nextInt(156) + 50, // 随机生成0到255之间的整数
              Random().nextInt(156) + 50, // 随机生成0到255之间的整数
              Random().nextInt(156) + 50, // 随机生成0到255之间的整数
              1, // 不透明度，1表示完全不透明
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(pair.description, style: Constants.titleTextStyle),
            ],
          ),
          subtitle: Text(
            "${pair.addr}@${pair.runId.substring(24)}",
            style: Constants.subTitleTextStyle,
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
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        return tiles.elementAt(index);
      },
      separatorBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 70), // 添加左侧缩进
          child: TDDivider(),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: build_actions(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
        elevation: 2.0,
        tooltip: 'Add Host',
        onPressed: () {
          _addRemoteHostFromSession();
        },
      ),
      body: RefreshIndicator(
        onRefresh: getAllCommonDevice,
        child: tiles.isNotEmpty
            ? divided
            : Container(
                child: Column(children: [
                  ThemeUtils.isDarkMode(context)
                      ? Center(
                          child:
                              Image.asset('assets/images/empty_list_black.png'),
                        )
                      : Center(
                          child: Image.asset('assets/images/empty_list.png'),
                        ),
                  TextButton(
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(
                            const BorderSide(color: Colors.grey, width: 1)),
                        shape: WidgetStateProperty.all(const StadiumBorder()),
                      ),
                      onPressed: () {
                        _addRemoteHostFromSession();
                      },
                      child: Text(OpenIoTHubLocalizations.of(context)
                          .please_add_host_first))
                ]),
              ),
      ),
    );
  }

  Future _addDevice(SessionConfig config) async {
    TextEditingController descriptionController =
        TextEditingController.fromValue(TextEditingValue(
            text:
                OpenIoTHubLocalizations.of(context).internal_network_devices));
    TextEditingController remoteIpController = TextEditingController.fromValue(
        const TextEditingValue(text: "127.0.0.1"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).add_device),
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
                      controller: remoteIpController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubLocalizations.of(context)
                            .ip_address_of_remote_intranet,
                        helperText: OpenIoTHubLocalizations.of(context)
                            .ip_address_of_internal_network_devices,
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
      showToast(
          "${OpenIoTHubLocalizations.of(context).create_device_failed}：$e");
    }
  }

  Future<void> getAllCommonDevice() async {
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
    return;
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
          return Container(
            padding: EdgeInsets.only(left: 50), // 添加左侧缩进
            child: TDDivider(),
          );
        },
      );
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text(OpenIoTHubLocalizations.of(context)
                      .select_the_network_where_the_remote_host_is_located),
                  content: SizedBox.expand(child: divided),
                  actions: <Widget>[
                    TextButton(
                      child: Text(OpenIoTHubLocalizations.of(context).cancel),
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
}
