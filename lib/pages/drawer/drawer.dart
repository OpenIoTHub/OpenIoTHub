import 'dart:io';

import 'package:flutter/material.dart';

import 'package:openiothub_common_pages/commPages/appInfo.dart';
import 'package:openiothub/pages/user/tools/toolsTypePage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget BuildDrawer(BuildContext context) {
  return Drawer(
    //侧边栏按钮Drawer
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          //Material内置控件
//            accountName: Text('CYC'), //用户名
//            accountEmail: Text('example@126.com'),  //用户邮箱
//            currentAccountPicture: GestureDetector( //用户头像
//              onTap: () => print('current user'),
//              child: CircleAvatar(    //圆形图标控件
//                backgroundImage: NetworkImage('https://upload.jianshu.io/users/upload_avatars/7700793/dbcf94ba-9e63-4fcf-aa77-361644dd5a87?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),//图片调取自网络
//              ),
//            ),
//            otherAccountsPictures: <Widget>[    //粉丝头像
//              GestureDetector(    //手势探测器，可以识别各种手势，这里只用到了onTap
//                onTap: () => print('other user'), //暂且先打印一下信息吧，以后再添加跳转页面的逻辑
//                child: CircleAvatar(
//                  backgroundImage: NetworkImage('https://upload.jianshu.io/users/upload_avatars/10878817/240ab127-e41b-496b-80d6-fc6c0c99f291?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),
//                ),
//              ),
//              GestureDetector(
//                onTap: () => print('other user'),
//                child: CircleAvatar(
//                  backgroundImage: NetworkImage('https://upload.jianshu.io/users/upload_avatars/8346438/e3e45f12-b3c2-45a1-95ac-a608fa3b8960?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),
//                ),
//              ),
//            ],
          decoration: BoxDecoration(
            //用一个BoxDecoration装饰器提供背景图片
            image: DecorationImage(
              fit: BoxFit.fill,
              image: ExactAssetImage('assets/images/cover_img.jpg'),
            ),
          ),
        ),
        ListTile(
          //第一个功能项
            title: Text('工具'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ToolsTypePage()));
            }),
        ListTile(
          //TODO 管理MQTT服务器，以从MQTT服务器获取和操控设备
            title: Text('MQTT服务器'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ToolsTypePage()));
            }),
        ListTile(
          //第二个功能项
            title: Text('使用手册'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pop();
              Platform.isIOS
                  ? _launchURL("https://www.jianshu.com/u/b312a876d66e")
                  : _goToURL(context,
                  "https://www.jianshu.com/u/b312a876d66e", "使用手册");
            }),
        ListTile(
          //第二个功能项
            title: Text('社区反馈'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pop();
              Platform.isIOS
                  ? _launchURL("https://wulian.work")
                  : _goToURL(context,
                  "https://wulian.work", "社区反馈");
            }),
        ListTile(
          //第二个功能项
            title: Text('关于本软件'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AppInfoPage()));
            }),
        Divider(), //分割线控件
        ListTile(
          //退出按钮
          title: Text('Close'),
          trailing: Icon(Icons.cancel),
          onTap: () => Navigator.of(context).pop(), //点击后收起侧边栏
        ),
      ],
    ),
  );
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

_goToURL(BuildContext context, String url, title) async {
  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.open_in_browser,
              color: Colors.white,
            ),
            onPressed: () {
              _launchURL(url);
            })
      ]),
      body: WebView(
          initialUrl: url, javascriptMode: JavascriptMode.unrestricted),
    );
  }));
}