import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/core/config.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/common_pages/utils/toast.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:openiothub/plugin/models/port_service_info.dart';
import '../sub/app_store.dart';
import 'files.dart';
import '../sub/settings.dart';
import '../sub/system_info.dart';

class InstalledAppsPage extends StatefulWidget {
  const InstalledAppsPage(
      {super.key, required this.portService, required this.data});

  final PortServiceInfo portService;
  final Map<String, dynamic> data;

  @override
  State<InstalledAppsPage> createState() => _InstalledAppsPageState();
}

class _InstalledAppsPageState extends State<InstalledAppsPage> {
  late final List<ListTile> _listTiles = <ListTile>[];
  String? currentVersion;
  bool? needUpdate;
  String? changeLog;
  late Timer _refreshTimer;
  late String baseUrl;

  @override
  void initState() {
    baseUrl = "http://${widget.portService.addr}:${widget.portService.port}";
    _initListTiles();
    _getVersionInfo();
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _initListTiles();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_refreshTimer.isActive) {
      _refreshTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(OpenIoTHubLocalizations.of(context).nas_apps),
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
                  _launchUrl(baseUrl);
                }),
            // 版本信息
            IconButton(
                icon: Icon(
                  Icons.info,
                  // color: Colors.white,
                ),
                onPressed: () {
                  final l10n = OpenIoTHubLocalizations.of(context);
                  final needStr = needUpdate == null
                      ? '-'
                      : (needUpdate! ? l10n.yes : l10n.no);
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (BuildContext buildContext,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return TDAlertDialog(
                        title: l10n.nas_version_info_title,
                        content:
                            '${l10n.nas_version_current_version}: ${currentVersion ?? '-'}\n'
                            '${l10n.nas_version_need_update}: $needStr\n'
                            '${l10n.nas_version_changelog}: ${changeLog ?? '-'}',
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
      currentVersion = response.data["data"]["currentVersion"];
      needUpdate = response.data["data"]["needUpdate"];
      changeLog = response.data["data"]["version"]["changeLog"];
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
      // debugPrint("remoteHost: ${widget.portConfig.device.addr},remotePort: ${appInfo["port"]}");
      if (appInfo["port"] ==null || appInfo["port"].isEmpty) {
        // debugPrint("appInfo[\"port\"].isEmpty");
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
        for (var portConfig in portListRet.portConfigs) {
          if (portConfig.remotePort == remotePort) {
            localPort = portConfig.localProt;
          }
        }
      } catch (e) {
        debugPrint("appInfo[\"port\"]:${appInfo["port"]}");
        debugPrint('$e');
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
              imageUrl: appInfo["icon"] ??
                  "https://cdn.jsdelivr.net/gh/IceWhaleTech/CasaOS-AppStore@main/Apps/Gateway-go/icon.png",
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

  _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  _upgradeApp(String appName) async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"]
    }));
    String reqUri = "/v2/app_management/compose/$appName";
    final response = await dio.patchUri(Uri.parse(reqUri));
    if (!mounted) return;
    if (response.statusCode == 200) {
      showSuccess(
        OpenIoTHubLocalizations.of(context).nas_app_upgrade_success,
        context,
      );
    } else {
      showFailed(
        OpenIoTHubLocalizations.of(context).nas_app_upgrade_failed,
        context,
      );
    }
  }

  _removeApp(String appName, bool? deleteConfigFolder) async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"]
    }));
    String reqUri =
        "/v2/app_management/compose/$appName?deleteConfigFolder=${deleteConfigFolder ?? false}";
    final response = await dio.deleteUri(Uri.parse(reqUri));
    if (!mounted) return;
    if (response.statusCode == 200) {
      showSuccess(
        OpenIoTHubLocalizations.of(context).nas_app_remove_success,
        context,
      );
    } else {
      showFailed(
        OpenIoTHubLocalizations.of(context).nas_app_remove_failed,
        context,
      );
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
    if (!mounted) return;
    if (response.statusCode == 200) {
      showSuccess(
        '${OpenIoTHubLocalizations.of(context).nas_app_change_status_success} ($status)',
        context,
      );
    } else {
      showFailed(
        '${OpenIoTHubLocalizations.of(context).nas_app_change_status_failed} ($status)',
        context,
      );
    }
  }

  _openWithWebBrowser(String ip, int port) async {
    if (!Platform.isAndroid) {
      // TODO
      _launchUrl("http://$ip:$port");
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
              title: Text(OpenIoTHubLocalizations.of(ctx).web_browser),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.open_in_browser,
                      color: Colors.teal,
                    ),
                    onPressed: () {
                      _launchUrl("http://$ip:$port");
                    })
              ]),
          body: WebViewWidget(controller: controller),
        );
      }));
    }
  }
}
