import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_plugin/l10n/generated/openiothub_plugin_localizations.dart';
import 'package:openiothub_plugin/models/PortServiceInfo.dart';
import 'package:openiothub_plugin/utils/toast.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstalledAppsPage extends StatefulWidget {
  const InstalledAppsPage(
      {super.key, required this.portService, required this.cookie});

  final PortServiceInfo portService;
  final String cookie;

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
  late String csrf_token;

  @override
  void initState() {
    baseUrl = "http://${widget.portService.addr}:${widget.portService.port}";
    _get_csrf_token().then((_) => _initListTiles());
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
          actions: <Widget>[],
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

  Future<void> _get_csrf_token() async {
    //   var csrf_token = "E5FDD8E7277F5CC6";
    final dio =
    Dio(BaseOptions(baseUrl: baseUrl, headers: {"Cookie": widget.cookie}));
    String reqUri = "/Main";
    final response = await dio.getUri(Uri.parse(reqUri));
    RegExp regExp = RegExp(r'var csrf_token = "(.*?)";'); // 使用非贪婪匹配来获取双引号内的内容
    Match? match = regExp.firstMatch(response.data);
    if (match != null) {
      csrf_token = match.group(1)!; // group(1) 是捕获组的内容
      // print(csrf_token); // 输出: E5FDD8E7277F5CC6
      // show_success("csrf_token:${csrf_token}", context);
    }
  }

  Future<void> _initListTiles() async {
    // 排序
    _listTiles.clear();
    //从API获取已安装应用列表
    final dio =
    Dio(BaseOptions(baseUrl: baseUrl, headers: {"Cookie": widget.cookie}));
    String reqUri =
        "/plugins/dynamix.docker.manager/include/DockerContainers.php";
    final response = await dio.getUri(Uri.parse(reqUri));
    var docker_container_list = _get_docker_container_list(response.data);

    // TODO 使用远程网络ID和远程端口临时映射远程端口到本机
    PortList portList = PortList();
    // {"name":name,"id":id,"addr":addr,"port":port}
    print(docker_container_list.length);
    docker_container_list.forEach((appInfo) {
      // print("remoteHost: ${widget.portConfig.device.addr},remotePort: ${appInfo["port"]}");
      if (appInfo["port"] == 0) {
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
        remotePort: appInfo["port"],
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
    docker_container_list.forEach((appInfo) {
      int localPort = 0;
      int remotePort = 0;
      try {
        remotePort = appInfo["port"];
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
            theme: appInfo["status"] == "started"
                ? TDTagTheme.success
                : TDTagTheme.danger,
            // isOutline: true,
            isLight: true,
          ),
          leading: Icon(Icons.ac_unit),
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
                      label: 'Pause',
                      icon: Icon(
                        Icons.pause,
                        color: Colors.red,
                      ),
                    ),
                    TDActionSheetItem(
                      label: 'Resume',
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.orange,
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
                    TDActionSheetItem(
                      label: 'Delete',
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ], onSelected: (TDActionSheetItem item, int index) {
                    switch (index) {
                      case 0:
                      // 确认操作
                        _changeAppStatus(appInfo["id"], "start");
                        break;
                      case 1:
                        _changeAppStatus(appInfo["id"], "pause");
                        break;
                      case 2:
                        _changeAppStatus(appInfo["id"], "resume");
                        break;
                      case 3:
                        _changeAppStatus(appInfo["id"], "stop");
                        break;
                      case 4:
                        _changeAppStatus(appInfo["id"], "restart");
                        break;
                      case 5:
                        _removeApp(appInfo["id"], appInfo["name"]);
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

  _removeApp(String container_id, appName) async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Cookie": widget.cookie,
      "Content-Type":
      "application/x-www-form-urlencoded; charset=UTF-8application/x-www-form-urlencoded; charset=UTF-8"
    }));
    String reqUri = "/plugins/dynamix.docker.manager/include/Events.php";
    // TODO
    // action=remove_container&container=0fb9fdd30fef&name=ddns-go&csrf_token=E5FDD8E7277F5CC6
    final response = await dio.postUri(Uri.parse(reqUri),
        data: FormData.fromMap({
          "action": "remove_container",
          "container": container_id,
          "name": appName,
          "csrf_token": csrf_token
        }));
    if (response.statusCode == 200) {
      show_success("Remove App Success", context);
    } else {
      show_failed("Remove App Failed", context);
    }
    _initListTiles();
  }

  _changeAppStatus(String container_id, status) async {
    // status: restart,stop,(pause,resume)
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "cookie": widget.cookie,
      "Content-Type":
      "application/x-www-form-urlencoded; charset=UTF-8application/x-www-form-urlencoded; charset=UTF-8"
    }));
    String reqUri = "/plugins/dynamix.docker.manager/include/Events.php";
    //Form Data action=stop&container=0fb9fdd30fef&csrf_token=E5FDD8E7277F5CC6
    final response = await dio.postUri(Uri.parse(reqUri),
        data: FormData.fromMap({
          "action": status,
          "container": container_id,
          "csrf_token": csrf_token
        }));
    if (response.statusCode == 200) {
      show_success("Change App Status To ${status} Success", context);
    } else {
      show_failed("Change App Status To ${status} Failed", context);
    }
    _initListTiles();
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

  List<Map<String, dynamic>> _get_docker_container_list(String htmlDocument) {
    List<Map<String, dynamic>> docker_container_list = [];
    // docker.push({name:'ddns-go',id:'566b2ac821d8',state:1,pause:0,update:0});
    RegExp regExp2 = RegExp(r'docker.push((.*?));');
    var matchs = regExp2.allMatches(htmlDocument);
    var num_apps = matchs.length;
    // 通过正则匹配应用名称，应用的端口，只有Host网络模式才有192.168.124.4:34323/TCP；192.168.124.4:5353/UDP
    // 分割字符串到列表
    List<String> lines = htmlDocument.split('\n');
    // 移除最后一行
    if (lines.length > 1) {
      lines.removeLast();
      lines.removeLast();
    }
    // 重新组合字符串
    htmlDocument = lines.join('\n');
    // var htmlDocument2 = '<html>'+htmlDocument+'<\/html>';
    dom.Document document = parser.parse(htmlDocument);
    //计算列表应用数量
    // var num = document.getElementsByClassName("hand").length;
    for (int i = 0; i < num_apps; i++) {
      var addrPortText =
      document.getElementsByClassName("docker_readmore")[i * 2].text.trim();
      RegExp regExp = RegExp(r'\d+.\d+.\d+.\d+:\d+/TCP'); // 使用非贪婪匹配来获取双引号内的内容
      Match? match = regExp.firstMatch(addrPortText);
      String addr = "";
      int port = 0;
      if (match != null) {
        var target = match.group(0)!; // group(1) 是捕获组的内容
        var addr_port = target.split(RegExp("/")).first;
        addr = addr_port.split(RegExp(":")).first;
        port = int.parse(addr_port.split(RegExp(":")).last);
        print("addr port: ${addr}:${port}");
      }
      // started, stopped, paused
      var status = document.getElementsByClassName("state")[i].text;
      var id = document.getElementsByClassName("hand")[i].id;
      var name = document.getElementsByClassName("exec")[i * 2].text;
      docker_container_list.add({
        "name": name,
        "id": id,
        "addr": addr,
        "port": port,
        "status": status
      });
    }
    return docker_container_list;
  }
}

// /plugins/dynamix.docker.manager/include/DockerContainers.php
// <tr class='sortable'>
//     <td class='ct-name' style='width:220px;padding:8px'>
//         <i class='fa fa-arrows-v mover orange-text'></i>
//         <span class='outer'>
//             <span id='d837c0f8bd2a' onclick="addDockerContainerContext('ddns-go','0c9d07d74768','/boot/config/plugins/dockerMan/templates-user/my-ddns-go.xml',1,0,0,true,'','sh','d837c0f8bd2a','','','', '','')" class='hand'>
//                 <img src='/plugins/dynamix.docker.manager/images/question.png?1724345809' class='img' onerror=this.src='/plugins/dynamix.docker.manager/images/question.png' ;>
//             </span>
//             <span class='inner'>
//                 <span class='appname '>
//                     <a class='exec' onclick="editContainer('ddns-go','/boot/config/plugins/dockerMan/templates-user/my-ddns-go.xml')">ddns-go</a>
//                 </span>
//                 <br>
//                 <i id='load-d837c0f8bd2a' class='fa fa-play started green-text'></i>
//                 <span class='state'>started</span>
//             </span>
//         </span>
//         <div class='advanced' style='margin-top:8px'>
//             Container ID: d837c0f8bd2a<br>By: jeessy/ddns-go
//         </div>
//     </td>
//     <td class='updatecolumn'>
//         <span class='green-text' style='white-space:nowrap;'>
//             <i class='fa fa-check fa-fw'></i>
//             up-to-date
//         </span>
//         <div class='advanced'>
//             <a class='exec' onclick="updateContainer('ddns-go');">
//                 <span style='white-space:nowrap;'>
//                     <i class='fa fa-cloud-download fa-fw'></i>
//                     force update
//                 </span>
//             </a>
//         </div>
//         <div class='advanced'>
//             <i class='fa fa-info-circle fa-fw'></i>
//             latest
//         </div>
//     </td>
//     <td>host</td>
//     <td style='white-space:nowrap'>
//         <span class='docker_readmore'>
//             192.168.124.4:9876/TCP<i class="fa fa-arrows-h" style="margin:0 6px"></i>
//             192.168.124.4:9876
//         </span>
//     </td>
//     <td style='word-break:break-all'>
//         <span class='docker_readmore'></span>
//     </td>
//     <td class='advanced'>
//         <span class='cpu-d837c0f8bd2a'>0%</span>
//         <div class='usage-disk mm'>
//             <span id='cpu-d837c0f8bd2a' style='width:0'></span>
//             <span></span>
//         </div>
//         <br>
//         <span class='mem-d837c0f8bd2a'>0 / 0</span>
//     </td>
//     <td>
//         <input type='checkbox' id='d837c0f8bd2a-auto' class='autostart' container='ddns-go' checked>
//         <span id='d837c0f8bd2a-wait' style='float:right;display:none'>
//             wait<input class='wait' container='ddns-go' type='number' value='' placeholder='0' title="seconds">
//         </span>
//     </td>
//     <td>
//         <div style='white-space:nowrap'>
//             Uptime: 2 minutes<div style='margin-top:4px'>Created: 3 minutes ago</div>
//         </div>
//     </td>
// </tr>
// <tr class='sortable'>
//     <td class='ct-name' style='width:220px;padding:8px'>
//         <i class='fa fa-arrows-v mover orange-text'></i>
//         <span class='outer'>
//             <span id='14d211f3b5c7' onclick="addDockerContainerContext('gateway-go','c552a1e0cc36','/boot/config/plugins/dockerMan/templates-user/my-gateway-go.xml',1,0,0,true,'','sh','14d211f3b5c7','','','', '','')" class='hand'>
//                 <img src='/plugins/dynamix.docker.manager/images/question.png?1724345809' class='img' onerror=this.src='/plugins/dynamix.docker.manager/images/question.png' ;>
//             </span>
//             <span class='inner'>
//                 <span class='appname '>
//                     <a class='exec' onclick="editContainer('gateway-go','/boot/config/plugins/dockerMan/templates-user/my-gateway-go.xml')">gateway-go</a>
//                 </span>
//                 <br>
//                 <i id='load-14d211f3b5c7' class='fa fa-play started green-text'></i>
//                 <span class='state'>started</span>
//             </span>
//         </span>
//         <div class='advanced' style='margin-top:8px'>
//             Container ID: 14d211f3b5c7<br>By: openiothub/gateway-go
//         </div>
//     </td>
//     <td class='updatecolumn'>
//         <span class='green-text' style='white-space:nowrap;'>
//             <i class='fa fa-check fa-fw'></i>
//             up-to-date
//         </span>
//         <div class='advanced'>
//             <a class='exec' onclick="updateContainer('gateway-go');">
//                 <span style='white-space:nowrap;'>
//                     <i class='fa fa-cloud-download fa-fw'></i>
//                     force update
//                 </span>
//             </a>
//         </div>
//         <div class='advanced'>
//             <i class='fa fa-info-circle fa-fw'></i>
//             latest
//         </div>
//     </td>
//     <td>host</td>
//     <td style='white-space:nowrap'>
//         <span class='docker_readmore'>
//             192.168.124.4:34323/TCP<i class="fa fa-arrows-h" style="margin:0 6px"></i>
//             192.168.124.4:34323<br>
//             192.168.124.4:5353/UDP<i class="fa fa-arrows-h" style="margin:0 6px"></i>
//             192.168.124.4:5353
//         </span>
//     </td>
//     <td style='word-break:break-all'>
//         <span class='docker_readmore'>
//             /root<i class="fa fa-arrows-h" style="margin:0 6px"></i>
//             /mnt/user/appdata/
//         </span>
//     </td>
//     <td class='advanced'>
//         <span class='cpu-14d211f3b5c7'>0%</span>
//         <div class='usage-disk mm'>
//             <span id='cpu-14d211f3b5c7' style='width:0'></span>
//             <span></span>
//         </div>
//         <br>
//         <span class='mem-14d211f3b5c7'>0 / 0</span>
//     </td>
//     <td>
//         <input type='checkbox' id='14d211f3b5c7-auto' class='autostart' container='gateway-go' checked>
//         <span id='14d211f3b5c7-wait' style='float:right;display:none'>
//             wait<input class='wait' container='gateway-go' type='number' value='' placeholder='0' title="seconds">
//         </span>
//     </td>
//     <td>
//         <div style='white-space:nowrap'>
//             Uptime: 13 hours<div style='margin-top:4px'>Created: 12 hours ago</div>
//         </div>
//     </td>
// </tr>
//  docker.push({name:'ddns-go',id:'d837c0f8bd2a',state:1,pause:0,update:0});docker.push({name:'gateway-go',id:'14d211f3b5c7',state:1,pause:0,update:0}); 0
