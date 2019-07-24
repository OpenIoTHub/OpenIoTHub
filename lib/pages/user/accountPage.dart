import 'package:flutter/material.dart';
import 'package:nat_explorer/constants/Constants.dart';
import 'package:nat_explorer/events/LoginEvent.dart';
import 'package:nat_explorer/events/LogoutEvent.dart';
import 'package:nat_explorer/pages/openWithChoice/OpenWithChoice.dart';
import 'package:nat_explorer/pages/user/player.dart';
import 'package:nat_explorer/pages/user/tools/toolsTypePage.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nat_explorer/api/SessionApi.dart';
import 'package:nat_explorer/util/NetUtils.dart';
import 'package:nat_explorer/util/DataUtils.dart';
import 'package:nat_explorer/model/UserInfo.dart';

class MyInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyInfoPageState();
  }
}

class MyInfoPageState extends State<MyInfoPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var titles = ["我的消息", "设置", "工具", "使用手册", "关于", "测试"];
  var imagePaths = [
    "assets/images/ic_my_message.png",
    "assets/images/ic_my_blog.png",
    "assets/images/ic_my_blog.png",
    "assets/images/ic_my_question.png",
    "assets/images/ic_discover_pos.png",
    "assets/images/ic_my_team.png",
    "assets/images/ic_my_recommend.png"
  ];
  var icons = [];
  var userAvatar;
  var userName;
  var titleTextStyle = TextStyle(fontSize: 16.0);
  var rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  MyInfoPageState() {
    icons.add(
      Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(Icons.message)),
    );
    icons.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(Icons.settings)),
        );
    icons.add(
      Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(Icons.pan_tool)),
    );
    icons.add(
      Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(Icons.find_in_page)),
    );
    icons.add(
      Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(Icons.info)),
    );
    icons.add(
      Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(Icons.ac_unit)),
    );
  }

  @override
  void initState() {
    super.initState();
    _showUserInfo();
    Constants.eventBus.on<LogoutEvent>().listen((event) {
      // 收到退出登录的消息，刷新个人信息显示
      _showUserInfo();
    });
    Constants.eventBus.on<LoginEvent>().listen((event) {
      // 收到登录的消息，重新获取个人信息
      getUserInfo();
    });
  }

  _showUserInfo() {
    DataUtils.getUserInfo().then((UserInfo userInfo) {
      if (userInfo != null) {
        print(userInfo.name);
        print(userInfo.avatar);
        setState(() {
          userAvatar = userInfo.avatar;
          userName = userInfo.name;
        });
      } else {
        setState(() {
          userAvatar = null;
          userName = null;
        });
      }
    });
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: Image.asset(path,
          width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView.builder(
      itemCount: titles.length * 2,
      itemBuilder: (context, i) => renderRow(i),
    );
    return listView;
  }

  // 获取用户信息
  getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String accessToken = sp.get(DataUtils.SP_AC_TOKEN);
    Map<String, String> params = Map();
    params['access_token'] = accessToken;
    NetUtils.get("", params: params).then((data) {
      if (data != null) {
        var map = json.decode(data);
        setState(() {
          userAvatar = map['avatar'];
          userName = map['name'];
        });
        DataUtils.saveUserInfo(map);
      }
    });
  }

  _login() async {
    // 打开登录页并处理登录成功的回调
    final result = await Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (context) {
      return Text("登录页");
    }));
    // result为"refresh"代表登录成功
    if (result != null && result == "refresh") {
      // 刷新用户信息
      getUserInfo();
      // 通知动弹页面刷新
      Constants.eventBus.fire(LoginEvent());
    }
  }

  _showUserInfoDetail() {}

  renderRow(i) {
    if (i == 0) {
      var avatarContainer = Container(
        color: Colors.teal,
        height: 200.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userAvatar == null
                  ? Image.asset(
                "assets/images/ic_avatar_default.png",
                width: 60.0,
              )
                  : Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: NetworkImage(userAvatar),
                      fit: BoxFit.cover),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
              Text(
                userName == null ? "点击头像登录" : userName,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
      return GestureDetector(
        onTap: () {
          DataUtils.isLogin().then((isLogin) {
            if (isLogin) {
              // 已登录，显示用户详细信息
              _showUserInfoDetail();
            } else {
              // 未登录，跳转到登录页面
              _login();
            }
          });
        },
        child: avatarContainer,
      );
    }
    --i;
    if (i.isOdd) {
      return Divider(
        height: 1.0,
      );
    }
    i = i ~/ 2;
    String title = titles[i];
    var listItemContent = Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: Row(
        children: <Widget>[
          icons[i],
          Expanded(
              child: Text(
                title,
                style: titleTextStyle,
              )),
          rightArrowIcon
        ],
      ),
    );
    return InkWell(
      child: listItemContent,
      onTap: () {
        _handleListItemClick(title);
//        Navigator
//            .of(context)
//            .push(MaterialPageRoute(builder: (context) => CommonWebPage(title: "Test", url: "https://my.oschina.net/u/815261/blog")));
      },
    );
  }

  _showLoginDialog() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('没有登录，现在去登录吗？'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '取消',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  '确定',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _login();
                },
              )
            ],
          );
        });
  }

//  根据不同的标题切换到不同的界面
  _handleListItemClick(String title) {
    if (title == "工具"){
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ToolsTypePage()
          ));
    }
    else if (title == "设置"){
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => Text('设置页')
          ));
    }
    else if (title == "使用手册"){}
    else if (title == "关于"){
      PortConfig config = PortConfig();
      Device device = Device();
      device.runId = "runId";
      device.addr = "192.168.0.1";
      config.device = device;
      config.remotePort = 5900;
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => OpenWithChoice(config)
          ));
    }
    else if (title == "测试"){
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => VideoApp()
          ));
    }
    else {
      DataUtils.isLogin().then((isLogin) {
        if (!isLogin) {
          // 未登录
          _showLoginDialog();
        } else {
          DataUtils.getUserInfo().then((info) {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Text("我的")
                ));
          });
        }
      });
    }
  }
}
