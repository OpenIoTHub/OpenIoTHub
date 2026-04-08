import 'package:flutter/material.dart';
import 'package:openiothub/pages/common/openiothub_common_pages.dart';
import 'package:openiothub/core/theme/app_spacing.dart';
import 'package:openiothub/core/theme/constants.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:openiothub/router/core/app_navigator.dart';

class ToolsTypePage extends StatelessWidget {
  static const String tagStart = "startDivider";
  static const String tagEnd = "endDivider";
  static const String tagCenter = "centerDivider";
  static const String tagBlank = "blankDivider";

  static const double imageIconWidth = 30.0;

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
    listData.add(tagStart);
    listData.add(ListItem(title: titles[0], icon: imagePaths[0]));
    // listData.add(tagCenter);
    // listData.add(ListItem(title: titles[1], icon: imagePaths[1]));
    // listData.add(tagCenter);
    // listData.add(ListItem(title: titles[2], icon: imagePaths[2]));
    // listData.add(tagCenter);
    // listData.add(ListItem(title: titles[3], icon: imagePaths[3]));
    // listData.add(tagCenter);
    // listData.add(ListItem(title: titles[4], icon: imagePaths[4]));
    listData.add(tagEnd);
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.listItemInnerPadding),
      child: Image.asset(path, width: imageIconWidth, height: imageIconWidth),
    );
  }

  renderRow(BuildContext ctx, int i) {
    var item = listData[i];
    if (item is String) {
      switch (item) {
        case tagStart:
          return const TDDivider();
        case tagEnd:
          return const TDDivider();
        case tagCenter:
          return Padding(
            padding: const EdgeInsets.only(left: AppSpacing.settingsListIndent),
            child: const TDDivider(),
          );
        case tagBlank:
          return const SizedBox(height: AppSpacing.listPageTopPadding);
      }
    } else if (item is ListItem) {
      var listItemContent = Padding(
        padding: AppInsets.listItemRow,
        child: Row(
          children: <Widget>[
            getIconImage(item.icon),
            Expanded(child: Text(item.title, style: Constants.titleTextStyle)),
            Constants.rightArrowIcon,
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
          AppNavigator.pushAirkiss(
            ctx,
            title: "${OpenIoTHubLocalizations.of(ctx).wechat} Airkiss",
          );
        }
        break;
      default:
        {
          AppNavigator.pushAirkiss(
            ctx,
            title: "${OpenIoTHubLocalizations.of(ctx).wechat} Airkiss",
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(OpenIoTHubLocalizations.of(context).tools)),
      body: openIoTHubDesktopScrollableListBody(
        scrollable: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.listPageTopPadding),
          child: ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, i) => renderRow(context, i),
          ),
        ),
      ),
    );
  }
}

class ListItem {
  String icon;
  String title;

  ListItem({required this.icon, required this.title});
}
