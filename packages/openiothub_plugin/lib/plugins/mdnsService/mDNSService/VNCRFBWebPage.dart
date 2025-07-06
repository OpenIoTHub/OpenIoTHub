import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../models/PortServiceInfo.dart';

class VNCWebPage extends StatefulWidget {
  VNCWebPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.vnc";
  final PortServiceInfo device;

  @override
  State<StatefulWidget> createState() => VNCWebPageState();
}

class VNCWebPageState extends State<VNCWebPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    var url =
        "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/vnc/index.html?host=${Config.webgRpcIp}&port=${Config.webRestfulPort}&path=proxy%2fws%2fconnect%2fwebsockify%3fip%3d${widget.device.addr}%26port%3d${widget.device.port}&encrypt=0";
    final WebViewController controller = WebViewController()
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
      ..loadRequest(Uri.parse(url));
    _controller = controller;
    // _launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: WebViewWidget(controller: _controller),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
    }
  }
}
