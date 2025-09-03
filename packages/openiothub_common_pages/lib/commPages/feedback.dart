import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../l10n/generated/openiothub_common_localizations.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({required Key key}) : super(key: key);

  // TODO 没有翻译国际化
  @override
  Widget build(BuildContext context) {
    final githubRepo = "https://github.com/OpenIoTHub";
    final List<ListTile> tiles = [];
    tiles.add(ListTile(
      title: Row(
        children: [
          Text("0：Github"),
          TextButton(
              onPressed: () {
                launchUrlString(githubRepo);
              },
              child: Text(githubRepo))
        ],
      ),
    ));
    tiles.add(ListTile(
      title: Text(
        "1：加入QQ群(251227638)反馈",
      ),
    ));
    tiles.add(ListTile(
      title: Text(
        "2. 关注云亿连的微信公众号<云亿连物联网>反馈",
      ),
    ));
    tiles.add(ListTile(
      title: Text(
        "公众号",
      ),
    ));
    tiles.add(ListTile(
        title: Image.asset(
      "assets/images/feedback/gongzhonghao.png",
      package: "openiothub_common_pages",
    )));
    tiles.add(ListTile(
      title: Text(
        "QQ群",
      ),
    ));
    tiles.add(ListTile(
        title: Image.asset(
      "assets/images/feedback/qqqun.jpg",
      package: "openiothub_common_pages",
    )));
    List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
        appBar: AppBar(
          title:
              Text(OpenIoTHubCommonLocalizations.of(context).feedback_channels),
          actions: <Widget>[],
        ),
        body: Container(
          child: ListView(children: divided),
        ));
  }
}
