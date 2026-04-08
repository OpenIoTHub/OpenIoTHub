import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/router/app_navigator.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/core/app_spacing.dart';
import 'package:openiothub/core/shared_preferences_keys.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:openiothub/providers/custom_theme.dart';
import 'package:openiothub/utils/openiothub_desktop_layout.dart';
import 'package:openiothub/ads/openiothub_ads.dart';
// import '../../widgets/ads/banner_ylh_test.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  BannerAd? _bannerAd;
  String username = "";
  String useremail = "";
  String usermobile = "";

  String userAvatar = "";

  late List<ListTile> _listTiles;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    _initListTiles();
    _getUserInfo();
    final listBody = ListView.separated(
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeader();
        }
        if (index == _listTiles.length + 1) {
          return build300150Banner(context);
        }
        if (index == _listTiles.length + 2) {
          return _buildBanner();
        }
        index -= 1;
        return _buildListTile(index);
      },
      separatorBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: AppSpacing.settingsListIndent),
          child: TDDivider(),
        );
      },
      itemCount: _listTiles.length + 3,
    );
    return Scaffold(
      extendBody: true, //底部NavigationBar透明
      extendBodyBehindAppBar: true, //顶部Bar透明
      appBar: AppBar(
        // shadowColor: Colors.transparent,
        toolbarHeight: 0,
        backgroundColor: Provider.of<CustomTheme>(context).primaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      body: openIoTHubDesktopConstrainedBody(
        child:
            openIoTHubUseDesktopHomeLayout
                ? Scrollbar(thumbVisibility: true, child: listBody)
                : listBody,
      ),
    );
  }

  _login() async {
    final userSignedIned = await userSignedIn();
    if (!mounted) return;
    if (userSignedIned) {
      context.push(AppRoutes.userInfo).then((value) => _getUserInfo());
    } else {
      context.push(AppRoutes.login).then((value) => _getUserInfo());
    }
  }

  Container _buildHeader() {
    return Container(
      color: Provider.of<CustomTheme>(context).primaryColor,
      height: 150.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child:
                  userAvatar != ""
                      ? Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xffffffff),
                            width: 2.0,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(userAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      : Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xffffffff),
                            width: 2.0,
                          ),
                          image: const DecorationImage(
                            image: ExactAssetImage(
                              "assets/images/leftmenu/avatars/panda.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              onTap: () async {
                _login();
              },
            ),
            const SizedBox(height: 10.0),
            Text(username, style: const TextStyle(color: Color(0xffffffff))),
          ],
        ),
      ),
    );
  }

  _initListTiles() {
    setState(() {
      _listTiles = <ListTile>[
        ListTile(
          //第一个功能项
          title: Text(OpenIoTHubLocalizations.of(context).profile_settings),
          leading: Icon(TDIcons.setting, color: Colors.red),
          trailing: const Icon(Icons.arrow_right),
          onTap: () {
            AppNavigator.pushSettings(
              context,
              title: OpenIoTHubLocalizations.of(context).profile_settings,
            );
          },
        ),
        ListTile(
          //第一个功能项
          title: Text(OpenIoTHubLocalizations.of(context).profile_servers),
          leading: Icon(TDIcons.server, color: Colors.orange),
          trailing: const Icon(Icons.arrow_right),
          onTap: () async {
            final signed = await userSignedIn();
            if (!mounted) return;
            if (signed) {
              AppNavigator.pushServers(
                context,
                title: OpenIoTHubLocalizations.of(context).profile_servers,
              );
            } else {
              context.push(AppRoutes.login);
            }
          },
        ),
        ListTile(
          //第一个功能项
          title: Text(OpenIoTHubLocalizations.of(context).profile_tools),
          leading: Icon(TDIcons.tools, color: Colors.yellow),
          trailing: const Icon(Icons.arrow_right),
          onTap: () {
            context.push(AppRoutes.tools);
          },
        ),
        ListTile(
          //第二个功能项
          title: Text(OpenIoTHubLocalizations.of(context).profile_docs),
          leading: Icon(TDIcons.book_filled, color: Colors.green),
          trailing: const Icon(Icons.arrow_right),
          onTap: () {
            String url = "https://docs.iothub.cloud/";
            goToUrl(
              context,
              url,
              OpenIoTHubLocalizations.of(context).profile_docs,
            );
          },
        ),
        ListTile(
          //第二个功能项
          title: Text(
            OpenIoTHubLocalizations.of(context).profile_video_tutorials,
          ),
          leading: Icon(TDIcons.video, color: Colors.teal),
          trailing: const Icon(Icons.arrow_right),
          onTap: () {
            String url = "https://space.bilibili.com/1222749704";
            launchUrl(url);
          },
        ),
        ListTile(
          //第二个功能项
          title: Text(OpenIoTHubLocalizations.of(context).app_local_gateway),
          leading: Icon(TDIcons.wifi, color: Colors.blue),
          trailing: const Icon(Icons.arrow_right),
          onTap: () {
            context.push(AppRoutes.gatewayQr);
          },
        ),
        // ListTile(
        //     //第二个功能项
        //     title: Text(OpenIoTHubLocalizations.of(context).profile_feedback),
        //     leading: const Icon(Icons.feedback_outlined),
        //     trailing: const Icon(Icons.arrow_right),
        //     onTap: () {
        //       String url = "https://support.qq.com/product/657356";
        //       goToUrl(context, url, OpenIoTHubLocalizations.of(context).profile_feedback);
        //     }),
        ListTile(
          //第二个功能项
          title: Text(
            OpenIoTHubLocalizations.of(context).profile_about_this_app,
          ),
          leading: Icon(TDIcons.info_circle, color: Colors.purple),
          trailing: const Icon(Icons.arrow_right),
          onTap: () {
            context.push(AppRoutes.appInfo);
          },
        ),
        // ListTile(
        //     //第二个功能项
        //     title: Text("Share QQ"),
        //     leading: const Icon(Icons.share),
        //     trailing: const Icon(Icons.arrow_right),
        //     onTap: () async {
        //       var title = "云亿连内网穿透和智能家居管理";
        //       var description = "云亿连全平台管理您的所有智能设备和私有云";
        //       var url = "https://iothub.cloud/download.html";
        //       TencentKitPlatform.instance.shareWebpage(
        //         scene: TencentScene.kScene_QQ,
        //         title: title,
        //         // summary: description,
        //         targetUrl: url,
        //       );
        //     }),
      ];
    });
  }

  ListTile _buildListTile(int index) {
    return _listTiles[index];
  }

  Future<void> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    if (prefs.containsKey(SharedPreferencesKey.userNameKey)) {
      setState(() {
        username = prefs.getString(SharedPreferencesKey.userNameKey)!;
      });
    } else {
      setState(() {
        username = OpenIoTHubLocalizations.of(context).profile_not_logged_in;
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.userEmailKey)) {
      setState(() {
        useremail = prefs.getString(SharedPreferencesKey.userEmailKey)!;
      });
    } else {
      setState(() {
        useremail = "";
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.userMobileKey)) {
      setState(() {
        usermobile = prefs.getString(SharedPreferencesKey.userMobileKey)!;
      });
    } else {
      setState(() {
        usermobile = "";
      });
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
