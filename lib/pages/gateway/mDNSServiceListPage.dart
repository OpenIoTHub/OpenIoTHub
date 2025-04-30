import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/mDNSInfo.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

import 'package:openiothub/util/GetParameters.dart';

// 网关下面的mdns服务
class MDNSServiceListPage extends StatefulWidget {
  MDNSServiceListPage({required Key key, required this.sessionConfig})
      : super(key: key);

  SessionConfig sessionConfig;

  @override
  _MDNSServiceListPageState createState() => _MDNSServiceListPageState();
}

class _MDNSServiceListPageState extends State<MDNSServiceListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  List<PortConfig> _ServiceList = [];

  @override
  void initState() {
    super.initState();
    SessionApi.getAllTCP(widget.sessionConfig).then((v) {
      setState(() {
        _ServiceList = v.portConfigs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(Icons.devices,
              color: Colors.green),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                  "${pair.description.substring(0, pair.description.length > getTitleCharLens() ? getTitleCharLens() : pair.description.length)}${pair.description.length > getTitleCharLens() ? "..." : ""}",
                  style: Constants.titleTextStyle),
            ],
          ),
          subtitle: TDTag(
            "${pair.device.addr}:${pair.remotePort}",
            theme: TDTagTheme.success,
            // isOutline: true,
            isLight: true,
            fixedWidth: 10,
          ),
          trailing: Constants.rightArrowIcon,
        );
        return InkWell(
          onTap: () {
            if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
              _launchURL("http://${Config.webgRpcIp}:${pair.localProt}");
              return;
            }
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
              ..loadRequest(
                  Uri.parse("http://${Config.webgRpcIp}:${pair.localProt}"));
            //直接打开内置web浏览器浏览页面
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: AppBar(
                    title:
                        Text(OpenIoTHubLocalizations.of(context).web_browser),
                    actions: <Widget>[
                      IconButton(
                          icon: const Icon(
                            Icons.info,
                            // color: Colors.white,
                          ),
                          onPressed: () {
                            _info(pair);
                          }),
                      IconButton(
                          icon: const Icon(
                            Icons.open_in_browser,
                            // color: Colors.white,
                          ),
                          onPressed: () {
                            _launchURL(
                                "http://${Config.webgRpcIp}:${pair.localProt}");
                          })
                    ]),
                body: WebViewWidget(controller: controller),
              );
            }));
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
        title: Text(OpenIoTHubLocalizations.of(context).mdns_service_list),
        actions: <Widget>[
          // TODO 通过_device-info._tcp发现设备
          //重新命名
          IconButton(
              icon: const Icon(
                Icons.edit,
                // color: Colors.white,
              ),
              onPressed: () {
                _renameDialog();
              }),
          IconButton(
              icon: const Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {
                refreshmDNSServices(widget.sessionConfig).then((result) {
                  SessionApi.getAllTCP(widget.sessionConfig).then((v) {
                    setState(() {
                      _ServiceList = v.portConfigs;
                    });
                  });
                });
              }),
          IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                            title: Text(OpenIoTHubLocalizations.of(context)
                                .delete_gateway),
                            content: SizedBox.expand(
                                child: Text(OpenIoTHubLocalizations.of(context)
                                    .confirm_delete_gateway)),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                    OpenIoTHubLocalizations.of(context).cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                    OpenIoTHubLocalizations.of(context).delete),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteOneSession(widget.sessionConfig);
//                                  ：TODO 删除之后刷新列表
                                },
                              )
                            ]));
              }),
          IconButton(
              icon: const Icon(
                Icons.info,
                // color: Colors.white,
              ),
              onPressed: () {
                _pushDetail(widget.sessionConfig);
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  void _pushDetail(SessionConfig config) async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    final List result = [];
    result.add(
        "ID(${OpenIoTHubLocalizations.of(context).after_simplification}):${config.runId.substring(24)}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).description}:${config.description}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).connection_code_simplified}:${config.token.substring(0, 10)}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).forwarding_connection_status}:${config.statusToClient ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).p2p_connection_status}}:${config.statusP2PAsClient || config.statusP2PAsServer ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}");
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
          divided.add(TextButton(
              onPressed: () async {
                var gatewayJwtValue =
                    await GatewayManager.GetGatewayJwtByGatewayUuid(
                        config.runId);
                String gatewayJwt = gatewayJwtValue.value;
                Clipboard.setData(ClipboardData(text: gatewayJwt));
                showToast(
                    OpenIoTHubLocalizations.of(context).gateway_config_notes1);
              },
              child: Text(
                  OpenIoTHubLocalizations.of(context).gateway_config_notes2)));
          divided.add(TextButton(
              onPressed: () async {
                String uuid = config.runId;
                var gatewayJwtValue =
                    await GatewayManager.GetGatewayJwtByGatewayUuid(
                        config.runId);
                String gatewayJwt = gatewayJwtValue.value;
                String data = '''
gatewayuuid: ${getOneUUID()}
logconfig:
  enablestdout: true
  logfilepath: ""
loginwithtokenmap:
  $uuid: $gatewayJwt
''';
                Clipboard.setData(ClipboardData(text: data));
                showToast(
                    OpenIoTHubLocalizations.of(context).gateway_config_notes3);
              },
              child: Text(
                  OpenIoTHubLocalizations.of(context).gateway_config_notes4)));
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  OpenIoTHubLocalizations.of(context).gateway_config_notes5),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Future deleteOneSession(SessionConfig config) async {
    //先通知远程的网关删除配置再删除本地的代理（拦截同时删除服务器配置）
    try {
      SessionApi.deleteRemoteGatewayConfig(config);
    } catch (e) {
      showToast(
          "${OpenIoTHubLocalizations.of(context).failed_to_delete_the_configuration_of_the_remote_gateway}:$e");
    }
    try {
      SessionApi.deleteOneSession(config);
    } catch (e) {
      showToast(
          "${OpenIoTHubLocalizations.of(context).failed_to_delete_mapping_for_local_gateway}:$e");
    }
    showToast(OpenIoTHubLocalizations.of(context).successfully_deleted_gateway);
    Navigator.of(context).pop();
  }

  Future refreshmDNSServices(SessionConfig sessionConfig) async {
    try {
      SessionApi.refreshmDNSServices(sessionConfig);
    } catch (e) {
      if (kDebugMode) {
        print('Caught error: $e');
      }
    }
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }

  _info(PortConfig portConfig) async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MDNSInfoPage(
            portConfig: portConfig,
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  _renameDialog() async {
    TextEditingController newNameController = TextEditingController.fromValue(
        TextEditingValue(text: widget.sessionConfig.name));
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).modify_name),
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: newNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubLocalizations.of(context)
                            .please_input_new_name,
                        helperText: OpenIoTHubLocalizations.of(context).name,
                      ),
                    )
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
                    child: Text(OpenIoTHubLocalizations.of(context).modify),
                    onPressed: () async {
                      //修改服务器上的
                      GatewayInfo gatewayInfo = GatewayInfo();
                      gatewayInfo.gatewayUuid = widget.sessionConfig.runId;
                      gatewayInfo.name = newNameController.text;
                      gatewayInfo.description =
                          widget.sessionConfig.description;
                      GatewayManager.UpdateGateway(gatewayInfo);
                      //修改本地的
                      widget.sessionConfig.name = newNameController.text;
                      // 从本机更新
                      SessionApi.UpdateSessionNameDescription(
                          widget.sessionConfig);
                      // 从服务器更新
                      GatewayManager.UpdateGateway(gatewayInfo);
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }
}
