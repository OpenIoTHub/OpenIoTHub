import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({required Key key}) : super(key: key);
  // TODO 没有翻译国际化
  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.add("1：加入QQ群(251227638)反馈");
    _result.add("2. 关注云亿连的微信公众号<云亿连物联网>反馈");

    final tiles = _result.map(
      (pair) {
        return ListTile(
          title: Text(
            pair,
          ),
        );
      },
    );
    List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    divided.add(ListTile(
      title: Text(
        "公众号",
      ),
    ));
    divided.add(Image.asset(
      "assets/images/feedback/gongzhonghao.png",
      package: "openiothub_common_pages",
    ));
    divided.add(ListTile(
      title: Text(
        "QQ群",
      ),
    ));
    divided.add(Image.asset(
      "assets/images/feedback/qqqun.jpg",
      package: "openiothub_common_pages",
    ));
    return Scaffold(
        appBar: AppBar(
          title: Text("反馈渠道"),
          actions: <Widget>[],
        ),
        body: Container(
          child: ListView(children: divided),
        ));
  }
}
