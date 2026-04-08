import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:openiothub/models/port_service_info.dart';

class Aria2Page extends StatefulWidget {
  const Aria2Page({required Key key, required this.device}) : super(key: key);
  static final String modelName = "com.iotserv.services.aria2c";
  final PortServiceInfo device;

  @override
  State<StatefulWidget> createState() => Aria2PageState();
}

class Aria2PageState extends State<Aria2Page> {
  late final String _injectJs;
  late final InAppWebViewSettings _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    useShouldOverrideUrlLoading: true,
    allowsInlineMediaPlayback: true,
  );

  bool _didInject = false;
  InAppWebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _injectJs =
        "window.localStorage.setItem('AriaNg.Options', '{\"language\":\"zh_Hans\",\"title\":\"\${downspeed}, \${upspeed} - \${title}\",\"titleRefreshInterval\":5000,\"browserNotification\":false,\"rpcAlias\":\"\",\"rpcHost\":\"${widget.device.addr}\",\"rpcPort\":\"${widget.device.port}\",\"rpcInterface\":\"jsonrpc\",\"protocol\":\"http\",\"httpMethod\":\"POST\",\"secret\":\"\",\"extendRpcServers\":[],\"globalStatRefreshInterval\":1000,\"downloadTaskRefreshInterval\":1000,\"rpcListDisplayOrder\":\"recentlyUsed\",\"afterCreatingNewTask\":\"task-list\",\"removeOldTaskAfterRetrying\":false,\"afterRetryingTask\":\"task-list-downloading\",\"displayOrder\":\"default:asc\",\"fileListDisplayOrder\":\"default:asc\",\"peerListDisplayOrder\":\"default:asc\"}');location.reload();";
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageUrl =
        "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/aria2/index.html";
    return InAppWebView(
      initialSettings: _settings,
      initialUrlRequest: URLRequest(url: WebUri(pageUrl)),
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
      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        if (_didInject) return;
        _didInject = true;
        await controller.evaluateJavascript(source: _injectJs);
      },
    );
  }
}
