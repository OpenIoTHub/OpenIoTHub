import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:openiothub/pages/common/openiothub_common_pages.dart';

class GatewayGuidePage extends StatefulWidget {
  const GatewayGuidePage({required Key key}) : super(key: key);

  @override
  State<GatewayGuidePage> createState() => GatewayGuidePageState();
}

class GatewayGuidePageState extends State<GatewayGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(OpenIoTHubLocalizations.of(context).gateway_install_guide),
        actions: <Widget>[],
      ),
      body: ListView(
        children: [
          Text(
            OpenIoTHubLocalizations.of(context).gateway_install_guide_content1,
            style: TextStyle(fontSize: 23),
          ),
          Text(OpenIoTHubLocalizations.of(context).gateway_install_guide_content2),
          Text(OpenIoTHubLocalizations.of(context).gateway_install_guide_content3),
          Text(OpenIoTHubLocalizations.of(context).gateway_install_guide_content4),
          Text(OpenIoTHubLocalizations.of(context).gateway_install_guide_content5),
          Text(
            OpenIoTHubLocalizations.of(context).gateway_install_guide_content6,
            style: TextStyle(fontSize: 23),
          ),
          TextButton(
              onPressed: () {
                _launchUrl("https://github.com/OpenIoTHub/gateway-go/releases");
              },
              child: Text(OpenIoTHubLocalizations.of(context).gateway_install_guide_content7)),
          Text(OpenIoTHubLocalizations.of(context).gateway_install_guide_content8),
          Text(OpenIoTHubLocalizations.of(context).gateway_install_guide_content9),
          Text(OpenIoTHubLocalizations.of(context).gateway_install_guide_content10),
        ],
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
