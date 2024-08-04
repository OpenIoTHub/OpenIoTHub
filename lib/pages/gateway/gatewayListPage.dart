import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:oktoast/oktoast.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/util/ThemeUtils.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/findmDNSClientList.dart';
import 'package:openiothub_common_pages/wifiConfig/smartConfigTool.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:provider/provider.dart';

import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../commonPages/scanQR.dart';
import './mDNSServiceListPage.dart';

class GatewayListPage extends StatefulWidget {
  const GatewayListPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  _GatewayListPageState createState() => _GatewayListPageState();
}

class _GatewayListPageState extends State<GatewayListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;

  List<SessionConfig> _SessionList = [];
  late Timer _timerPeriod;

  @override
  void initState() {
    super.initState();
    getAllSession();
    _timerPeriod = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      getAllSession();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timerPeriod.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _SessionList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: TDAvatar(
            size: TDAvatarSize.large,
            type: TDAvatarType.customText,
            text: pair.name[0],
            shape: TDAvatarShape.square,
            backgroundColor: Provider.of<CustomTheme>(context).isLightTheme()
                ? CustomThemes.light.iconTheme.color
                : CustomThemes.dark.iconTheme.color,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("${pair.name}(${pair.description})",
                  style: Constants.titleTextStyle),
            ],
          ),
          subtitle: pair.statusToClient ||
                  pair.statusP2PAsClient ||
                  pair.statusP2PAsServer
              ? const Text(
                  "在线",
                  style: TextStyle(color: Colors.green),
                )
              : const Text(
                  "离线",
                  style: TextStyle(color: Colors.grey),
                ),
          trailing: Constants.rightArrowIcon,
        );
        return InkWell(
          onTap: () {
            _pushmDNSServices(pair);
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
        return const TDDivider();
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: _build_actions(),
      ),
      body: RefreshIndicator(
        onRefresh: getAllSession,
        child: tiles.isNotEmpty
            ? divided
            : Column(children: [
                ThemeUtils.isDarkMode(context)
                    ? Center(
                        child:
                            Image.asset('assets/images/empty_list_black.png'),
                      )
                    : Center(
                        child: Image.asset('assets/images/empty_list.png'),
                      ),
                const Text("请使用右上角放大镜查找你在本局域网安装的网关"),
              ]),
      ),
    );
  }

  void _pushmDNSServices(SessionConfig config) async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return MDNSServiceListPage(
            sessionConfig: config,
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

  void _pushFindmDNSClientListPage() async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return FindmDNSClientListPage(
            key: UniqueKey(),
          );
        },
      ),
    ).then((result) {
      setState(() {
        // showToast( "我返回回来了");
        getAllSession();
      });
    });
  }

  Future createOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.createOneSession(config);
      print('Greeter client received: $response');
    } catch (e) {
      print('Caught error: $e');
    }
  }

  void deleteOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.deleteOneSession(config);
      print('Greeter client received: $response');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: const Text("删除结果："),
                  content: const Text("删除成功！"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("确认"),
                      onPressed: () {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    )
                  ])).then((result) {
        if (!context.mounted) return;
        Navigator.of(context).pop();
      });
    } catch (e) {
      print('Caught error: $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: const Text("删除结果："),
                  content: Text("删除失败！$e"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("取消"),
                      onPressed: () {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text("确认"),
                      onPressed: () {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  Future<void> getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('Greeter client received: ${response.sessionConfigs}');
      setState(() {
        _SessionList = response.sessionConfigs;
      });
    } catch (e) {
      print('Caught error: $e');
    }
    return;
  }

  Future refreshmDNSServices(SessionConfig sessionConfig) async {
    try {
      await SessionApi.refreshmDNSServices(sessionConfig);
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
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
    var popupMenuEntrys = <PopupMenuEntry<String>>[
      PopupMenuItem(
        //child: _buildPopupMenuItem(Icons.camera_alt, '扫一扫'),
        child: _buildPopupMenuItem(TDIcons.search, OpenIoTHubLocalizations.of(context).find_local_gateway),
        value: "find_local_gateway",
      ),
    ];
    if (Platform.isAndroid || Platform.isIOS) {
      popupMenuEntrys.addAll(<PopupMenuEntry<String>>[
        const PopupMenuDivider(
          height: 0.2,
        ),
        PopupMenuItem(
          //child: _buildPopupMenuItem(Icons.camera_alt, '扫一扫'),
          child: _buildPopupMenuItem(TDIcons.scan, OpenIoTHubLocalizations.of(context).scan_QR),
          value: "scan_QR",
        ),
        const PopupMenuDivider(
          height: 0.2,
        ),
        PopupMenuItem(
          //child: _buildPopupMenuItem(ICons.ADDRESS_BOOK_CHECKED, '添加朋友'),
          child: _buildPopupMenuItem(
              TDIcons.wifi, OpenIoTHubLocalizations.of(context).config_device_wifi),
          value: "config_device_wifi",
        ),
      ]);
    }
    return <Widget>[
      PopupMenuButton(
        tooltip: "",
        itemBuilder: (BuildContext context) {
          return popupMenuEntrys;
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
                      title: OpenIoTHubLocalizations.of(context).config_device_wifi,
                      needCallBack: true,
                      key: UniqueKey(),
                    );
                  },
                ),
              );
              break;
            case 'scan_QR':
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                      title: const Text("摄像头扫码提示！"),
                      scrollable: true,
                      content: SizedBox(
                          height: 120, // 设置Dialog的高度
                          child: ListView(
                            children: const <Widget>[
                              Text("请注意，点击下方 确定 我们将请求摄像头权限进行扫码", style: TextStyle(color: Colors.red),),
                            ],
                          )),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("取消", style: TextStyle(color: Colors.grey)),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text("确定", style: TextStyle(color: Colors.black),),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ScanQRPage();
                                },
                              ),
                            );
                          },
                        ),
                      ]));
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
          }
        },
      ),
    ];
  }
}
