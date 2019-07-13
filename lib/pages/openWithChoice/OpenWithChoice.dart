import 'package:flutter/material.dart';
import 'package:nat_explorer/pages/openWithChoice/sshWeb/SSHWebPage.dart';
import 'package:nat_explorer/pages/openWithChoice/vncWeb/VNCWebPage.dart';
import 'package:nat_explorer/pages/openWithChoice/aria2/Aria2Page.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

class OpenWithChoice extends StatelessWidget {
  PortConfig portConfig;

  static const String TAG_START = "startDivider";
  static const String TAG_END = "endDivider";
  static const String TAG_CENTER = "centerDivider";
  static const String TAG_BLANK = "blankDivider";

  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  final titleTextStyle = TextStyle(fontSize: 16.0);
  final rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  final List listData = [];

  OpenWithChoice(this.portConfig) {
    listData.add(TAG_BLANK);
    listData.add(TAG_START);
    listData.add(ListItem(title: 'Aria2', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(TAG_CENTER);
    listData.add(ListItem(title: 'SSH', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(TAG_CENTER);
    listData.add(ListItem(title: 'VNC', icon: 'assets/images/ic_discover_nearby.png'));
    listData.add(TAG_END);
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: Image.asset(path,
          width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  _renderRow(BuildContext ctx, int i) {
    var item = listData[i];
    if (item is String) {
      Widget w = Divider(
        height: 1.0,
      );
      switch (item) {
        case TAG_START:
          w = Divider(
            height: 1.0,
          );
          break;
        case TAG_END:
          w = Divider(
            height: 1.0,
          );
          break;
        case TAG_CENTER:
          w = Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
            child: Divider(
              height: 1.0,
            ),
          );
          break;
        case TAG_BLANK:
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
                  style: titleTextStyle,
                )),
            rightArrowIcon
          ],
        ),
      );
      return InkWell(
        onTap: () {
          String title = item.title;
          if (title == 'Aria2') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return Aria2Page(localPort: portConfig.localProt,);
            }));
          } else if (title == 'SSH') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return SSHWebPage(runId:portConfig.device.runId,remoteIp:portConfig.device.addr,remotePort:portConfig.remotePort);
            }));
          } else if (title == 'VNC') {
            Navigator.push(ctx, MaterialPageRoute(builder: (ctx) {
              return VNCWebPage(runId:portConfig.device.runId,remoteIp:portConfig.device.addr,remotePort:portConfig.remotePort);
            }));
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
}

class ListItem {
  String icon;
  String title;
  ListItem({this.icon, this.title});
}
