import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../models/PortServiceInfo.dart';

class Aria2Page extends StatefulWidget {
  Aria2Page({required Key key, required this.device}) : super(key: key);
  static final String modelName = "com.iotserv.services.aria2c";
  final PortServiceInfo device;

  @override
  State<StatefulWidget> createState() => Aria2PageState();
}

class Aria2PageState extends State<Aria2Page> {
  @override
  Widget build(BuildContext context) {
    String jsCode =
        "window.localStorage.setItem(\'AriaNg.Options\', \'{\"language\":\"zh_Hans\",\"title\":\"\${downspeed}, \${upspeed} - \${title}\",\"titleRefreshInterval\":5000,\"browserNotification\":false,\"rpcAlias\":\"\",\"rpcHost\":\"${widget.device.addr}\",\"rpcPort\":\"${widget.device.port}\",\"rpcInterface\":\"jsonrpc\",\"protocol\":\"http\",\"httpMethod\":\"POST\",\"secret\":\"\",\"extendRpcServers\":[],\"globalStatRefreshInterval\":1000,\"downloadTaskRefreshInterval\":1000,\"rpcListDisplayOrder\":\"recentlyUsed\",\"afterCreatingNewTask\":\"task-list\",\"removeOldTaskAfterRetrying\":false,\"afterRetryingTask\":\"task-list-downloading\",\"displayOrder\":\"default:asc\",\"fileListDisplayOrder\":\"default:asc\",\"peerListDisplayOrder\":\"default:asc\"}\');location.reload();";
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/aria2/index.html"));
    controller.runJavaScript(jsCode);
    return WebViewWidget(controller: controller);
  }
}
