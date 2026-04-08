import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub/utils/common/toast.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/pages/common/web/web.dart';
import 'package:openiothub/plugins/open_with_choice/open_with_choice.dart';
import 'package:openiothub/core/theme/app_spacing.dart';
import 'package:openiothub/core/theme/constants.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

import 'package:openiothub/ads/openiothub_ads.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

// 网关下面的mdns服务
class MDNSServiceListPage extends StatefulWidget {
  const MDNSServiceListPage({required Key key, required this.sessionConfig})
    : super(key: key);

  final SessionConfig sessionConfig;

  @override
  State<MDNSServiceListPage> createState() => MDNSServiceListPageState();
}

class MDNSServiceListPageState extends State<MDNSServiceListPage> {
  BannerAd? _bannerAd;
  List<PortConfig> _serviceList = [];

  @override
  void initState() {
    super.initState();
    _refreshTcpList();
    _loadAd();
  }

  Future<void> _refreshTcpList() async {
    try {
      final v = await SessionApi.getAllTCP(widget.sessionConfig);
      if (!mounted) return;
      setState(() {
        _serviceList = v.portConfigs;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('getAllTCP: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _serviceList.map((pair) {
      var listItemContent = ListTile(
        leading: TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.customText,
          text: pair.description.isNotEmpty ? pair.description[0] : "S",
          shape: TDAvatarShape.square,
          backgroundColor: Color.fromRGBO(
            Random().nextInt(156) + 50,
            Random().nextInt(156) + 50,
            Random().nextInt(156) + 50,
            1,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                pair.description,
                style: Constants.titleTextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        subtitle: Text(
          "${pair.device.addr}:${pair.remotePort}",
          style: Constants.subTitleTextStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Constants.rightArrowIcon,
      );
      return InkWell(
        onTap: () {
          showOpenWithChoiceDialog(
            context,
            portConfig: pair,
            onDialogClosed: _refreshTcpList,
          );
        },
        child: listItemContent,
      );
    });
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
          padding: EdgeInsets.only(left: AppSpacing.listDividerIndent),
          child: TDDivider(),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(OpenIoTHubLocalizations.of(context).mdns_service_list),
        actions: _buildActions(),
      ),
      body: openIoTHubDesktopConstrainedBody(
        child:
            openIoTHubUseDesktopHomeLayout
                ? Scrollbar(thumbVisibility: true, child: divided)
                : divided,
      ),
    );
  }

  void _pushDetail(SessionConfig config) async {
    //:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    var socksPort = await SessionApi.getOneSocks5PortByRunId(
      widget.sessionConfig.runId,
    );
    var httpPort = await SessionApi.getOneHttpProxyPortByRunId(
      widget.sessionConfig.runId,
    );
    if (!mounted) return;
    final List result = [];
    result.add(
      "ID(${OpenIoTHubLocalizations.of(context).after_simplification}):${config.runId.substring(24)}",
    );
    result.add("${OpenIoTHubLocalizations.of(context).name}:${config.name}");
    result.add(
      "${OpenIoTHubLocalizations.of(context).description}:${config.description}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).connection_code_simplified}:${config.token.substring(0, 10)}",
    );
    result.add("socks:$socksPort");
    result.add("http:$httpPort");
    result.add(
      "${OpenIoTHubLocalizations.of(context).forwarding_connection_status}:${config.statusToClient ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).p2p_connection_status}:${config.statusP2PAsClient || config.statusP2PAsServer ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}",
    );
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = result.map((pair) {
            return ListTile(
              title: Text(pair, style: Constants.titleTextStyle),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: pair));
                showSuccess(
                  OpenIoTHubLocalizations.of(context).copy_successful,
                  context,
                );
              },
            );
          });
          final divided =
              ListTile.divideTiles(context: context, tiles: tiles).toList();
          divided.add(
            TextButton(
              onPressed: () async {
                var gatewayJwtValue =
                    await GatewayManager.getGatewayJwtByGatewayUuid(
                      config.runId,
                    );
                if (!context.mounted) return;
                String gatewayJwt = gatewayJwtValue.value;
                Clipboard.setData(ClipboardData(text: gatewayJwt));
                showSuccess(
                  OpenIoTHubLocalizations.of(context).gateway_config_notes1,
                  context,
                );
              },
              child: Text(
                OpenIoTHubLocalizations.of(context).gateway_config_notes2,
              ),
            ),
          );
          divided.add(
            TextButton(
              onPressed: () async {
                String uuid = config.runId;
                var gatewayJwtValue =
                    await GatewayManager.getGatewayJwtByGatewayUuid(
                      config.runId,
                    );
                if (!context.mounted) return;
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
                showSuccess(
                  OpenIoTHubLocalizations.of(context).gateway_config_notes3,
                  context,
                );
              },
              child: Text(
                OpenIoTHubLocalizations.of(context).gateway_config_notes4,
              ),
            ),
          );
          final gwDetailList = ListView(children: divided);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                OpenIoTHubLocalizations.of(context).gateway_config_notes5,
              ),
            ),
            body: openIoTHubDesktopConstrainedBody(
              child:
                  openIoTHubUseDesktopHomeLayout
                      ? Scrollbar(thumbVisibility: true, child: gwDetailList)
                      : gwDetailList,
            ),
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
      showFailed(
        "${OpenIoTHubLocalizations.of(context).failed_to_delete_the_configuration_of_the_remote_gateway}:$e",
        context,
      );
    }
    try {
      SessionApi.deleteOneSession(config);
    } catch (e) {
      showFailed(
        "${OpenIoTHubLocalizations.of(context).failed_to_delete_mapping_for_local_gateway}:$e",
        context,
      );
    }
    showSuccess(
      OpenIoTHubLocalizations.of(context).successfully_deleted_gateway,
      context,
    );
    Navigator.of(context).pop();
  }

  Future refreshmDNSServices(SessionConfig sessionConfig) async {
    try {
      SessionApi.refreshmDNSServices(sessionConfig);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Caught error: $e');
      }
    }
  }

  _goToProxyBrowser() async {
    var port = await SessionApi.getOneHttpProxyPortByRunId(
      widget.sessionConfig.runId,
    );
    debugPrint("getOneHttpProxyPortByRunId:$port");
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          // return WebScreen(startUrl: "https://baidu.com");
          return WebScreen(
            startUrl: "http://127.0.0.1:34323",
            httpProxyPort: port,
            urlEditable: true,
            title: OpenIoTHubLocalizations.of(ctx).remote_lan_browser,
          );
        },
      ),
    );
  }

  _renameDialog() async {
    TextEditingController newNameController = TextEditingController.fromValue(
      TextEditingValue(text: widget.sessionConfig.name),
    );
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(OpenIoTHubLocalizations.of(context).modify_name),
            content: SizedBox.expand(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: newNameController,
                    decoration: InputDecoration(
                      contentPadding: AppSpacing.listTileDensePadding,
                      labelText:
                          OpenIoTHubLocalizations.of(
                            context,
                          ).please_input_new_name,
                      helperText: OpenIoTHubLocalizations.of(context).name,
                    ),
                  ),
                ],
              ),
            ),
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
                  gatewayInfo.description = widget.sessionConfig.description;
                  GatewayManager.updateGateway(gatewayInfo);
                  //修改本地的
                  widget.sessionConfig.name = newNameController.text;
                  // 从本机更新
                  SessionApi.updateSessionNameDescription(widget.sessionConfig);
                  // 从服务器更新
                  GatewayManager.updateGateway(gatewayInfo);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  List<Widget> _buildActions() {
    final l10n = OpenIoTHubLocalizations.of(context);
    List<Widget> actions = [];
    // 目前浏览器Proxy配置只支持安卓
    if (!context.isCnMainlandLocale && Platform.isAndroid) {
      // 不是中国大陆才显示按钮
      actions.add(
        IconButton(
          icon: const Icon(TDIcons.logo_chrome, color: Colors.green),
          tooltip: l10n.remote_lan_browser,
          onPressed: () {
            _goToProxyBrowser();
          },
        ),
      );
    } else if (Platform.isAndroid) {
      // 只要是安卓就显示按钮，TODO 在国内安卓上架时候删掉
      actions.add(
        IconButton(
          icon: const Icon(TDIcons.logo_chrome, color: Colors.green),
          tooltip: l10n.remote_lan_browser,
          onPressed: () {
            _goToProxyBrowser();
          },
        ),
      );
    }
    actions.addAll(<Widget>[
      // TODO 通过_device-info._tcp发现设备
      //重新命名
      IconButton(
        icon: const Icon(
          Icons.edit,
          // color: Colors.white,
        ),
        tooltip: l10n.gateway_tooltip_edit_name,
        onPressed: () {
          _renameDialog();
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.refresh,
          // color: Colors.white,
        ),
        tooltip: l10n.gateway_tooltip_refresh_mdns,
        onPressed: () {
          refreshmDNSServices(widget.sessionConfig).then((_) {
            _refreshTcpList();
          });
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        tooltip: l10n.delete_gateway,
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: Text(
                    OpenIoTHubLocalizations.of(context).delete_gateway,
                  ),
                  content: SizedBox.expand(
                    child: Text(
                      OpenIoTHubLocalizations.of(
                        context,
                      ).confirm_delete_gateway,
                    ),
                  ),
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
                        Navigator.of(context).pop();
                        deleteOneSession(widget.sessionConfig);
                        //                                  ：TODO 删除之后刷新列表
                      },
                    ),
                  ],
                ),
          );
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.info,
          // color: Colors.white,
        ),
        tooltip: l10n.gateway_tooltip_show_info,
        onPressed: () {
          _pushDetail(widget.sessionConfig);
        },
      ),
    ]);
    return actions;
  }

  _buildBanner() {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return Container();
    }
    return context.isCnMainlandLocale
        ? buildYLHBanner(context)
        : _bannerAd == null
        ? Container()
        : SafeArea(
          child: SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        );
  }

  void _loadAd() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    // // [START_EXCLUDE silent]
    // // Only load an ad if the Mobile Ads SDK has gathered consent aligned with
    // // the app's configured messages.
    // var canRequestAds = await _consentManager.canRequestAds();
    // if (!canRequestAds) {
    //   debugPrint("!canRequestAds");
    //   return;
    // }
    //
    // if (!mounted) {
    //   debugPrint("!mounted");
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
      debugPrint("size == null");
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
