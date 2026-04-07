import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtads/gtads.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/common_pages/utils/toast.dart';
import 'package:openiothub/ads/openiothub_ads.dart';
import 'package:openiothub/network/openiothub/common_device_api.dart';
import 'package:openiothub/core/app_spacing.dart';
import 'package:openiothub/core/constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub/plugin/open_with_choice/open_with_choice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub/core/globals.dart';
import 'package:openiothub/init.dart';
import 'create_service.dart';

class ServicesListPage extends StatefulWidget {
  const ServicesListPage({required Key key, required this.device})
      : super(key: key);

  final Device device;

  @override
  State<ServicesListPage> createState() => ServicesListPageState();
}

class ServicesListPageState extends State<ServicesListPage> {
  BannerAd? _bannerAd;
  List<PortConfig> _serviceList = [];

  @override
  void initState() {
    super.initState();
    refreshPortConfigList();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _serviceList.map((pair) {
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
          showOpenWithChoiceDialog(
            context,
            portConfig: pair,
            onDialogClosed: refreshPortConfigList,
          );
        },
      );
      return InkWell(child: listItemContent);
    });
    final divided = ListView.separated(
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
    final l10n = OpenIoTHubLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ports),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: l10n.tooltip_delete_current_host,
            onPressed: () {
              _deleteCurrentDevice();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.power_settings_new,
            ),
            tooltip: l10n.tooltip_wake_on_lan,
            onPressed: () {
              _wakeOnLAN();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle,
            ),
            tooltip: l10n.tooltip_add_tcp_udp_port,
            onPressed: () {
              _addOnePortConfig(widget.device).then((v) {
                refreshPortConfigList();
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.info,
            ),
            tooltip: l10n.tooltip_current_host_info,
            onPressed: () {
              _pushDetail();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshPortConfigList();
        },
        child: divided,
      ),
    );
  }

  Future<void> _deleteCurrentDevice() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text(OpenIoTHubLocalizations.of(context).delete),
            onPressed: () {
              CommonDeviceApi.deleteOneDevice(widget.device).then((_) {
                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();
                if (!mounted) return;
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _wakeOnLAN() async {
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
                    if (mounted) Navigator.of(context).pop();
                  });
                },
              ),
              TextButton(
                child: Text(OpenIoTHubLocalizations.of(context).wake_up_device),
                onPressed: () {
                  CommonDeviceApi.wakeOnLAN(widget.device).then((_) {
                    if (mounted) Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
    );
  }

  Future<void> _setMacAddr() async {
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
                      contentPadding: AppSpacing.listTileDensePadding,
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
                    if (mounted) Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
    );
  }

  Future<void> _pushDetail() async {
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
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = result.map((pair) {
            return ListTile(
              title: Text(pair),
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

  Future<void> _pushPortConfigDetail(PortConfig config) async {
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
    result.add(
      "${OpenIoTHubLocalizations.of(context).forwarding_connection_status}:${config.remotePortStatus ? OpenIoTHubLocalizations.of(context).online : OpenIoTHubLocalizations.of(context).offline}",
    );
    if (!mounted) return;
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

  Future<void> refreshPortConfigList() async {
    try {
      final results = await Future.wait([
        CommonDeviceApi.getAllTCP(widget.device),
        CommonDeviceApi.getAllUDP(widget.device),
        CommonDeviceApi.getAllFTP(widget.device),
      ]);
      if (!mounted) return;
      setState(() {
        _serviceList = [
          ...results[0].portConfigs,
          ...results[1].portConfigs,
          ...results[2].portConfigs,
        ];
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ServicesListPage refreshPortConfigList: $e');
      }
    }
  }

  Future<void> _addOnePortConfig(Device device) async {
    const jiliAd = "JILI_AD";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    if ((Platform.isAndroid || Platform.isIOS) &&
        context.isCnMainlandLocale &&
        prefs.containsKey(jiliAd) &&
        prefs.getInt(jiliAd)! > 5 &&
        initList != null) {
      await GTAds.rewardAd(
        codes: [
          GTAdsCode(
            alias: "ylh",
            probability: 100,
            androidId: YlhAdConfig.getRewardedAdUnitId(),
            iosId: YlhAdConfig.getRewardedAdUnitId(),
          ),
          GTAdsCode(
            alias: "csj",
            probability: 1,
            androidId: CsjAdConfig.getRewardedAdUnitId(),
            iosId: CsjAdConfig.getRewardedAdUnitId(),
          ),
        ],
        rewardName: "100金币",
        rewardAmount: 100,
        userId: "user100",
        customData: "123",
        timeout: 5,
        model: GTAdsModel.PRIORITY,
        callBack: GTAdsCallBack(
          onShow: (code) {
            debugPrint("激励广告显示 ${code.toJson()}");
            needShowSplash = false;
          },
          onFail: (code, message) {
            debugPrint("激励广告失败 ${code!.toJson()} $message");
            needShowSplash = false;
            _showCreateServiceWidget(device);
          },
          onClick: (code) {
            debugPrint("激励广告点击 ${code.toJson()}");
            needShowSplash = false;
          },
          onClose: (code) {
            debugPrint("激励广告关闭 ${code.toJson()}");
            needShowSplash = false;
            _showCreateServiceWidget(device);
          },
          onVerify: (code, verify, transId, rewardName, rewardAmount) {
            debugPrint(
              "激励广告关闭 ${code.toJson()} $verify $transId $rewardName $rewardAmount",
            );
            return;
          },
          onExpand: (code, param) {
            debugPrint("激励广告自定义参数 ${code.toJson()} $param");
          },
          onTimeout: () {
            debugPrint("激励广告加载超时");
            needShowSplash = false;
            _showCreateServiceWidget(device);
          },
          onEnd: () {
            debugPrint("激励广告所有广告位都加载失败");
            needShowSplash = false;
            _showCreateServiceWidget(device);
          },
        ),
      );
    } else {
      _showCreateServiceWidget(device);
    }
    if (prefs.containsKey(jiliAd)) {
      int old = prefs.getInt(jiliAd)!;
      prefs.setInt(jiliAd, old + 1);
    } else {
      prefs.setInt(jiliAd, 1);
    }
  }

  Future<void> _showCreateServiceWidget(Device device) async {
    await showDialog(
      context: context,
      builder: (con) => CreateServiceWidget(device: device),
    );
  }

  Future<void> _deleteOnePortConfig(PortConfig config) async {
    final l = OpenIoTHubLocalizations.of(context);
    final app = config.applicationProtocol.toLowerCase();
    final net = config.networkProtocol.toLowerCase();
    final String deleteTitle;
    final String deleteConfirm;
    if (app == 'ftp') {
      deleteTitle = l.delete_ftp;
      deleteConfirm = l.confirm_to_delete_this_ftp;
    } else if (net == 'udp') {
      deleteTitle = l.delete_udp;
      deleteConfirm = l.confirm_to_delete_this_udp;
    } else {
      deleteTitle = l.delete_tcp;
      deleteConfirm = l.confirm_to_delete_this_tcp;
    }
    final deleted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(deleteTitle),
        content: SizedBox.expand(
          child: Text(deleteConfirm),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(l.cancel),
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
          ),
          TextButton(
            child: Text(l.delete),
            onPressed: () {
              CommonDeviceApi.deleteOnePortForConfig(config).then((_) {
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop(true);
                }
              }).catchError((Object e, StackTrace st) {
                developer.log(
                  'ServicesListPage: delete port failed uuid=${config.uuid}',
                  name: 'ServicesListPage',
                  error: e,
                  stackTrace: st,
                );
                if (!mounted) return;
                showFailed(e.toString(), context);
              });
            },
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (deleted == true) {
      Navigator.of(context).pop();
      refreshPortConfigList();
    }
  }

  Widget _buildBanner() {
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

  Future<void> _loadAd() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (!mounted) return;

    if (size == null) {
      debugPrint("ServicesListPage banner: size == null");
      return;
    }

    BannerAd(
      adUnitId: GoogleAdConfig.getBannerAdUnitId(),
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("Ad was loaded.");
          if (!mounted) return;
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint("Ad failed to load with error: $err");
          ad.dispose();
        },
        onAdOpened: (Ad ad) {
          debugPrint("Ad was opened.");
        },
        onAdClosed: (Ad ad) {
          debugPrint("Ad was closed.");
        },
        onAdImpression: (Ad ad) {
          debugPrint("Ad recorded an impression.");
        },
        onAdClicked: (Ad ad) {
          debugPrint("Ad was clicked.");
        },
        onAdWillDismissScreen: (Ad ad) {
          debugPrint("Ad will be dismissed.");
        },
      ),
    ).load();
  }
}
