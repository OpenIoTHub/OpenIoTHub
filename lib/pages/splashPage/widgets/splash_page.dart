import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';

import '../../homePage/all/homePage.dart';

/// 描述：开屏广告页
/// @author guozi
/// @e-mail gstory0404@gmail.com
/// @time   2020/3/11

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _offstage = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Offstage(
          offstage: _offstage,
          child: FlutterUnionadSplashAdView(
            //android 开屏广告广告id 必填 889033013 102729400
            androidCodeId: "103477524",
            //ios 开屏广告广告id 必填
            iosCodeId: "103476284",
            //是否支持 DeepLink 选填
            supportDeepLink: true,
            // 期望view 宽度 dp 选填
            width: MediaQuery.of(context).size.width,
            //期望view高度 dp 选填
            // height: MediaQuery.of(context).size.height - 100,
            // height: MediaQuery.of(context).size.height,
            //是否影藏跳过按钮(当影藏的时候显示自定义跳过按钮) 默认显示
            hideSkip: false,
            //超时时间
            timeout: 2000,
            //是否摇一摇
            isShake: true,
            callBack: FlutterUnionadSplashCallBack(
              onShow: () {
                print("开屏广告显示");
                setState(() => _offstage = false);
              },
              onClick: () {
                print("开屏广告点击");
              },
              onFail: (error) {
                print("开屏广告失败 $error");
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return MyHomePage(
                    key: UniqueKey(),
                    title: '',
                  );
                }));
              },
              onFinish: () {
                print("开屏广告倒计时结束");
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return MyHomePage(
                    key: UniqueKey(),
                    title: '',
                  );
                }));
              },
              onSkip: () {
                print("开屏广告跳过");
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return MyHomePage(
                    key: UniqueKey(),
                    title: '',
                  );
                }));
              },
              onTimeOut: () {
                print("开屏广告超时");
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return MyHomePage(
                    key: UniqueKey(),
                    title: '',
                  );
                }));
              },
              onEcpm: (info){
                print("开屏广告获取ecpm:$info");
              }
            ),
          ),
        ),
        // Expanded(
        //   child: Container(
        //     color: Colors.red,
        //     alignment: Alignment.center,
        //     child: Text(
        //       "flutter_unionad",
        //       style: TextStyle(
        //         fontSize: 20,
        //         color: Colors.black,
        //         decoration: TextDecoration.none,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
