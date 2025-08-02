import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:openiothub_ads/ylh/banner_ylh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/toast.dart';
import 'fullScreenWeb.dart';

GlobalKey<WebScreenState> webGlobalKey = GlobalKey();

class WebScreen extends StatefulWidget {
  const WebScreen({super.key, required this.startUrl, this.title});

  final String startUrl;
  final String? title;

  @override
  State<StatefulWidget> createState() {
    return WebScreenState();
  }
}

class WebScreenState extends State<WebScreen> {
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

  onClickNavigationBar() {
    log("onClickNavigationBar");
    _webViewController?.reload();
  }

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 1),(){_webViewController?.reload();});
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
            title: Text(widget.title==null?"Web":widget.title!),
            actions: _getActions(),
          ),
          body: Column(children: <Widget>[
            // SizedBox(height: MediaQuery.of(context).padding.top),
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
                  ClipboardData data = new ClipboardData(text:urlStr);
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
            buildYLHBanner(context),
          ]),
        ));
  }

  _goToFullScreen() async {
    var url = await _webViewController?.getUrl();
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return FullScreenWeb(key: UniqueKey(),startUrl: url!.toString(),);
    }));
  }

  _openInBrowser() async {
    var url = await _webViewController?.getUrl();
    launchUrlString(url!.toString());
  }

  List<Widget>? _getActions() {
    List<Widget>? actions = [
      IconButton(onPressed: (){_webViewController?.reload();}, icon: Icon(Icons.refresh)),
      IconButton(onPressed: (){_goToFullScreen();}, icon: Icon(Icons.fullscreen)),
      IconButton(onPressed: (){_openInBrowser();}, icon: Icon(Icons.open_in_browser))
    ];
    return actions;
  }
}
