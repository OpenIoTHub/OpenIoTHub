import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/widgets/build_global_actions.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/mqttDeviceManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub/plugin/models/port_service_info.dart';
import 'package:openiothub/plugin/mdns_service/mdns_type2_model_map.dart';
import 'package:openiothub/plugin/registry/plugin_navigation.dart';
import 'package:openiothub/plugin/utils/port_config_to_port_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// import '../../widgets/ads/banner_gtads.dart';
import 'package:openiothub/core/cname_refresh_signal.dart';
import 'package:openiothub/core/globals.dart';
import 'package:openiothub/router/app_navigator.dart';
import 'package:openiothub/ads/openiothub_ads.dart';
import 'package:openiothub/common_pages/utils/toast.dart';

class MdnsServiceListPage extends StatefulWidget {
  const MdnsServiceListPage({required Key key, required this.title})
    : super(key: key);

  final String title;

  @override
  State<MdnsServiceListPage> createState() => MdnsServiceListPageState();
}

class MdnsServiceListPageState extends State<MdnsServiceListPage> {
  BannerAd? _bannerAd;
  bool _showAD = false;
  Utf8Decoder u8decodeer = const Utf8Decoder();
  final Map<String, PortServiceInfo> _iotDeviceMap =
      <String, PortServiceInfo>{};
  late Timer _timerPeriodRemote;
  final Map<String, BonsoirDiscovery> _bonsoirActions = {};
  bool initialStart = true;
  final List<String> _supportedTypeList =
      Mdns2ModelsMap.getAllMdnsServiceType();

