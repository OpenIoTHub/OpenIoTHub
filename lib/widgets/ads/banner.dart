
import 'package:flutter/cupertino.dart';
import 'package:flutter_unionad/flutter_unionad.dart';

Widget build30075Banner(){
  return FlutterUnionad.bannerAdView(
    androidCodeId: "103478260",
    iosCodeId: "103477981",
    expressViewWidth: 600,
    expressViewHeight: 75,
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
  );
}

Widget build300150Banner() {
  return FlutterUnionad.bannerAdView(
    androidCodeId: "103478259",
    iosCodeId: "103475998",
    expressViewWidth: 600,
    expressViewHeight: 150,
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
  );
}
