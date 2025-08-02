import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub_ads/ylh/banner_ylh.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.startUrl));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title == null ? "Web" : widget.title!),
        actions: _getActions(),
      ),
      body:Column(children: <Widget>[
        WebViewWidget(controller: controller!),
        buildYLHBanner(context),
        ])
    );
  }

  _goToFullScreen() async {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return FullScreenWeb(
        key: UniqueKey(),
        startUrl: widget.startUrl,
      );
    }));
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
          icon: Icon(Icons.fullscreen)),
      IconButton(
          onPressed: () {
            _openInBrowser();
          },
          icon: Icon(Icons.open_in_browser))
    ];
    return actions;
  }
}
