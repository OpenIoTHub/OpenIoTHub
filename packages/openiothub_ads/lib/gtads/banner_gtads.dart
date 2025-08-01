import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gtads/gtads.dart';
import 'package:openiothub_ads/configs/configs.dart';

Widget build30075Banner(BuildContext context){
  return GTAdsBannerWidget(
    //需要的广告位数组
      codes: [
        GTAdsCode(alias: "csj", probability: 6,androidId: CsjAdConfig.getBannerAdUnitId(),iosId: CsjAdConfig.getBannerAdUnitId()),
        GTAdsCode(alias: "ylh", probability: 10,androidId: YlhAdConfig.getBannerAdUnitId(),iosId: YlhAdConfig.getBannerAdUnitId()),
      ],
      //宽
      width: MediaQuery.of(context).size.width,
      //高
      height: MediaQuery.of(context).size.width/6.4,
      //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
      timeout: 15,
      //广告加载模式 [GTAdsModel.RANDOM]优先级模式 [GTAdsModel.RANDOM]随机模式
      //默认随机模式
      model: GTAdsModel.PRIORITY,
      //回调
      callBack: GTAdsCallBack(
        onShow: (code) {
          print("Banner显示 ${code.toJson()}");
        },
        onClick: (code) {
          print("Banner点击 ${code.toJson()}");
        },
        onFail: (code,message) {
          print("Banner错误 ${code?.toJson()} $message");
        },
        onClose: (code) {
          print("Banner关闭 ${code.toJson()}");
        },
        onTimeout: () {
          print("Banner加载超时");
        },
        onEnd: () {
          print("Banner所有广告位都加载失败");
        },
      ));
}

Widget build300150Banner(BuildContext context) {
  return GTAdsBannerWidget(
    //需要的广告位数组
      codes: [
        // 150高度
        GTAdsCode(alias: "csj", probability: 3,androidId: "103478259",iosId: "103475998"),
        GTAdsCode(alias: "ylh", probability: 10,androidId: "9116265903000255",iosId: "3166463913402394"),
        // 75高度
        // GTAdsCode(alias: "csj", probability: 6,androidId: "103478260",iosId: "103477981"),
        // GTAdsCode(alias: "ylh", probability: 10,androidId: "5156668913307244",iosId: "4126763933603341"),
      ],
      //宽
      width: MediaQuery.of(context).size.width,
      //高
      height: MediaQuery.of(context).size.width/6.4,
      //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
      timeout: 3,
      //广告加载模式 [GTAdsModel.RANDOM]优先级模式 [GTAdsModel.RANDOM]随机模式
      //默认随机模式
      model: GTAdsModel.RANDOM,
      //回调
      callBack: GTAdsCallBack(
        onShow: (code) {
          print("Banner显示 ${code.toJson()}");
        },
        onClick: (code) {
          print("Banner点击 ${code.toJson()}");
        },
        onFail: (code,message) {
          print("Banner错误 ${code?.toJson()} $message");
        },
        onClose: (code) {
          print("Banner关闭 ${code.toJson()}");
        },
        onTimeout: () {
          print("Banner加载超时");
        },
        onEnd: () {
          print("Banner所有广告位都加载失败");
        },
      ));
}
