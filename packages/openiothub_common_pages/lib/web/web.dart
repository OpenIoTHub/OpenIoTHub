import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:openiothub_ads/openiothub_ads.dart';
import 'package:openiothub_common_pages/l10n/generated/openiothub_common_localizations.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/toast.dart';
import 'fullScreenWeb.dart';

GlobalKey<WebScreenState> webGlobalKey = GlobalKey();

class WebScreen extends StatefulWidget {
  const WebScreen(
      {super.key, required this.startUrl, this.title, this.httpProxyPort, this.urlEditable});

  final String startUrl;
  final String? title;
  final int? httpProxyPort;
  final bool? urlEditable;

  @override
  State<StatefulWidget> createState() {
    return WebScreenState();
  }
}

class WebScreenState extends State<WebScreen> {
  BannerAd? _bannerAd;

  InAppWebViewController? _webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    allowsInlineMediaPlayback: true,
    allowBackgroundAudioPlaying: true,
    iframeAllowFullscreen: true,
    javaScriptEnabled: true,
    mediaPlaybackRequiresUserGesture: false,
    useShouldOverrideUrlLoading: true,
  );

  double _progress = 0;
  String? _url;
  String? _currentUrl;

  // String _url = "http://localhost:8889";
  // String _url = "http://localhost:15244";
  // String _url = "https://baidu.com";
  bool _canGoBack = false;

  bool favorite = false;

  final TextEditingController _urlInput = TextEditingController(text: "");

  onClickNavigationBar() {
    log("onClickNavigationBar");
    _webViewController?.reload();
  }

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 1),(){_webViewController?.reload();});
    _loadAd();
    _setProxy();
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: !_canGoBack,
        onPopInvoked: (didPop) async {
          log("onPopInvoked $didPop");
          if (didPop) return;
          _webViewController?.goBack();
        },
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title == null ? "Web" : widget.title!),
            actions: _getActions(),
          ),
          body: Column(children: <Widget>[
            // SizedBox(height: MediaQuery.of(context).padding.top),
            Row(children: [
              TDInput(
                controller: _urlInput,
                backgroundColor: Colors.white,
                leftLabel: "URL:",
                width: MediaQuery.of(context).size.width - 70,
                onChanged: (String v) {},
                onEditingComplete: () {
                  _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(_urlInput.text)));
                },
                readOnly:(widget.urlEditable == null || widget.urlEditable == false)
              ),
              SizedBox(width: 70,child: IconButton(
                  onPressed: () {
                    _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(_urlInput.text)));
                  },
                  icon: Icon(Icons.start)),),
            ],),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            Expanded(
              child: InAppWebView(
                initialSettings: settings,
                initialUrlRequest: URLRequest(url: WebUri(widget.startUrl)),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                onLoadStart: (InAppWebViewController controller, Uri? url) {
                  log("onLoadStart $url");
                  setState(() {
                    _progress = 0;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  log("shouldOverrideUrlLoading ${navigationAction.request.url}");

                  var uri = navigationAction.request.url!;
                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    log("shouldOverrideUrlLoading ${uri.toString()}");
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }

                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onReceivedError: (controller, request, error) async {
                  // TODO
                  //   print(request.url);
                  //   print(request.url.path);
                  //   if (request.url.toString() == APIBaseUrl) {
                  //     _webViewController?.reload();
                  //     setState(() {
                  //
                  //     });
                  //   }
                },
                onDownloadStartRequest: (controller, url) async {
                  // show_info("onDownloadStartRequest:$url", context);
                  String urlStr = url.url.toString();
                  ClipboardData data = new ClipboardData(text: urlStr);
                  Clipboard.setData(data);
                  show_info("Url copied to clipboard", context);
                  launchUrlString(urlStr);
                  return;
                },
                onLoadStop:
                    (InAppWebViewController controller, Uri? url) async {
                  setState(() {
                    _progress = 0;
                  });
                  _currentUrl = url.toString();
                  setState(() {
                    _urlInput.text = url.toString();
                  });
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    _progress = progress / 100;
                    if (_progress == 1) _progress = 0;
                  });
                  controller.canGoBack().then((value) => setState(() {
                        _canGoBack = value;
                      }));
                },
                onUpdateVisitedHistory: (InAppWebViewController controller,
                    WebUri? url, bool? isReload) {
                  _url = url.toString();
                },
              ),
            ),
            _buildBanner(),
          ]),
        ));
  }

  _goToFullScreen() async {
    var url = await _webViewController?.getUrl();
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return FullScreenWeb(
        key: UniqueKey(),
        startUrl: url!.toString(),
      );
    }));
  }

  _openInBrowser() async {
    var url = await _webViewController?.getUrl();
    launchUrlString(url!.toString());
  }

  List<Widget>? _getActions() {
    List<Widget>? actions = [];
    // if (widget.httpProxyPort != null) {
    //   actions.add(IconButton(
    //       onPressed: () {
    //         _webViewController?.reload();
    //       },
    //       icon: Icon(Icons.abc)));
    // }
    actions.addAll([
      IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.backspace_outlined)),
      IconButton(
          onPressed: () {
            _webViewController?.reload();
          },
          icon: Icon(Icons.refresh)),
      IconButton(
          onPressed: () {
            _goToFullScreen();
          },
          icon: Icon(Icons.fullscreen)),
      IconButton(
          onPressed: () {
            _openInBrowser();
          },
          icon: Icon(Icons.open_in_browser))
    ]);
    return actions;
  }

  _buildBanner() {
    if (!Platform.isAndroid && !Platform.isIOS){
      return Container();
    }
    return isCnMainland(OpenIoTHubCommonLocalizations.of(context).localeName)
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

  void _setProxy() async {
    // https://github.com/pichillilorenzo/flutter_inappwebview/issues/1761
    var proxyAvailable =
        await WebViewFeature.isFeatureSupported(WebViewFeature.PROXY_OVERRIDE);
    print("proxyAvailable $proxyAvailable, widget.httpProxyPort:${widget.httpProxyPort}");
    if (proxyAvailable && widget.httpProxyPort != null) {
      ProxyController proxyController = ProxyController.instance();
      await proxyController.clearProxyOverride();
      String urlProxy = 'http://127.0.0.1:${widget.httpProxyPort}';
      await proxyController.setProxyOverride(
          settings: ProxySettings(
              proxyRules: [ProxyRule(url: urlProxy)],
              bypassRules: [])); // ProxySettings
    }else{
      print("proxyAvailable $proxyAvailable, widget.httpProxyPort:${widget.httpProxyPort}");
    }
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
