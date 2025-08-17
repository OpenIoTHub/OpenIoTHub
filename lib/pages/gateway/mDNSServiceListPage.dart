import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub/widgets/toast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/web/web.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/mDNSInfo.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

import 'package:openiothub/util/GetParameters.dart';

import 'package:openiothub_ads/openiothub_ads.dart';

// 网关下面的mdns服务
class MDNSServiceListPage extends StatefulWidget {
  MDNSServiceListPage({required Key key, required this.sessionConfig})
      : super(key: key);

  SessionConfig sessionConfig;

  @override
  _MDNSServiceListPageState createState() => _MDNSServiceListPageState();
}

class _MDNSServiceListPageState extends State<MDNSServiceListPage> {
  BannerAd? _bannerAd;
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
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(TDIcons.earth,
              color: Colors.green, size: 50,),
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
            var _url = "http://${Config.webgRpcIp}:${pair.localProt}";
            if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
              _launchURL(_url);
              return;
            }
            // TODO 更换内置Web浏览器WebScreen
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return WebScreen(startUrl: _url,);
            }));
          },
          child: listItemContent,
        );
      },
    );
    // TODO 增加横幅广告
    final divided = ListView.separated(
      // padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      itemCount: tiles.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildBanner();
        }
        return tiles.elementAt(index - 1);
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
        title: Text(OpenIoTHubLocalizations.of(context).mdns_service_list),
        actions: _buildActions(),
      ),
      body: divided,
    );
  }

  void _pushDetail(SessionConfig config) async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    var socksPort = await SessionApi.GetOneSOCKS5PortByRunId(widget.sessionConfig.runId);
    var httpPort = await SessionApi.GetOneHttpProxyPortByRunId(widget.sessionConfig.runId);
    final List result = [];
    result.add(
        "ID(${OpenIoTHubLocalizations.of(context).after_simplification}):${config.runId.substring(24)}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).name}:${config.name}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).description}:${config.description}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).connection_code_simplified}:${config.token.substring(0, 10)}");
    result.add(
        "socks:${socksPort}");
    result.add(
        "http:$httpPort");
    result.add(
        "${OpenIoTHubLocalizations.of(context).forwarding_connection_status}:${config.statusToClient ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}");
    result.add(
        "${OpenIoTHubLocalizations.of(context).p2p_connection_status}:${config.statusP2PAsClient || config.statusP2PAsServer ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}");
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
                  show_success(
                      OpenIoTHubLocalizations.of(context).copy_successful,context);
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
                show_success(
                    OpenIoTHubLocalizations.of(context).gateway_config_notes1, context);
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
                show_success(
                    OpenIoTHubLocalizations.of(context).gateway_config_notes3, context);
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
      show_failed(
          "${OpenIoTHubLocalizations.of(context).failed_to_delete_the_configuration_of_the_remote_gateway}:$e", context);
    }
    try {
      SessionApi.deleteOneSession(config);
    } catch (e) {
      show_failed(
          "${OpenIoTHubLocalizations.of(context).failed_to_delete_mapping_for_local_gateway}:$e",context);
    }
    show_success(OpenIoTHubLocalizations.of(context).successfully_deleted_gateway, context);
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

  _goToProxyBrowser() async {
    var port = await SessionApi.GetOneHttpProxyPortByRunId(widget.sessionConfig.runId);
    print("GetOneHttpProxyPortByRunId:$port");
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      // return WebScreen(startUrl: "https://baidu.com");
      return WebScreen(startUrl: "http://127.0.0.1:34323",httpProxyPort: port, urlEditable:true, title: "LAN Browser",);
    }));
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

  List<Widget> _buildActions(){
    List<Widget> actions =[];
    // 目前浏览器Proxy配置只支持安卓
    if (!isCnMainland(OpenIoTHubLocalizations.of(context).localeName)&&Platform.isAndroid){
      // 不是中国大陆才显示按钮
      actions.add(IconButton(
          icon: const Icon(
            TDIcons.logo_chrome,
            color: Colors.green,
          ),
          tooltip: "Remote LAN Browser",
          onPressed: () {
            _goToProxyBrowser();
          }));
    }else if (Platform.isAndroid){
      // 只要是安卓就显示按钮，TODO 在国内安卓上架时候删掉
      actions.add(IconButton(
          icon: const Icon(
            TDIcons.logo_chrome,
            color: Colors.green,
          ),
          tooltip: "Remote LAN Browser",
          onPressed: () {
            _goToProxyBrowser();
          }));
    }
    actions.addAll(<Widget>[
      // TODO 通过_device-info._tcp发现设备
      //重新命名
      IconButton(
          icon: const Icon(
            Icons.edit,
            // color: Colors.white,
          ),
          tooltip: "Edit gateway name",
          onPressed: () {
            _renameDialog();
          }),
      IconButton(
          icon: const Icon(
            Icons.refresh,
            // color: Colors.white,
          ),
          tooltip: "Refresh mdns service",
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
          tooltip: "Delete this gateway",
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
          tooltip: "Show gateway info",
          onPressed: () {
            _pushDetail(widget.sessionConfig);
          }),
    ]);
    return actions;
  }

  _buildBanner() {
    if (!Platform.isAndroid && !Platform.isIOS){
      return Container();
    }
    return isCnMainland(OpenIoTHubLocalizations.of(context).localeName)?
    buildYLHBanner(context):
    _bannerAd==null?Container():SafeArea(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }

  void _loadAd() async {
    if (!Platform.isAndroid && !Platform.isIOS){
      return;
    }
    // // [START_EXCLUDE silent]
    // // Only load an ad if the Mobile Ads SDK has gathered consent aligned with
    // // the app's configured messages.
    // var canRequestAds = await _consentManager.canRequestAds();
    // if (!canRequestAds) {
    //   print("!canRequestAds");
    //   return;
    // }
    //
    // if (!mounted) {
    //   print("!mounted");
    //   return;
    // }
    // [END_EXCLUDE]
    // [START get_ad_size]
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );
    // [END get_ad_size]

    if (size == null) {
      // Unable to get width of anchored banner.
      print("size == null");
      return;
    }

    BannerAd(
      adUnitId: GoogleAdConfig.getBannerAdUnitId(),
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Called when an ad is successfully received.
          debugPrint("Ad was loaded.");
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // Called when an ad request failed.
          debugPrint("Ad failed to load with error: $err");
          ad.dispose();
        },
        // [START_EXCLUDE silent]
        // [START ad_events]
        onAdOpened: (Ad ad) {
          // Called when an ad opens an overlay that covers the screen.
          debugPrint("Ad was opened.");
        },
        onAdClosed: (Ad ad) {
          // Called when an ad removes an overlay that covers the screen.
          debugPrint("Ad was closed.");
        },
        onAdImpression: (Ad ad) {
          // Called when an impression occurs on the ad.
          debugPrint("Ad recorded an impression.");
        },
        onAdClicked: (Ad ad) {
          // Called when an a click event occurs on the ad.
          debugPrint("Ad was clicked.");
        },
        onAdWillDismissScreen: (Ad ad) {
          // iOS only. Called before dismissing a full screen view.
          debugPrint("Ad will be dismissed.");
        },
        // [END ad_events]
        // [END_EXCLUDE]
      ),
    ).load();
  }
}
