import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:openiothub/ads/ylh/banner_ylh.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'full_screen_web.dart';

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
  late final InAppWebViewSettings _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    useShouldOverrideUrlLoading: true,
    allowsInlineMediaPlayback: true,
  );

  InAppWebViewController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title == null ? "Web" : widget.title!),
        actions: _getActions(),
      ),
      body: openIoTHubDesktopConstrainedBody(
        maxWidth: 1280,
        child: Column(
          children: <Widget>[
            Expanded(
              child: InAppWebView(
                initialSettings: _settings,
                initialUrlRequest:
                    URLRequest(url: WebUri(widget.startUrl)),
                onWebViewCreated: (InAppWebViewController controller) {
                  _controller = controller;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final u = navigationAction.request.url!;
                  if (![
                    'http',
                    'https',
                    'file',
                    'chrome',
                    'data',
                    'javascript',
                    'about',
                  ].contains(u.scheme)) {
                    if (await canLaunchUrl(u)) {
                      await launchUrl(u, mode: LaunchMode.externalApplication);
                    }
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
              ),
            ),
            buildYLHBanner(context),
          ],
        ),
      ),
    );
  }

  _goToFullScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return FullScreenWeb(key: UniqueKey(), startUrl: widget.startUrl);
        },
      ),
    );
  }

  _openInBrowser() async {
    launchUrlString(widget.startUrl);
  }

  List<Widget>? _getActions() {
    List<Widget>? actions = [
      IconButton(
        onPressed: () {
          _goToFullScreen();
        },
        icon: Icon(Icons.fullscreen),
      ),
      IconButton(
        onPressed: () {
          _openInBrowser();
        },
        icon: Icon(Icons.open_in_browser),
      ),
    ];
    return actions;
  }
}
