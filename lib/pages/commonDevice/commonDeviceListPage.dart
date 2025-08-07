import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/commonDevice/services/services.dart';
import 'package:openiothub/pages/commonDevice/widgets/AddHost.dart';
// import 'package:openiothub/pages/commonDevice/services/old/commonDeviceServiceTypesList.dart';
import 'package:openiothub/util/ThemeUtils.dart';
import 'package:openiothub/widgets/BuildGlobalActions.dart';
import 'package:openiothub/widgets/toast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub_ads/openiothub_ads.dart';

class CommonDeviceListPage extends StatefulWidget {
  const CommonDeviceListPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  _CommonDeviceListPageState createState() => _CommonDeviceListPageState();
}

class _CommonDeviceListPageState extends State<CommonDeviceListPage> {
  BannerAd? _bannerAd;
  List<SessionConfig> _SessionList = [];
  List<Device> _CommonDeviceList = [];
  late Timer _timerPeriod;

  @override
  void initState() {
    super.initState();
    getAllSession().then((_) {
      getAllCommonDevice();
    });
    _timerPeriod = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      getAllCommonDevice();
    });
    _loadAd();
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
        // 获取所在网络的名称
        String gatewayName = pair.runId.substring(24);
        for (var sessionConfig in _SessionList) {
          if (sessionConfig.runId == pair.runId) {
            gatewayName = sessionConfig.name;
          }
        }
        var listItemContent = ListTile(
          leading: TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: pair.name.isEmpty ? pair.description[0] : pair.name[0],
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
              Text(pair.name.isEmpty ? pair.description : pair.name,
                  style: Constants.titleTextStyle),
            ],
          ),
          subtitle: Text(
            // TODO 显示所在网络的名称
            "${pair.addr}@${gatewayName!.substring(0, gatewayName!.length > 20 ? 20 : gatewayName!.length)}",
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
      itemCount: tiles.length+1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildBanner();
        }
        return tiles.elementAt(index-1);
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

  void _pushDeviceServiceTypes(Device device) async {
    // 查看设备下的服务 CommonDeviceServiceTypesList
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return ServicesListPage(
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
      show_failed("getAllSession：$e", context);
    }
  }

  Future createOneCommonDevice(Device device) async {
    try {
      await CommonDeviceApi.createOneDevice(device);
    } catch (e) {
      show_failed(
          "${OpenIoTHubLocalizations.of(context).create_device_failed}：$e",
          context);
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
    // 在一个界面里面选择网络
      showDialog(
          context: context,
          builder: (_) => AddHostWidget()).then((v) {
        getAllCommonDevice().then((v) {
          setState(() {});
        });
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
