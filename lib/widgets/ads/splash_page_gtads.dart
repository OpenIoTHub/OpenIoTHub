import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:gtads/gtads.dart';

import '../../configs/var.dart';
import '../../pages/homePage/all/homePage.dart';

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
    return GTAdsSplashWidget(
            //需要的广告位组
            codes: [
              //GTAdsModel.PRIORITY时 当前广告位的优先级数值越大越优先加载（当加载失败后从剩余广告中按数值大小依次重试）
              //GTAdsModel.RANDOM时 当前广告位出现的概率必须大于0,如果小于0则不会加载该广告,数值越大出现的概率越高（当加载失败后从剩余广告中重新随机加载）
              GTAdsCode(alias: "csj", probability: 5,androidId: "103477524",iosId: "103476284"),
              GTAdsCode(alias: "ylh", probability: 6,androidId: "3196566963809258",iosId: "4106962923009357"),
            ],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
            timeout: 2,
            //广告加载模式 [GTAdsModel.PRIORITY]优先级模式 [GTAdsModel.RANDOM]随机模式
            //默认随机模式
            model: GTAdsModel.RANDOM,
            callBack: GTAdsCallBack(
              onShow: (code) {
                print("开屏显示 ${code.toJson()}");
              },
              onClick: (code) {
                print("开屏点击 ${code.toJson()}");
              },
              onFail: (code, message) {
                print("开屏错误 ${code?.toJson()} $message");
                Navigator.pop(context);
              },
              onClose: (code) {
                print("开屏关闭 ${code.toJson()}");
                Navigator.pop(context);
              },
              onTimeout: () {
                print("开屏加载超时");
                Navigator.pop(context);
              },
              onEnd: () {
                print("开屏所有广告位都加载失败");
                Navigator.pop(context);
              },
            ),
          );
  }
}
