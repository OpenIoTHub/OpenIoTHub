import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub/widgets/common/build_global_actions.dart';
import 'package:openiothub/network/openiothub/session_api.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:openiothub/ads/openiothub_ads.dart';
import 'package:openiothub/router/core/app_navigator.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

class GatewayListPage extends StatefulWidget {
  const GatewayListPage({required Key key, required this.title})
    : super(key: key);

  final String title;

  @override
  State<GatewayListPage> createState() => GatewayListPageState();
}

class GatewayListPageState extends State<GatewayListPage> {
  BannerAd? _bannerAd;
  static const double imageIconWidth = 30.0;

  List<SessionConfig> _sessionList = [];
  late Timer _timerPeriod;

  @override
  void initState() {
    super.initState();
    getAllSession();
    Future.delayed(Duration(seconds: 1), () {
      getAllSession();
    });
    Future.delayed(Duration(seconds: 2), () {
      getAllSession();
    });
    _timerPeriod = Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      getAllSession();
    });
    _loadAd();
  }

  @override
  void dispose() {
    super.dispose();
    _timerPeriod.cancel();
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
                  for (final pair in _sessionList)
                    _buildGatewayCard(context, pair),
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
        tooltip: OpenIoTHubLocalizations.of(context).tooltip_scan_gateway_go_qr,
        onPressed: () {
          scanQR(context);
        },
        child: const Icon(TDIcons.scan),
      ),
      body: openIoTHubDesktopConstrainedBody(
        child: RefreshIndicator(
          onRefresh: getAllSession,
          child:
              _sessionList.isNotEmpty
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
                          AppNavigator.pushGuide(context, activeIndex: 1);
                        },
                        child: Text(
                          OpenIoTHubLocalizations.of(context).add_a_gateway,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          launchUrlString(
                            "https://github.com/OpenIoTHub/gateway-go",
                          );
                        },
                        child: Text(
                          OpenIoTHubLocalizations.of(context).install_gateway,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildGatewayCard(BuildContext context, SessionConfig pair) {
    final l10n = OpenIoTHubLocalizations.of(context);
    final bool isOnline =
        pair.statusToClient ||
        pair.statusP2PAsClient ||
        pair.statusP2PAsServer;
    final theme = Theme.of(context);
    final name = pair.name.isNotEmpty ? pair.name : '—';
    final initial =
        pair.name.isNotEmpty ? pair.name.substring(0, 1) : '?';
    final tint = openIoTHubStableAccentFromKey(
      pair.runId.isNotEmpty ? pair.runId : pair.name,
    );
    final p2pOn = pair.statusP2PAsClient || pair.statusP2PAsServer;
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
        onTap: () => _pushmDNSServices(pair),
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
                  const SizedBox(width: 8),
                  isOnline
                      ? TDTag(
                        l10n.online,
                        theme: TDTagTheme.success,
                        isLight: true,
                      )
                      : TDTag(
                        l10n.offline,
                        theme: TDTagTheme.danger,
                        isLight: true,
                      ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: Constants.titleTextStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  TDTag(
                    pair.statusToClient
                        ? l10n.home_gateway_relay_on
                        : l10n.home_gateway_relay_off,
                    theme:
                        pair.statusToClient
                            ? TDTagTheme.success
                            : TDTagTheme.defaultTheme,
                    isLight: true,
                  ),
                  TDTag(
                    p2pOn
                        ? l10n.home_gateway_p2p_on
                        : l10n.home_gateway_p2p_off,
                    theme:
                        p2pOn
                            ? TDTagTheme.primary
                            : TDTagTheme.defaultTheme,
                    isLight: true,
                  ),
                ],
              ),
              if (pair.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  pair.description,
                  style: Constants.subTitleTextStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (pair.runId.isNotEmpty) ...[
                SizedBox(height: pair.description.isNotEmpty ? 6 : 8),
                Text(
                  openIoTHubMiddleEllipsis(pair.runId, maxChars: 22),
                  style: captionStyle,
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

  void _pushmDNSServices(SessionConfig config) async {
    AppNavigator.pushGatewayMdnsServiceList(context, config).then((result) {
      if (!mounted) return;
      setState(() {
        getAllSession();
      });
    });
  }

  Future createOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.createOneSession(config);
      debugPrint('Greeter client received: $response');
    } catch (e) {
      debugPrint('Caught error: $e');
    }
  }

  void deleteOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.deleteOneSession(config);
      debugPrint('Greeter client received: $response');
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(OpenIoTHubLocalizations.of(context).delete_result),
              content: SizedBox.expand(
                child: Text(
                  OpenIoTHubLocalizations.of(context).delete_successful,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(OpenIoTHubLocalizations.of(context).confirm),
                  onPressed: () {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
      ).then((result) {
        if (!mounted) return;
        Navigator.of(context).pop();
      });
    } catch (e) {
      debugPrint('Caught error: $e');
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(OpenIoTHubLocalizations.of(context).delete_result),
              content: SizedBox.expand(
                child: Text(
                  "${OpenIoTHubLocalizations.of(context).delete_failed}:$e",
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(OpenIoTHubLocalizations.of(context).cancel),
                  onPressed: () {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(OpenIoTHubLocalizations.of(context).confirm),
                  onPressed: () {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
      );
    }
  }

  Future<void> getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      debugPrint('Greeter client received: ${response.sessionConfigs}');
      setState(() {
        _sessionList = response.sessionConfigs;
      });
    } catch (e) {
      debugPrint('Caught error: $e');
    }
    return;
  }

  Future refreshmDNSServices(SessionConfig sessionConfig) async {
    try {
      await SessionApi.refreshmDNSServices(sessionConfig);
    } catch (e) {
      debugPrint('Caught error: $e');
    }
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: Image.asset(path, width: imageIconWidth, height: imageIconWidth),
    );
  }

  _buildBanner() {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return Container();
    }
    final mainlandCn = context.isCnMainlandLocale;
    return mainlandCn
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
