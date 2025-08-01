import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';

class GatewayGuidePage extends StatefulWidget {
  const GatewayGuidePage({required Key key}) : super(key: key);

  @override
  _GatewayGuidePageState createState() => _GatewayGuidePageState();
}

class _GatewayGuidePageState extends State<GatewayGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(OpenIoTHubCommonLocalizations.of(context).gateway_install_guide),
        actions: <Widget>[],
      ),
      body: ListView(
        children: [
          Text(
            OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content1,
            style: TextStyle(fontSize: 23),
          ),
          Text(OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content2),
          Text(OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content3),
          Text(OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content4),
          Text(OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content5),
          Text(
            OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content6,
            style: TextStyle(fontSize: 23),
          ),
          TextButton(
              onPressed: () {
                _launchURL("https://github.com/OpenIoTHub/gateway-go/releases");
              },
              child: Text(OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content7)),
          Text(OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content8),
          Text(OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content9),
          Text(OpenIoTHubCommonLocalizations.of(context).gateway_install_guide_content10),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      print('Could not launch $url');
    }
  }
}
