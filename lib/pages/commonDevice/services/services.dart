import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtads/gtads.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/widgets/toast.dart';
import 'package:openiothub_ads/openiothub_ads.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_plugin/plugins/openWithChoice/OpenWithChoice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../configs/var.dart';
import '../../../init.dart';
import 'createService.dart';

class ServicesListPage extends StatefulWidget {
  ServicesListPage({required Key key, required this.device}) : super(key: key);

  final Device device;

  @override
  _ServicesListPageState createState() => _ServicesListPageState();
}

class _ServicesListPageState extends State<ServicesListPage> {
  BannerAd? _bannerAd;
  List<PortConfig> _ServiceList = [];

  @override
  void initState() {
    super.initState();
    // needShowSplash = false;
    refreshPortConfigList();
    _loadAd();
  }

  @override
  void dispose() {
    // needShowSplash = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map((pair) {
      var listItemContent = ListTile(
        leading: TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.customText,
          text: (pair.name.isEmpty ? pair.description : pair.name)[0],
          shape: TDAvatarShape.square,
          backgroundColor:
              pair.remotePortStatus ? Colors.green : Colors.deepOrange,
        ),
        title: Text(pair.name.isEmpty ? pair.description : pair.name),
        subtitle: Text(
          "${pair.networkProtocol} ${pair.remotePort}:${pair.localProt}",
          style: Constants.subTitleTextStyle,
        ),
        trailing: TDButton(
          // text: 'More',
          icon: Icons.more_horiz,
          size: TDButtonSize.small,
          type: TDButtonType.outline,
          shape: TDButtonShape.rectangle,
          theme: TDButtonTheme.light,
          onTap: () {
            _pushPortConfigDetail(pair);
          },
        ),
        contentPadding: const EdgeInsets.fromLTRB(16, 0.0, 16, 0.0),
        onTap: () {
          //选择打开方式
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: Text(
                    OpenIoTHubLocalizations.of(context).opening_method,
                  ),
                  content: SizedBox.expand(child: OpenWithChoice(pair)),
                  actions: <Widget>[
                    TextButton(
                      child: Text(OpenIoTHubLocalizations.of(context).cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
          );
        },
      );
      return InkWell(child: listItemContent);
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
          padding: EdgeInsets.only(left: 70), // 添加左侧缩进
          child: TDDivider(),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(OpenIoTHubLocalizations.of(context).service),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              //TODO 删除小米网关设备
              _deleteCurrentDevice();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.power_settings_new,
              // color: Colors.white,
            ),
            onPressed: () {
              //网络唤醒
              _wakeOnLAN();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              // color: Colors.white,
            ),
            onPressed: () {
              // 添加TCP、UDP、Http端口
              _addOnePortConfig(widget.device).then((v) {
                refreshPortConfigList();
              });
            },
          ),
          //            TODO 设备的详情
          IconButton(
            icon: const Icon(
              Icons.info,
              // color: Colors.white,
            ),
            onPressed: () {
              //网络唤醒
              _pushDetail();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshPortConfigList();
          return;
        },
        child: divided,
      ),
    );
  }

  Future _deleteCurrentDevice() async {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(OpenIoTHubLocalizations.of(context).delete_device),
            content: SizedBox.expand(
              child: Text(
                OpenIoTHubLocalizations.of(context).confirm_delete_device,
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
                  CommonDeviceApi.deleteOneDevice(widget.device).then((result) {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
    ).then((v) {
      Navigator.of(context).pop();
    });
  }

  Future _wakeOnLAN() async {
    if (widget.device.mac == '') {
      return _setMacAddr();
    }
    return showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(OpenIoTHubLocalizations.of(context).wake_up_device),
            content: SizedBox.expand(
              child: Text(
                OpenIoTHubLocalizations.of(context).wake_up_device_notes1,
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
                child: Text(
                  OpenIoTHubLocalizations.of(context).reset_physical_address,
                ),
                onPressed: () {
                  _setMacAddr().then((_) {
                    Navigator.of(context).pop();
                  });
                },
              ),
              TextButton(
                child: Text(OpenIoTHubLocalizations.of(context).wake_up_device),
                onPressed: () {
                  CommonDeviceApi.wakeOnLAN(widget.device).then((_) {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
    );
  }

  Future _setMacAddr() async {
    TextEditingController macController = TextEditingController.fromValue(
      const TextEditingValue(text: "54-07-2F-BB-BB-2F"),
    );
    return showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              OpenIoTHubLocalizations.of(context).set_physical_address,
            ),
            content: SizedBox.expand(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: macController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText:
                          OpenIoTHubLocalizations.of(context).physical_address,
                      helperText:
                          OpenIoTHubLocalizations.of(
                            context,
                          ).the_physical_address_of_the_machine,
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
                child: Text(OpenIoTHubLocalizations.of(context).set),
                onPressed: () {
                  var device = widget.device;
                  device.mac = macController.text;
                  CommonDeviceApi.setDeviceMac(device).then((_) {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
    );
  }

  void _pushDetail() async {
    //:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    final List result = [];
    result.add(
      "${OpenIoTHubLocalizations.of(context).device_id}:${widget.device.uuid.substring(24)}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).gateway_id}:${widget.device.runId.substring(24)}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).name}:${widget.device.name}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).description}:${widget.device.description}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).addr}:${widget.device.addr}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).physical_address}:${widget.device.mac}",
    );
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = result.map((pair) {
            return ListTile(
              title: Text(pair),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: pair));
                show_success(
                  OpenIoTHubLocalizations.of(context).copy_successful,
                  context,
                );
              },
            );
          });
          final divided =
              ListTile.divideTiles(context: context, tiles: tiles).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text(OpenIoTHubLocalizations.of(context).device_details),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pushPortConfigDetail(PortConfig config) async {
    final List result = [];
    result.add("UUID:${config.uuid}");
    result.add(
      "${OpenIoTHubLocalizations.of(context).remote_port}:${config.remotePort}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).local_port}:${config.localProt}",
    );
    result.add("${OpenIoTHubLocalizations.of(context).name}:${config.name}");
    result.add(
      "${OpenIoTHubLocalizations.of(context).description}:${config.description}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).domain}:${config.domain}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).network_protocol}:${config.networkProtocol}",
    );
    result.add(
      "${OpenIoTHubLocalizations.of(context).application_protocol}:${config.applicationProtocol}",
    );
    // TODO
    result.add(
      "${OpenIoTHubLocalizations.of(context).forwarding_connection_status}:${config.remotePortStatus ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}",
    );
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = result.map((pair) {
            return ListTile(title: Text(pair, style: Constants.titleTextStyle));
          });
          final divided =
              ListTile.divideTiles(context: context, tiles: tiles).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text(OpenIoTHubLocalizations.of(context).port_details),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    //删除
                    _deleteOnePortConfig(config);
                  },
                ),
              ],
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Future refreshPortConfigList() async {
    try {
      _ServiceList.clear();
      CommonDeviceApi.getAllTCP(widget.device).then((v) {
        setState(() {
          _ServiceList = v.portConfigs;
        });
      });
      CommonDeviceApi.getAllUDP(widget.device).then((v) {
        setState(() {
          _ServiceList.addAll(v.portConfigs);
        });
      });
      CommonDeviceApi.getAllFTP(widget.device).then((v) {
        setState(() {
          _ServiceList.addAll(v.portConfigs);
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Caught error: $e');
      }
    }
  }

  Future _addOnePortConfig(device) async {
    // 只有超过指定添加次数才会显示激励广告
    // 添加端口到一定次数之后才会展示视频激励广告，防止影响新用户体验
    const JILI_AD= "JILI_AD";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 禁止开屏广告防止需要看两种广告
    // needShowSplash = false;
    if ((Platform.isAndroid||Platform.isIOS)&&
        // 目前只有大陆才展示激励广告
        isCnMainland(OpenIoTHubLocalizations.of(context).localeName)&&
        prefs.containsKey(JILI_AD)&&
        prefs.getInt(JILI_AD)!>5&&
        initList != null) {
      await GTAds.rewardAd(
        //需要的广告位数组
        codes: [
          GTAdsCode(
            alias: "csj",
            probability: 5,
            androidId: CsjAdConfig.getRewardedAdUnitId(),
            iosId: CsjAdConfig.getRewardedAdUnitId(),
          ),
          GTAdsCode(
            alias: "ylh",
            probability: 10,
            androidId: YlhAdConfig.getRewardedAdUnitId(),
            iosId: YlhAdConfig.getRewardedAdUnitId(),
          ),
        ],
        //奖励名称
        rewardName: "100金币",
        //奖励数量
        rewardAmount: 100,
        //用户id
        userId: "user100",
        //扩展参数
        customData: "123",
        //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
        timeout: 5,
        //广告加载模式 [GTAdsModel.RANDOM]优先级模式 [GTAdsModel.RANDOM]随机模式
        //默认随机模式
        model: GTAdsModel.PRIORITY,
        callBack: GTAdsCallBack(
          onShow: (code) {
            print("激励广告显示 ${code.toJson()}");
            needShowSplash = false;
          },
          onFail: (code, message) {
            print("激励广告失败 ${code!.toJson()} $message");
            needShowSplash = false;
            _showCreateServiceWidget(device);
          },
          onClick: (code) {
            print("激励广告点击 ${code.toJson()}");
            needShowSplash = false;
          },
          onClose: (code) {
            print("激励广告关闭 ${code.toJson()}");
            needShowSplash = false;
            _showCreateServiceWidget(device);
          },
          onVerify: (code, verify, transId, rewardName, rewardAmount) {
            print(
              "激励广告关闭 ${code
                  .toJson()} $verify $transId $rewardName $rewardAmount",
            );
            // _showCreateServiceWidget(device);
            return;
          },
          onExpand: (code, param) {
            print("激励广告自定义参数 ${code.toJson()} $param");
          },
          onTimeout: () {
            print("激励广告加载超时");
            needShowSplash = false;
            _showCreateServiceWidget(device);
          },
          onEnd: () {
            print("激励广告所有广告位都加载失败");
            needShowSplash = false;
            _showCreateServiceWidget(device);
          },
        ),
      );
    }else{
      _showCreateServiceWidget(device);
    }
    // await _showCreateServiceWidget(device);
    // 恢复开屏广告显示
    // needShowSplash = true;
    if (prefs.containsKey(JILI_AD)) {
      int old = prefs.getInt(JILI_AD)!;
      prefs.setInt(JILI_AD, old+1);
    }else{
      prefs.setInt(JILI_AD, 1);
    }
  }

  Future _showCreateServiceWidget(Device device) async {
    await showDialog(
      context: context,
      builder: (con) => CreateServiceWidget(device: device),
    );
  }

  Future _deleteOnePortConfig(PortConfig config) async {
    showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).delete_tcp),
                content: SizedBox.expand(
                  child: Text(
                    OpenIoTHubLocalizations.of(
                      context,
                    ).confirm_to_delete_this_tcp,
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
                      CommonDeviceApi.deleteOneTCP(config).then((result) {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              ),
        )
        .then((v) {
          Navigator.of(context).pop();
        })
        .then((v) {
          refreshPortConfigList();
        });
  }


  _buildBanner() {
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

class ListItem {
  String icon;
  String title;

  ListItem({required this.icon, required this.title});
}
