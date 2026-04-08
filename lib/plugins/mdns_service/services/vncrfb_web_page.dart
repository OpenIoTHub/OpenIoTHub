import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:openiothub/models/port_service_info.dart';

class VNCWebPage extends StatefulWidget {
  const VNCWebPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.vnc";
  final PortServiceInfo device;

  @override
  State<StatefulWidget> createState() => VNCWebPageState();
}

class VNCWebPageState extends State<VNCWebPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late final String _url;
  late final InAppWebViewSettings _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    useShouldOverrideUrlLoading: true,
    allowsInlineMediaPlayback: true,
  );

  InAppWebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _url =
        "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/vnc/index.html?host=${Config.webgRpcIp}&port=${Config.webRestfulPort}&path=proxy%2fws%2fconnect%2fwebsockify%3fip%3d${widget.device.addr}%26port%3d${widget.device.port}&encrypt=0";
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      key: _scaffoldKey,
      body: openIoTHubDesktopConstrainedBody(
        maxWidth: 1440,
        child: SizedBox(
          width: double.infinity,
          height: h,
          child: InAppWebView(
            initialSettings: _settings,
            initialUrlRequest: URLRequest(url: WebUri(_url)),
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
      ),
    );
  }
}
