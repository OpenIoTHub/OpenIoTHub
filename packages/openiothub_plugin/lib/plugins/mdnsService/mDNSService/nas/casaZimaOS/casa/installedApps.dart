import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_plugin/l10n/generated/openiothub_plugin_localizations.dart';
import 'package:openiothub_plugin/utils/toast.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../../models/PortServiceInfo.dart';
import '../sub/appStore.dart';
import 'files.dart';
import '../sub/settings.dart';
import '../sub/systemInfo.dart';

class InstalledAppsPage extends StatefulWidget {
  const InstalledAppsPage(
      {super.key, required this.portService, required this.data});

  final PortServiceInfo portService;
  final Map<String, dynamic> data;

  @override
  State<InstalledAppsPage> createState() => _InstalledAppsPageState();
}

class _InstalledAppsPageState extends State<InstalledAppsPage> {
  late List<ListTile> _listTiles = <ListTile>[];
  late List<ListTile> _versionListTiles = <ListTile>[];
  String? current_version;
  bool? need_update;
  String? change_log;
  late Timer _refresh_timer;
  late String baseUrl;

  @override
  void initState() {
    baseUrl = "http://${widget.portService.addr}:${widget.portService.port}";
    _initListTiles();
    _getVersionInfo();
    _refresh_timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _initListTiles();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_refresh_timer.isActive) {
      _refresh_timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Apps"),
          actions: <Widget>[
            // 系统的各种状态
            IconButton(
                icon: Icon(
                  TDIcons.chart,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SystemInfoPage(
                        key: UniqueKey(), data: widget.data, baseUrl: baseUrl);
                  }));
                }),
            // 系统设置
            IconButton(
                icon: Icon(
                  TDIcons.setting,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SettingsPage(
                        key: UniqueKey(), data: widget.data, baseUrl: baseUrl);
                  }));
                }),
            // 应用市场
            IconButton(
                icon: Icon(
                  TDIcons.app,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return AppStorePage(
                        key: UniqueKey(), data: widget.data, baseUrl: baseUrl);
                  }));
                }),
            // 文件管理
            IconButton(
                icon: Icon(
                  Icons.file_copy_outlined,
                  // color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return FileManagerPage(
                        key: UniqueKey(), data: widget.data, baseUrl: baseUrl);
                  }));
                }),
            // 终端
            // IconButton(
            //     icon: Icon(
            //       Icons.terminal,
            //       // color: Colors.white,
            //     ),
            //     onPressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            //         return TerminalPage(
            //           key: UniqueKey(),
            //         );
            //       }));
            //     }),
            // 当前用户信息
            // IconButton(
            //     icon: Icon(
            //       Icons.account_circle,
            //       // color: Colors.white,
            //     ),
            //     onPressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            //         return UserInfoPage(
            //           key: UniqueKey(),
            //             data: widget.data,
            //             portService: widget.portService
            //         );
            //       }));
            //     }),
            // IconButton(
            //     icon: Icon(
            //       Icons.refresh,
            //       // color: Colors.white,
            //     ),
            //     onPressed: () {
            //       _initListTiles();
            //     })
            IconButton(
                icon: Icon(
                  Icons.open_in_browser,
                  color: Colors.teal,
                ),
                onPressed: () {
                  _launchURL(baseUrl);
                }),
            // 版本信息
            IconButton(
                icon: Icon(
                  Icons.info,
                  // color: Colors.white,
                ),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (BuildContext buildContext,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return TDAlertDialog(
                        title: "Version Info",
                        content:
                            "current_version:${current_version}\nneed_update:${need_update}\nchange_log:${change_log}",
                      );
                    },
                  );
                }),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await _initListTiles();
              return;
            },
            child: ListView.separated(
              itemBuilder: (context, index) {
                return _buildListTile(index);
              },
              separatorBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(left: 50), // 添加左侧缩进
                  child: TDDivider(),
                );
              },
              itemCount: _listTiles.length,
            )));
  }

  ListTile _buildListTile(int index) {
    return _listTiles[index];
  }

  Future<void> _getVersionInfo() async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"]
    }));
    String reqUri = "/v1/sys/version";
    final response = await dio.getUri(Uri.parse(reqUri));
    setState(() {
      current_version = response.data["data"]["current_version"];
      need_update = response.data["data"]["need_update"];
      change_log = response.data["data"]["version"]["change_log"];
    });
  }

  Future<void> _initListTiles() async {
    // 排序
    _listTiles.clear();
    //从API获取已安装应用列表
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"]
    }));
    String reqUri = "/v2/app_management/web/appgrid";
    final response = await dio.getUri(Uri.parse(reqUri));
    response.data["data"]
        .sort((a, b) => a["name"].toString().compareTo(b["name"].toString()));
    // TODO 使用远程网络ID和远程端口临时映射远程端口到本机
    PortList portList = PortList();
    response.data["data"].forEach((appInfo) {
      // print("remoteHost: ${widget.portConfig.device.addr},remotePort: ${appInfo["port"]}");
      if (appInfo["port"] ==null || appInfo["port"].isEmpty) {
        // print("appInfo[\"port\"].isEmpty");
        return;
      }
      var device = Device.create();
      device.runId = widget.portService.runId!;
      device.addr = widget.portService.realAddr!;
      var portConfig = PortConfig(
        // TODO 在组建mdns的时候如果是远程映射则在info中添加remoteAddr真实地址
        device: device,
        name: appInfo["name"],
        description: appInfo["name"],
        localProt: 0,
        remotePort: int.parse(appInfo["port"]),
        networkProtocol: "tcp",
        // mDNSInfo: PortService(),
      );
      portList.portConfigs.add(portConfig);
    });
    // TODO 如果本身在局域网则不创建
    SessionApi.createTcpProxyList(portList);
    // TODO 获取当前服务映射到本机的端口号
    PortList portListRet = await SessionApi.getAllTCP(SessionConfig(
      runId: widget.portService.runId!,
    ));
    response.data["data"].forEach((appInfo) {
      int localPort = 0;
      int remotePort = 0;
      try {
        remotePort = int.parse(appInfo["port"]);
        // 从remotePort和runid获取映射之后的localPort
        portListRet.portConfigs.forEach((portConfig) {
          if (portConfig.remotePort == remotePort) {
            localPort = portConfig.localProt;
          }
        });
      } catch (e) {
        print("appInfo[\"port\"]:${appInfo["port"]}");
        print(e);
      }

      setState(() {
        _listTiles.add(ListTile(
          //第一个功能项
          title: Text(appInfo["name"]),
          // subtitle: Text(appInfo["status"], style: TextStyle(),),
          subtitle: TDTag(
            appInfo["status"],
            theme: appInfo["status"] == "running"
                ? TDTagTheme.success
                : TDTagTheme.danger,
            // isOutline: true,
            isLight: true,
          ),
          leading: _sizedContainer(
            CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
              imageUrl: appInfo["icon"]!=null?appInfo["icon"]:"https://cdn.jsdelivr.net/gh/IceWhaleTech/CasaOS-AppStore@main/Apps/Gateway-go/icon.png",
            ),
          ),
          trailing: TDButton(
            // text: 'More',
            icon: Icons.more_horiz,
            size: TDButtonSize.small,
            type: TDButtonType.outline,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.light,
            onTap: () {
              TDActionSheet(context,
                  visible: true,
                  description: appInfo["name"],
                  items: [
                    TDActionSheetItem(
                      label: 'Start',
                      icon: Icon(
                        Icons.start,
                        color: Colors.green,
                      ),
                    ),
                    TDActionSheetItem(
                      label: 'Upgrade',
                      icon: Icon(
                        Icons.upgrade,
                        color: Colors.red,
                      ),
                    ),
                    TDActionSheetItem(
                      label: 'Delete',
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ),
                    TDActionSheetItem(
                      label: 'Stop',
                      icon: Icon(
                        Icons.settings_power,
                        color: Colors.red,
                      ),
                    ),
                    TDActionSheetItem(
                      label: 'Restart',
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.orange,
                      ),
                    ),
                  ], onSelected: (TDActionSheetItem item, int index) {
                switch (index) {
                  case 0:
                    // 确认操作
                    _changeAppStatus(appInfo["name"], "start");
                    break;
                  case 1:
                    _upgradeApp(appInfo["name"]);
                    break;
                  case 2:
                    _removeApp(appInfo["name"], false);
                    break;
                  case 3:
                    _changeAppStatus(appInfo["name"], "stop");
                    break;
                  case 4:
                    _changeAppStatus(appInfo["name"], "restart");
                    break;
                }
              });
            },
          ),
          onTap: () {
            if (localPort == 0) {
              return;
            }
            _openWithWebBrowser(Config.webgRpcIp, localPort);
          },
        ));
      });
    });
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Center(child: child),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      print('Could not launch $url');
    }
  }

  _upgradeApp(String appName) async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"]
    }));
    String reqUri = "/v2/app_management/compose/$appName";
    final response = await dio.patchUri(Uri.parse(reqUri));
    if (response.statusCode == 200) {
      show_success("Upgrade App Success", context);
    } else {
      show_failed("Upgrade App Failed", context);
    }
  }

  _removeApp(String appName, bool? delete_config_folder) async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"]
    }));
    String reqUri =
        "/v2/app_management/compose/$appName?delete_config_folder=${delete_config_folder == null ? false : delete_config_folder}";
    final response = await dio.deleteUri(Uri.parse(reqUri));
    if (response.statusCode == 200) {
      show_success("Remove App Success", context);
    } else {
      show_failed("Remove App Failed", context);
    }
  }

  _changeAppStatus(String appName, status) async {
    // status: restart,stop
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"],
      "Content-Type": "application/json"
    }));
    String reqUri = "/v2/app_management/compose/$appName/status";
    final response = await dio.putUri(Uri.parse(reqUri), data: "\"$status\"");
    if (response.statusCode == 200) {
      show_success("Change App Status To ${status} Success", context);
    } else {
      show_failed("Change App Status To ${status} Failed", context);
    }
  }

  _openWithWebBrowser(String ip, int port) async {
    if (!Platform.isAndroid) {
      // TODO
      _launchURL("http://$ip:$port");
    } else {
      WebViewController controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse("http://$ip:$port"));
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
              title: Text(OpenIoTHubPluginLocalizations.of(ctx).web_browser),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.open_in_browser,
                      color: Colors.teal,
                    ),
                    onPressed: () {
                      _launchURL("http://$ip:$port");
                    })
              ]),
          body: WebViewWidget(controller: controller),
        );
      }));
    }
  }
}
