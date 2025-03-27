import 'package:flutter/material.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

class ToolsTypePage extends StatelessWidget {
  static const String TAG_START = "startDivider";
  static const String TAG_END = "endDivider";
  static const String TAG_CENTER = "centerDivider";
  static const String TAG_BLANK = "blankDivider";

  static const double IMAGE_ICON_WIDTH = 30.0;

  final imagePaths = [
    "assets/images/ic_discover_softwares.png",
    "assets/images/ic_discover_git.png",
    "assets/images/ic_discover_gist.png",
    "assets/images/ic_discover_scan.png",
    "assets/images/ic_discover_shake.png",
    "assets/images/ic_discover_nearby.png",
    "assets/images/ic_discover_pos.png",
  ];
  final titles = ["Airkiss"];
  final List listData = [];

  ToolsTypePage({super.key}) {
    initData();
  }

  initData() {
    listData.add(TAG_START);
    listData.add(ListItem(title: titles[0], icon: imagePaths[0]));
    // listData.add(TAG_CENTER);
    // listData.add(ListItem(title: titles[1], icon: imagePaths[1]));
    // listData.add(TAG_CENTER);
    // listData.add(ListItem(title: titles[2], icon: imagePaths[2]));
    // listData.add(TAG_CENTER);
    // listData.add(ListItem(title: titles[3], icon: imagePaths[3]));
    // listData.add(TAG_CENTER);
    // listData.add(ListItem(title: titles[4], icon: imagePaths[4]));
    listData.add(TAG_END);
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  renderRow(BuildContext ctx, int i) {
    var item = listData[i];
    if (item is String) {
      switch (item) {
        case TAG_START:
          return const TDDivider();
          break;
        case TAG_END:
          return const TDDivider();
          break;
        case TAG_CENTER:
          return const Padding(
            padding: EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
            child: const TDDivider(),
          );
          break;
        case TAG_BLANK:
          return Container(
            height: 20.0,
          );
          break;
      }
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
          handleListItemClick(ctx, item);
        },
        child: listItemContent,
      );
    }
  }

  void handleListItemClick(BuildContext ctx, ListItem item) {
    String title = item.title;
    switch (title) {
      case "Airkiss":
        {
          Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
//        smartconfig 工具页面
            return Airkiss(
              title: "${OpenIoTHubLocalizations.of(context).wechat} Airkiss",
              key: UniqueKey(),
            );
          }));
        }
        break;
      default:
        {
          Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
            return Airkiss(
              title: "${OpenIoTHubLocalizations.of(context).wechat} Airkiss",
              key: UniqueKey(),
            );
          }));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(OpenIoTHubLocalizations.of(context).tools)),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, i) => renderRow(context, i),
          ),
        ));
  }
}

class ListItem {
  String icon;
  String title;

  ListItem({required this.icon, required this.title});
}
