import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub/plugin/openiothub_plugin.dart';
import 'package:openiothub/plugin/mdns_service/services/ssh/ssh_page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:openiothub/common_pages/web/web.dart';

import '../utils/port_config_to_port_service.dart';
import '../mdns_service/services/vncrfb_web_page.dart';
import '../mdns_service/services/aria2c.dart';
import '../mdns_service/services/nas/casa_zima_os/casaos_login.dart';
import '../mdns_service/services/nas/casa_zima_os/zima_login.dart';
import '../mdns_service/services/nas/unraid/login.dart';

class OpenWithChoice extends StatelessWidget {
  PortConfig portConfig;

  static const String tagStart = "startDivider";
  static const String tagEnd = "endDivider";
  static const String tagCenter = "centerDivider";
  static const String tagBlank = "blankDivider";

  static const double imageIconWidth = 30.0;

  final List listData = [];

  OpenWithChoice(this.portConfig) {
    listData.add(tagBlank);
    listData.add(tagStart);
    listData.add(
        ListItem(title: 'Web', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(tagCenter);
    listData.add(
        ListItem(title: 'Aria2', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(tagCenter);
    listData.add(
        ListItem(title: 'SSH', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(tagCenter);
    listData.add(
        ListItem(title: 'VNC', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(tagCenter);
    listData.add(ListItem(
        title: 'RDP Remote Desktop', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(tagCenter);
    listData.add(ListItem(
        title: 'CasaOS', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(tagCenter);
    listData.add(ListItem(
        title: 'ZimaOS', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(tagCenter);
    listData.add(ListItem(
        title: 'UnRaid', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(tagEnd);
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: imageIconWidth, height: imageIconWidth),
    );
  }

  _renderRow(BuildContext ctx, int i) {
    var item = listData[i];
    if (item is String) {
      Widget w = Divider(
        height: 1.0,
      );
      switch (item) {
        case tagStart:
          w = Divider(
            height: 1.0,
          );
          break;
        case tagEnd:
          w = Divider(
            height: 1.0,
          );
          break;
        case tagCenter:
          w = Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
            child: Divider(
              height: 1.0,
            ),
          );
          break;
        case tagBlank:
          w = Container(
            height: 20.0,
          );
          break;
      }
      return w;
    } else if (item is ListItem) {
      var listItemContent = Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Row(
          children: <Widget>[
            getIconImage(item.icon),
            Expanded(
                child: Text(
              item.title,
              style: Constants.titleTextStyle,
            )),
            Constants.rightArrowIcon
          ],
        ),
      );
      return InkWell(
        onTap: () {
          String title = item.title;
          if (title == 'Aria2') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return Aria2Page(
                device: portConfig2portService(portConfig),
                key: UniqueKey(),
              );
            })).then((_) {
              Navigator.of(ctx).pop();
            });
          } else if (title == 'SSH') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return SSHNativePage(
                device: portConfig2portService(portConfig),
                key: UniqueKey(),
              );
            })).then((_) {
              Navigator.of(ctx).pop();
            });
          } else if (title == 'VNC') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return VNCWebPage(
                device: portConfig2portService(portConfig),
                key: UniqueKey(),
              );
            })).then((_) {
              Navigator.of(ctx).pop();
            });
          } else if (title == 'Web') {
            var _url = "http://${Config.webgRpcIp}:${portConfig.localProt}";
            if (Platform.isLinux) {
              _launchUrl(_url);
              Navigator.of(ctx).pop();
            } else {
              Navigator.of(ctx).pop();
              Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
                return WebScreen(startUrl: _url,);
              }));
            }
          } else if (title == 'RDP Remote Desktop') {
            var url =
                'rdp://full%20address=s:${Config.webgRpcIp}:${portConfig.localProt}&audiomode=i:2&disable%20themes=i:1';
            _launchUrl(url).then((_) {
              Navigator.of(ctx).pop();
            });
          } else if (title == 'CasaOS') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return CasaLoginPage(
                // portService: PortService(ip: Config.webgRpcIp,port:portConfig.localProt),
                device: portConfig2portService(portConfig),
                key: UniqueKey(),
              );
            })).then((_) {
              Navigator.of(ctx).pop();
            });
          } else if (title == 'ZimaOS') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return ZimaLoginPage(
                // portService: PortService(ip: Config.webgRpcIp,port:portConfig.localProt),
                device: portConfig2portService(portConfig),
                key: UniqueKey(),
              );
            })).then((_) {
              Navigator.of(ctx).pop();
            });
          } else if (title == 'UnRaid') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return UnraidLoginPage(
                // portService: PortService(ip: Config.webgRpcIp,port:portConfig.localProt),
                device: portConfig2portService(portConfig),
                key: UniqueKey(),
              );
            })).then((_) {
              Navigator.of(ctx).pop();
            });
          }
        },
        child: listItemContent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (ctx, i) => _renderRow(ctx, i),
        itemCount: listData.length,
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class ListItem {
  String icon;
  String title;

  ListItem({required this.icon, required this.title});
}
