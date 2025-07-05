import 'package:flutter/cupertino.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:gtads/gtads.dart';
import 'package:gtads_ylh/gtads_ylh.dart';

Widget buildYLHBanner(){
  FlutterTencentAdBiddingController _bidding =
   FlutterTencentAdBiddingController();
  return FlutterTencentad.bannerAdView(
    //android广告id
    androidId: "5156668913307244",
    //ios广告id
    iosId: "4126763933603341",
    //广告宽 单位dp
    viewWidth: 500,
    //广告高  单位dp   宽高比应该为6.4:1
    viewHeight: 80,
    //下载二次确认弹窗 默认false
    downloadConfirm: true,
    //是否开启竞价 默认不开启
    isBidding: false,
    //竞价结果回传
    bidding: _bidding,
    // 广告回调
    callBack: FlutterTencentadBannerCallBack(
      onShow: () {
        print("Banner广告显示");
      },
      onFail: (code, message) {
        print("Banner广告错误 $code $message");
      },
      onClose: () {
        print("Banner广告关闭");
      },
      onExpose: () {
        print("Banner广告曝光");
      },
      onClick: () {
        print("Banner广告点击");
      }, onECPM: (ecpmLevel, ecpm) {
      print("Banner广告竞价  ecpmLevel=$ecpmLevel  ecpm=$ecpm");
      //规则 自己根据业务处理
      if (ecpm > 0) {
        //竞胜出价，类型为Integer
        //最大竞败方出价，类型为Integer
        _bidding.biddingResult(
            FlutterTencentBiddingResult().success(ecpm, 0));
      } else {
        //竞胜方出价（单位：分），类型为Integer
        //优量汇广告竞败原因 FlutterTencentAdBiddingLossReason
        //竞胜方渠道ID FlutterTencentAdADNID
        _bidding.biddingResult(FlutterTencentBiddingResult().fail(
            1000,
            FlutterTencentAdBiddingLossReason.LOW_PRICE,
            FlutterTencentAdADNID.othoerADN));
      }
    },
    ),
  );
}
