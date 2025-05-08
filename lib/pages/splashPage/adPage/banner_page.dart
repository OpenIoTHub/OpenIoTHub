import 'package:flutter/material.dart';
import 'package:flutter_unionad/bannerad/BannerAdView.dart';
import 'package:flutter_unionad/flutter_unionad.dart';

/// 描述：
/// @author guozi
/// @e-mail gstory0404@gmail.com
/// @time   2020/3/11

class BannerPage extends StatefulWidget {
  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  @override
  Widget build(BuildContext context) {
    print("banner广告");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "banner广告",
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: false,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            //banner广告
            FlutterUnionadBannerView(
              //andrrid banner广告id 必填
              androidCodeId: "102735527",
              //ios banner广告id 必填
              iosCodeId: "102735527",
              // 期望view 宽度 dp 必填
              width: 600.5,
              //期望view高度 dp 必填
              height: 120.5,
              //广告事件回调 选填
              callBack: FlutterUnionadBannerCallBack(
                onShow: () {
                  print("banner广告加载完成");
                },
                onDislike: (message) {
                  print("banner不感兴趣 $message");
                },
                onFail: (error) {
                  print("banner广告加载失败 $error");
                },
                onClick: () {
                  print("banner广告点击");
                },
                onEcpm: (info){
                  print("banner广告ecpm:$info");
                }
              ),
            ),
            FlutterUnionad.bannerAdView(
              androidCodeId: "102735527",
              iosCodeId: "102735527",
              expressViewWidth: 600,
              expressViewHeight: 200,
              //广告事件回调 选填
              callBack: FlutterUnionadBannerCallBack(
                onShow: () {
                  print("banner广告加载完成");
                },
                onDislike: (message) {
                  print("banner不感兴趣 $message");
                },
                onFail: (error) {
                  print("banner广告加载失败 $error");
                },
                onClick: () {
                  print("banner广告点击");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
