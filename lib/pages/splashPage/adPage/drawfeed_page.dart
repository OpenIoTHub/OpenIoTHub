import 'package:flutter/material.dart';
import 'package:flutter_unionad/drawfeedad/DrawFeedAdView.dart';
import 'package:flutter_unionad/flutter_unionad.dart';

/// 描述：draw视频广告
/// @author guozi
/// @e-mail gstory0404@gmail.com
/// @time   2020/3/11

class DrawFeedPage extends StatefulWidget {
  @override
  _DrawFeedPageState createState() => _DrawFeedPageState();
}

class _DrawFeedPageState extends State<DrawFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "draw视频广告",
        ),
      ),
      body: PageView.custom(
        scrollDirection: Axis.vertical,
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return FlutterUnionadDrawFeedAdView(
                androidCodeId: "102734241",
                iosCodeId: "102734241",
                //是否支持 DeepLink 选填
                width: MediaQuery.of(context).size.width,
                // 期望view 宽度 dp 必填
                height: 800.5,
                //是否静音
                isMuted: false,
                callBack: FlutterUnionadDrawFeedCallBack(
                  onShow: () {
                    print("draw广告显示");
                  },
                  onFail: (error) {
                    print("draw广告加载失败 $error");
                  },
                  onClick: () {
                    print("draw广告点击");
                  },
                  onDislike: (message) {
                    print("draw点击不喜欢 $message");
                  },
                  onVideoPlay: () {
                    print("draw视频播放");
                  },
                  onVideoPause: () {
                    print("draw视频暂停");
                  },
                  onVideoStop: () {
                    print("draw视频结束");
                  },
                  onEcpm: (info) {
                    print("draw视频ecpm $info");
                  },
                ),
              );
            }
            return Center(
              child: FlutterUnionad.drawFeedAdView(
                androidCodeId: "102734241",
                // Android draw视屏广告id 必填
                iosCodeId: "102734241",
                //ios draw视屏广告id 必填
                supportDeepLink: true,
                //是否支持 DeepLink 选填
                expressViewWidth: 600.5,
                // 期望view 宽度 dp 必填
                expressViewHeight: 800.5,
                //控制下载APP前是否弹出二次确认弹窗
                downloadType: FlutterUnionadDownLoadType.DOWNLOAD_TYPE_POPUP,
                //用于标注此次的广告请求用途为预加载（当做缓存）还是实时加载，
                adLoadType: FlutterUnionadLoadType.LOAD,
                //期望view高度 dp 必填
                callBack: FlutterUnionadDrawFeedCallBack(
                  onShow: () {
                    print("draw广告显示");
                  },
                  onFail: (error) {
                    print("draw广告加载失败 $error");
                  },
                  onClick: () {
                    print("draw广告点击");
                  },
                  onDislike: (message) {
                    print("draw点击不喜欢 $message");
                  },
                  onVideoPlay: () {
                    print("draw视频播放");
                  },
                  onVideoPause: () {
                    print("draw视频暂停");
                  },
                  onVideoStop: () {
                    print("draw视频结束");
                  },
                ),
              ),
            );
          },
          childCount: 3,
        ),
      ),
    );
  }
}