  @override
  void initState() {
    super.initState();
    CnameRefreshSignal.instance.addListener(_onCnameSynced);
    getIoTDeviceFromLocal();
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      setState(() {
        _showAD = true;
      });
      refreshmDNSServicesFromeRemote();
    });
    _timerPeriodRemote = Timer.periodic(const Duration(seconds: 5), (
      Timer timer,
    ) {
      refreshmDNSServicesFromeRemote();
    });
    _loadAd();
    debugPrint('init iot device list');
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _iotDeviceMap.values.map((PortServiceInfo pair) {
      var listItemContent = ListTile(
        leading: TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.customText,
          text: pair.info!["name"]![0],
          shape: TDAvatarShape.square,
          backgroundColor: Color.fromRGBO(
            Random().nextInt(156) + 50, // 随机生成0到255之间的整数
            Random().nextInt(156) + 50, // 随机生成0到255之间的整数
            Random().nextInt(156) + 50, // 随机生成0到255之间的整数
            1, // 不透明度，1表示完全不透明
          ),
        ),
        title: Text(pair.info!["name"]!, style: Constants.titleTextStyle),
        subtitle: Text(
          "${pair.info!["model"]!}@${pair.isLocal ? "local" : "remote"}",
          style: Constants.subTitleTextStyle,
        ),
        trailing: Constants.rightArrowIcon,
        contentPadding: const EdgeInsets.fromLTRB(16, 0.0, 16, 0.0),
      );
      return InkWell(
        onTap: () {
          _pushDeviceServiceTypes(pair);
        },
        child: listItemContent,
      );
    });
    final divided = ListView.separated(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      itemCount: _showAD ? tiles.length + 1 : tiles.length,
      itemBuilder: (context, index) {
        if (_showAD && index == 0) {
          return _buildBanner();
        }
        return tiles.elementAt(_showAD ? index - 1 : index);
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
        title: Text(widget.title),
        // backgroundColor: Provider.of<CustomTheme>(context).isLightTheme()
        //     ? CustomThemes.light.primaryColor
        //     : CustomThemes.dark.primaryColor,
        centerTitle: true,
        actions: buildActions(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshmDNSServicesFromeRemote();
          return;
        },
        child:
            tiles.isNotEmpty
                ? divided
                : Column(
                  children: [
                    ThemeUtils.isDarkMode(context)
                        ? Center(
                          child: Image.asset(
                            'assets/images/empty_list_black.png',
                          ),
                        )
                        : Center(
                          child: Image.asset('assets/images/empty_list.png'),
                        ),
                    TextButton(
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(
                          const BorderSide(color: Colors.grey, width: 1),
                        ),
                        shape: WidgetStateProperty.all(const StadiumBorder()),
                      ),
                      onPressed: () {
                        AppNavigator.pushAirkiss(
                          context,
                          title: OpenIoTHubLocalizations.of(context).add_device,
                        );
                      },
                      child: Text(
                        OpenIoTHubLocalizations.of(
                          context,
                        ).please_add_device_first,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  void _onCnameSynced() {
    unawaited(_reapplyLocalCnamesFromPrefs());
  }

  /// 启动后 [CnameManager.loadAllCnameFromRemote] 完成时同步列表中的展示名（仅读本地 prefs）。
  Future<void> _reapplyLocalCnamesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    var changed = false;
    for (final e in _iotDeviceMap.entries) {
      final id = e.key;
      if (!prefs.containsKey(id)) continue;
      final v = prefs.getString(id);
      if (v == null || v.isEmpty) continue;
      final info = e.value.info;
      if (info == null || !info.containsKey('name')) continue;
      if (info['name'] != v) {
        info['name'] = v;
        changed = true;
      }
    }
    if (changed && mounted) setState(() {});
  }

  @override
  void dispose() {
    CnameRefreshSignal.instance.removeListener(_onCnameSynced);
    _timerPeriodRemote.cancel();
    _iotDeviceMap.clear();
    stopAllDiscovery();
    super.dispose();
  }

  //显示是设备的UI展示或者操作界面
  void _pushDeviceServiceTypes(PortServiceInfo device) async {
    needShowSplash = false;
    await context.openPortServicePluginPage(
      device,
      onReturn: refreshmDNSServicesFromeRemote,
    );
    needShowSplash = true;
  }

  //获取所有的网络列表
  Future<List<SessionConfig>> getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      debugPrint('getAllSession received: ${response.sessionConfigs}');
      return response.sessionConfigs;
    } catch (e) {
      List<SessionConfig> list = [];
      debugPrint('getAllSession error: $e');
      return list;
    }
  }

  //获取所有的设备列表（本地网络和远程网络）

  // 刷新设备列表（远程会话 + MQTT）
  Future refreshmDNSServicesFromeRemote() async {
    if (await userSignedIn()) {
      getIoTDeviceFromMqttServer();
      try {
        getAllSession()
            .then((s) {
              for (var sc in s) {
                SessionApi.refreshmDNSServices(sc);
              }
            })
            .then((_) async {
              getIoTDeviceFromRemote();
            });
      } catch (e) {
        debugPrint('refreshmDNSServicesFromeRemote error: $e');
      }
    }
  }

  void onEventOccurred(BonsoirDiscoveryEvent event) {
    if (event.service == null) {
      return;
    }

    BonsoirService service = event.service!;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      // services.add(service);
      if (_bonsoirActions.containsKey(service.type)) {
        service.resolve(_bonsoirActions[service.type]!.serviceResolver);
      } else {
        debugPrint('_bonsoirActions 无 ${service.type} 处理');
      }
    } else if (event.type ==
        BonsoirDiscoveryEventType.discoveryServiceResolved) {
      // services.removeWhere((foundService) => foundService.name == service.name);
      // services.add(service);
      if (Mdns2ModelsMap.modelsMap.containsKey(service.type)) {
        PortServiceInfo portServiceInfo =
            Mdns2ModelsMap.modelsMap[service.type]!.copyWith();
        portServiceInfo.info!.addAll(service.attributes);
        portServiceInfo.addr = (service as ResolvedBonsoirService).host!
            .replaceAll(RegExp(r'.local.local.'), ".local")
            .replaceAll(RegExp(r'.local.'), ".local");
        portServiceInfo.port = service.port;
        portServiceInfo.isLocal = true;
        if (portServiceInfo.info!.containsKey("id") &&
            portServiceInfo.info!["id"] != "") {
          // 有id
        } else if (portServiceInfo.info!.containsKey("mac") &&
            portServiceInfo.info!["mac"] != "") {
          portServiceInfo.info!["id"] = portServiceInfo.info!["mac"]!;
        } else {
          portServiceInfo.info!["id"] =
              "${portServiceInfo.addr}:${portServiceInfo.port}@local";
        }
        addPortServiceInfo(portServiceInfo);
      } else {
        PortServiceInfo portServiceInfo = PortServiceInfo("", 80, true);
        portServiceInfo.addr = (service as ResolvedBonsoirService).host!
            .replaceAll(RegExp(r'.local.local.'), ".local")
            .replaceAll(RegExp(r'.local.'), ".local");
        portServiceInfo.port = service.port;
        portServiceInfo.isLocal = true;
        portServiceInfo.info = {};
        service.attributes.forEach((String key, value) {
          portServiceInfo.info![key] = value;
        });
        debugPrint('_portServiceInfo: $portServiceInfo');
        addPortServiceInfo(portServiceInfo);
      }
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      // services.removeWhere((foundService) => foundService.name == service.name);
    }
  }

  //添加设备
  Future<void> addPortServiceInfo(PortServiceInfo portServiceInfo) async {
    final ctx = context;
    if (portServiceInfo.info == null ||
        !portServiceInfo.info!.containsKey("name") ||
        portServiceInfo.info!["name"] == null ||
        portServiceInfo.info!["name"] == "") {
      return;
    }
    debugPrint('addPortServiceInfo: ${portServiceInfo.info!}');
    if (!portServiceInfo.info!.containsKey("id")) {
      return;
    }
    String? id = portServiceInfo.info!["id"];
    if (id == null || id.isEmpty) {
      return;
    }
    String value = "";
    try {
      if (await userSignedIn()) {
        value = await CnameManager.getCname(id);
      }
    } catch (e) {
      if (ctx.mounted) showFailed(e.toString(), ctx);
    }
    if (value != "") {
      portServiceInfo.info!["name"] = value;
    }
    if (!_iotDeviceMap.containsKey(id) ||
        (_iotDeviceMap.containsKey(id) &&
            !_iotDeviceMap[id]!.isLocal &&
            portServiceInfo.isLocal)) {
      if (!mounted) return;
      setState(() {
        _iotDeviceMap[id] = portServiceInfo;
      });
    }
  }

  Future getIoTDeviceFromLocal() async {
    // if  (_scanning) {
    //   return;
    // }
    //优先iotdevice
    for (int i = 0; i < _supportedTypeList.length; i++) {
      String type = _supportedTypeList[i];
      BonsoirDiscovery action = BonsoirDiscovery(type: type);
      await action.ready;
      _bonsoirActions[type] = action;
      action.eventStream?.listen(onEventOccurred);
      await action.start();
      debugPrint('===start $type');
      Future.delayed(const Duration(milliseconds: 500));
    }
    // _scanning = true;
  }

  Future<void> stopAllDiscovery() async {
    for (BonsoirActionHandler action in _bonsoirActions.values) {
      action.stop();
    }
    _bonsoirActions.clear();
  }

  Future<void> stopDiscovery(String type) async {
    await _bonsoirActions[type]?.stop();
    _bonsoirActions.remove(type);
  }

  Future getIoTDeviceFromMqttServer() async {
    MqttDeviceInfoList mqttDeviceInfoList =
        await MqttDeviceManager.getAllMqttDevice();
    for (var mqttDeviceInfo in mqttDeviceInfoList.mqttDeviceInfoList) {
      PortServiceInfo portServiceInfo = PortServiceInfo("", 80, false);
      //  TODO
      portServiceInfo.addr = mqttDeviceInfo.mqttInfo.mqttServerHost;
      portServiceInfo.port = mqttDeviceInfo.mqttInfo.mqttServerPort;
      portServiceInfo.isLocal = false;
      if (portServiceInfo.info != null) {
        portServiceInfo.info!["name"] =
            mqttDeviceInfo.deviceDefaultName != ""
                ? mqttDeviceInfo.deviceDefaultName
                : mqttDeviceInfo.deviceModel;
        portServiceInfo.info!["id"] = mqttDeviceInfo.deviceId;
        portServiceInfo.info!["mac"] = mqttDeviceInfo.deviceId;
        portServiceInfo.info!["model"] = mqttDeviceInfo.deviceModel;
        portServiceInfo.info!["username"] =
            mqttDeviceInfo.mqttInfo.mqttClientUserName;
        portServiceInfo.info!["password"] =
            mqttDeviceInfo.mqttInfo.mqttClientUserPassword;
        portServiceInfo.info!["client-id"] =
            mqttDeviceInfo.mqttInfo.mqttClientId;
        portServiceInfo.info!["tls"] =
            mqttDeviceInfo.mqttInfo.sSLorTLS.toString();
        portServiceInfo.info!["enable_delete"] = true.toString();
      }
      addPortServiceInfo(portServiceInfo);
    }
  }

  Future getIoTDeviceFromRemote() async {
    // TODO 从搜索到的mqtt组件中获取设备
    try {
      // 从远程获取设备
      getAllSession().then((List<SessionConfig> sessionConfigList) async {
        for (var sessionConfig in sessionConfigList) {
          var t = await SessionApi.getAllTCP(sessionConfig);
          for (var portConfig in t.portConfigs) {
            PortServiceInfo? portServiceInfo;
            if (Mdns2ModelsMap.modelsMap.containsKey(
              portConfig.mDNSInfo.info["service"],
            )) {
              portServiceInfo =
                  Mdns2ModelsMap.modelsMap[portConfig.mDNSInfo.info["service"]]!
                      .copyWith();
              portServiceInfo.info!.addAll(portConfig.mDNSInfo.info);
              portServiceInfo.addr = "127.0.0.1";
              portServiceInfo.port = portConfig.localProt;
              portServiceInfo.isLocal = false;
              if (portServiceInfo.info!.containsKey("id") &&
                  portServiceInfo.info!["id"] != "") {
                // 有id
              } else if (portConfig.uuid.isNotEmpty) {
                portServiceInfo.info!["id"] = portConfig.uuid;
              } else {
                portServiceInfo.info!["id"] =
                    "${portConfig.device.addr}:${portConfig.remotePort}@${sessionConfig.runId}";
              }
              if (portConfig.mDNSInfo.info.containsKey("name") &&
                  portConfig.mDNSInfo.info["name"]!.isNotEmpty) {
                portServiceInfo.info!["name"] =
                    portConfig.mDNSInfo.info["name"]!.toString();
              }
              // 添加远程主机的真实地址，用于类似于casaos登录后的再次动态创建映射
              portServiceInfo.runId = sessionConfig.runId;
              portServiceInfo.realAddr = portConfig.device.addr;
              await addPortServiceInfo(portServiceInfo);
            } else {
              await addPortServiceInfo(
                portService2PortServiceInfo(portConfig.mDNSInfo),
              );
            }
          }
        }
      });
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(
                OpenIoTHubLocalizations.of(
                  context,
                ).failed_to_obtain_the_iot_list_remotely,
              ),
              content: SizedBox.expand(
                child: Text(
                  "${OpenIoTHubLocalizations.of(context).failure_reason}：$e",
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(OpenIoTHubLocalizations.of(context).confirm),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
      );
    }
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
      debugPrint('banner AdSize is null');
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

//            TODO 添加设备（类型：mqtt，小米，美的；设备型号：TC1-A1,TC1-A2）
//           IconButton(
//               icon: Icon(
//                 Icons.add_circle,
//                 color: Colors.white,
//               ),
//               onPressed: () {
// //                  TODO：手动添加MQTT设备
// //                   Scaffold.of(context).openDrawer();
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return AddMqttDevicesPage();
//                     },
//                   ),
//                 );
//               }),

//              print("mDNSInfo:$mDNSInfo");
//              {
//                "name": "esp-switch-80:7D:3A:72:64:6F",
//                "type": "_iotdevice._tcp",
//                "domain": "local",
//                "hostname": "esp-switch-80:7D:3A:72:64:6F.local.",
//                "port": 80,
//                "text": null,
//                "ttl": 4500,
//                "AddrIPv4": ["192.168.0.3"],
//                "AddrIPv6": null
//              }
