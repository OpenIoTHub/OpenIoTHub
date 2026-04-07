import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = OpenIoTHubLocalizations.of(context);
    final githubRepo = "https://github.com/OpenIoTHub";
    final List<ListTile> tiles = [];
    tiles.add(ListTile(
      title: Row(
        children: [
          Text(l10n.feedback_github_title),
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
        l10n.feedback_qq_group_line,
      ),
    ));
    tiles.add(ListTile(
      title: Text(
        l10n.feedback_wechat_line,
      ),
    ));
    tiles.add(ListTile(
      title: Text(
        l10n.feedback_wechat_account_heading,
      ),
    ));
    tiles.add(ListTile(
        title: Image.asset(
      "assets/common/feedback/gongzhonghao.png",
    )));
    tiles.add(ListTile(
      title: Text(
        l10n.feedback_qq_group_heading,
      ),
    ));
    tiles.add(ListTile(
        title: Image.asset(
      "assets/common/feedback/qqqun.jpg",
    )));
    List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.common_feedback_channels),
          actions: <Widget>[],
        ),
        body: ListView(children: divided));
  }
}
