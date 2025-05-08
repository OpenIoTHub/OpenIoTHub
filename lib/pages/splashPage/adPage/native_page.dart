import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:flutter_unionad/nativead/NativeAdView.dart';

/// 描述：个性化模板信息流广告
/// @author guozi
/// @e-mail gstory0404@gmail.com
/// @time   2020/3/11
class NativeAdPage extends StatefulWidget {
  @override
  _NativeExpressAdPageState createState() => _NativeExpressAdPageState();
}

class _NativeExpressAdPageState extends State<NativeAdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "个性化模板信息流广告",
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: false,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            //个性化模板信息流广告
            FlutterUnionadNativeAdView(
              //android 信息流广告id 必填
              androidCodeId: "102730271",
              //ios banner广告id 必填
              iosCodeId: "102730271",
              //是否支持 DeepLink 选填
              supportDeepLink: true,
              // 期望view 宽度 dp 必填
              width: 375.5,
              //期望view高度 dp 必填
              height: 100,
              //是否静音
              isMuted: false,
              callBack: FlutterUnionadNativeCallBack(
                onShow: () {
                  print("信息流广告显示");
                },
                onFail: (error) {
                  print("信息流广告失败 $error");
                },
                onDislike: (message) {
                  print("信息流广告不感兴趣 $message");
                },
                onClick: () {
                  print("信息流广告点击");
                },
                onEcpm: (info) {
                  print("信息流广告ecpm $info");
                },
              ),
            ),
            FlutterUnionad.nativeAdView(
              //android 信息流广告id 必填
              androidCodeId: "102730271",
              //ios banner广告id 必填
              iosCodeId: "102730271",
              expressViewWidth: 300,
              expressViewHeight: 200,
              callBack: FlutterUnionadNativeCallBack(
                onShow: () {
                  print("信息流广告显示");
                },
                onFail: (error) {
                  print("信息流广告失败 $error");
                },
                onDislike: (message) {
                  print("信息流广告不感兴趣 $message");
                },
                onClick: () {
                  print("信息流广告点击");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
