import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

import 'package:openiothub/utils/common/toast.dart';

GlobalKey<FullScreenWebState> webGlobalKey = GlobalKey();

class FullScreenWeb extends StatefulWidget {
  const FullScreenWeb({super.key, required this.startUrl});

  final String startUrl;

  @override
  State<StatefulWidget> createState() {
    return FullScreenWebState();
  }
}

class FullScreenWebState extends State<FullScreenWeb> {
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
  bool _canGoBack = false;

  onClickNavigationBar() {
    log("onClickNavigationBar");
    _webViewController?.reload();
  }

  @override
  void initState() {
    if (!openIoTHubUseDesktopHomeLayout) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    }
    super.initState();
    // Future.delayed(Duration(seconds: 1),(){_webViewController?.reload();});
  }

  @override
  void dispose() {
    if (!openIoTHubUseDesktopHomeLayout) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
    }
    _webViewController?.dispose();
    super.dispose();
  }

  Widget _webColumn() {
    return Column(
      children: <Widget>[
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
                "about",
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
            },
            onDownloadStartRequest: (controller, url) async {
              String urlStr = url.url.toString();
              ClipboardData data = ClipboardData(text: urlStr);
              Clipboard.setData(data);
              showInfo("Url copied to clipboard", context);
              launchUrlString(urlStr);
              return;
            },
            onLoadStop: (InAppWebViewController controller, Uri? url) async {
              setState(() {
                _progress = 0;
              });
            },
            onProgressChanged: (
              InAppWebViewController controller,
              int progress,
            ) {
              setState(() {
                _progress = progress / 100;
                if (_progress == 1) _progress = 0;
              });
              controller.canGoBack().then(
                (value) => setState(() {
                  _canGoBack = value;
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final body =
        openIoTHubUseDesktopHomeLayout
            ? openIoTHubDesktopConstrainedBody(
              maxWidth: 1280,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: double.infinity,
                child: _webColumn(),
              ),
            )
            : _webColumn();

    return PopScope(
      canPop: !_canGoBack,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        log("onPopInvokedWithResult $didPop");
        if (didPop) return;
        _webViewController?.goBack();
      },
      child: Scaffold(body: body),
    );
  }
}
