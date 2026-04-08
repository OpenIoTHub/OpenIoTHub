import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/router/core/app_navigator.dart';
import 'package:openiothub/widgets/host/add_host.dart';
// import 'package:openiothub/pages/commonDevice/services/old/commonDeviceServiceTypesList.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub/widgets/common/build_global_actions.dart';
import 'package:openiothub/utils/common/toast.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub/ads/openiothub_ads.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

class CommonDeviceListPage extends StatefulWidget {
  const CommonDeviceListPage({required Key key, required this.title})
    : super(key: key);

  final String title;

  @override
  State<CommonDeviceListPage> createState() => CommonDeviceListPageState();
}

class CommonDeviceListPageState extends State<CommonDeviceListPage> {
  BannerAd? _bannerAd;
  List<SessionConfig> _sessionList = [];
  List<Device> _commonDeviceList = [];
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
    debugPrint('init common device list');
  }

  @override
  void dispose() {
    super.dispose();
    _timerPeriod.cancel();
  }

  String _gatewayNameForDevice(Device pair) {
    var gatewayName = pair.runId.length > 24 ? pair.runId.substring(24) : pair.runId;
    for (final sessionConfig in _sessionList) {
      if (sessionConfig.runId == pair.runId) {
        gatewayName = sessionConfig.name;
      }
    }
    return gatewayName;
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;
    const pad = 12.0;
    final gridBody = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildBanner()),
        SliverToBoxAdapter(
          child: LayoutBuilder(
            builder: (context, c) {
              return openIoTHubHomeCardWrap(
                maxWidth: c.maxWidth,
                spacing: spacing,
                horizontalPadding: pad,
                topPadding: pad,
                bottomPadding: 24,
                cards: [
                  for (final pair in _commonDeviceList)
                    _buildHostCard(context, pair),
                ],
              );
            },
          ),
        ),
      ],
    );
    final scrollable =
        openIoTHubUseDesktopHomeLayout
            ? Scrollbar(thumbVisibility: true, child: gridBody)
            : gridBody;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: buildActions(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 2.0,
        tooltip:
            OpenIoTHubLocalizations.of(context).tooltip_add_remote_host_lan,
        onPressed: () {
          _addRemoteHostFromSession();
        },
        child: const Icon(Icons.add),
      ),
      body: openIoTHubDesktopConstrainedBody(
        child: RefreshIndicator(
          onRefresh: getAllCommonDevice,
          child:
              _commonDeviceList.isNotEmpty
                  ? scrollable
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
                            AppDecorations.dividerBorder,
                          ),
                          shape: WidgetStateProperty.all(const StadiumBorder()),
                        ),
                        onPressed: () {
                          _addRemoteHostFromSession();
                        },
                        child: Text(
                          OpenIoTHubLocalizations.of(
                            context,
                          ).please_add_host_first,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildHostCard(BuildContext context, Device pair) {
    final theme = Theme.of(context);
    final displayName =
        pair.name.isNotEmpty
            ? pair.name
            : (pair.description.isNotEmpty ? pair.description : '—');
    final initial =
        displayName.isNotEmpty ? displayName.substring(0, 1) : '?';
    final tintKey =
        pair.uuid.isNotEmpty
            ? pair.uuid
            : '${pair.addr}:${pair.runId}:${pair.name}';
    final tint = openIoTHubStableAccentFromKey(tintKey);
    final gatewayName = _gatewayNameForDevice(pair);
    final captionStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: theme.brightness == Brightness.dark ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            theme.brightness == Brightness.dark
                ? BorderSide(color: theme.dividerColor.withValues(alpha: 0.35))
                : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _pushDeviceServiceTypes(pair),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TDAvatar(
                    size: TDAvatarSize.medium,
                    type: TDAvatarType.customText,
                    text: initial,
                    shape: TDAvatarShape.square,
                    backgroundColor: tint,
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                displayName,
                style: Constants.titleTextStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                pair.addr.isNotEmpty ? pair.addr : '—',
                style: Constants.subTitleTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                openIoTHubMiddleEllipsis(gatewayName, maxChars: 28),
                style: captionStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (pair.mac.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  openIoTHubMiddleEllipsis(pair.mac, maxChars: 26),
                  style: captionStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (pair.name.isNotEmpty &&
                  pair.description.isNotEmpty &&
                  pair.description != pair.name) ...[
                const SizedBox(height: 6),
                Text(
                  pair.description,
                  style: Constants.subTitleTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (pair.uuid.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  openIoTHubMiddleEllipsis(pair.uuid, maxChars: 22),
                  style: captionStyle?.copyWith(fontFamily: 'monospace'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _pushDeviceServiceTypes(Device device) async {
    AppNavigator.pushServicesList(context, device).then((result) {
      if (!mounted) return;
      setState(() {
        getAllSession();
      });
    });
  }

  Future getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      debugPrint('Greeter client received: ${response.sessionConfigs}');
      setState(() {
        _sessionList = response.sessionConfigs;
      });
    } catch (e) {
      if (!mounted) return;
      showFailed(
        '${OpenIoTHubLocalizations.of(context).failed_to_get_session_list}: $e',
        context,
      );
    }
  }

  Future createOneCommonDevice(Device device) async {
    try {
      await CommonDeviceApi.createOneDevice(device);
    } catch (e) {
      if (!mounted) return;
      showFailed(
        "${OpenIoTHubLocalizations.of(context).create_device_failed}：$e",
        context,
      );
    }
  }

  Future<void> getAllCommonDevice() async {
    try {
      final response = await CommonDeviceApi.getAllDevice();
      debugPrint("=====getAllDevice:${response.devices}");
      setState(() {
        _commonDeviceList = response.devices;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint("openiothub获取设备失败:$e");
      }
      // showToast( "获取设备列表失败：${e}");
    }
    return;
  }

  void _addRemoteHostFromSession() {
    // 在一个界面里面选择网络
    showDialog(context: context, builder: (_) => AddHostWidget()).then((v) {
      getAllCommonDevice().then((v) {
        setState(() {});
      });
    });
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
