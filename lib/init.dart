import 'dart:async';
import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub/util/check/check.dart' as check;
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_mobile_service/openiothub_mobile_service.dart'
    as openiothub_mobile_service;

// import 'package:tencent_kit/tencent_kit.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:flutter_unionad/flutter_unionad.dart';

Future<void> init() async {
  initBackgroundService();
  initHttpAssets();
  initWechat();
  initQQ();
  // initSystemUi();
  loadConfig();
  // setWindowSize();
}

Future<void> initBackgroundService() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool("foreground", true);
  openiothub_mobile_service.run();
}

Future<void> initHttpAssets() async {
  final server =
      Jaguar(address: Config.webStaticIp, port: Config.webStaticPort);
  server.addRoute(serveFlutterAssets());
  server.serve(logRequests: true).then((v) {
    server.log.onRecord.listen((r) => debugPrint("==serve-log：$r"));
  });
}

Future<void> initWechat() async {
  bool agreed = await check.agreedPrivacyPolicy();
  // 如果同意了隐私政策或者不是安卓平台则初始化wechat_kit
  if (agreed || Platform.isIOS) {
    WechatKitPlatform.instance.registerApp(
      appId: WeChatConfig.WECHAT_APPID,
      universalLink: WeChatConfig.WECHAT_UNIVERSAL_LINK,
    );
  }
}

Future<void> initQQ() async {
  // bool agreed = await agreedPrivacyPolicy();
  // // 如果同意了隐私政策或者不是安卓平台则初始化wechat_kit
  // if (agreed || Platform.isIOS) {
  //   await TencentKitPlatform.instance.setIsPermissionGranted(granted: true);
  //   await TencentKitPlatform.instance.registerApp(
  //         appId: QQConfig.QQ_APPID, universalLink: QQConfig.QQ_UNIVERSAL_LINK);
  // }
}

Future<void> initSystemUi() async {
  // SystemChrome.setEnabledSystemUIMode([SystemUiOverlay.top] as SystemUiMode);
  //安卓透明状态栏
  // if (Platform.isAndroid) {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // 导航栏下面的控制栏的颜色
      systemNavigationBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // }
}

Future<void> loadConfig() async {
  if (!(await check.userSignedIn())) {
    return;
  }
  // Future.delayed(const Duration(milliseconds: 500), () {
  //   UtilApi.SyncConfigWithToken().then((OpenIoTHubOperationResponse rsp) {
  //     // showToast( rsp.msg);
  //   });
  // });
  // CnameManager.LoadAllCnameFromRemote();
  // TODO 后面也可以定时同步
  CnameManager.LoadAllCnameFromRemote().then((_) => {
        UserManager.GetAllConfig().then((StringValue config) => {
              UtilApi.Ping()
                  .then((_) => {UtilApi.SyncConfigWithJsonConfig(config.value)})
            })
      });
  // TODO 通知UI进行刷新
}

Future setWindowSize() async {
  Size size = await DesktopWindow.getWindowSize();
  print("windows size:$size");
  await DesktopWindow.setWindowSize(Size(500, 500));
}

Future initAD() async {
  await FlutterUnionad.register(
    //穿山甲广告 Android appid 必填
      androidAppId: "5695020",
      //穿山甲广告 ios appid 必填
      iosAppId: "5695009",
      //appname 必填
      appName: "云亿连",
      //使用聚合功能一定要打开此开关，否则不会请求聚合广告，默认这个值为false
      //true使用GroMore下的广告位
      //false使用广告变现下的广告位
      useMediation: true,
      //是否为计费用户 选填
      paid: false,
      //用户画像的关键词列表 选填
      keywords: "",
      //是否允许sdk展示通知栏提示 选填
      allowShowNotify: true,
      //是否显示debug日志
      debug: true,
      //是否支持多进程 选填
      supportMultiProcess: false,
      //主题模式 默认FlutterUnionAdTheme.DAY,修改后需重新调用初始化
      themeStatus: FlutterUnionAdTheme.DAY,
      //允许直接下载的网络状态集合 选填
      directDownloadNetworkType: [
        FlutterUnionadNetCode.NETWORK_STATE_2G,
        FlutterUnionadNetCode.NETWORK_STATE_3G,
        FlutterUnionadNetCode.NETWORK_STATE_4G,
        FlutterUnionadNetCode.NETWORK_STATE_WIFI
      ],
      androidPrivacy: AndroidPrivacy(
        //是否允许SDK主动使用地理位置信息 true可以获取，false禁止获取。默认为true
        isCanUseLocation: false,
        //当isCanUseLocation=false时，可传入地理位置信息，穿山甲sdk使用您传入的地理位置信息lat
        lat: 0.0,
        //当isCanUseLocation=false时，可传入地理位置信息，穿山甲sdk使用您传入的地理位置信息lon
        lon: 0.0,
        // 是否允许SDK主动使用手机硬件参数，如：imei
        isCanUsePhoneState: false,
        //当isCanUsePhoneState=false时，可传入imei信息，穿山甲sdk使用您传入的imei信息
        imei: "",
        // 是否允许SDK主动使用ACCESS_WIFI_STATE权限
        isCanUseWifiState: false,
        // 当isCanUseWifiState=false时，可传入Mac地址信息
        macAddress: "",
        // 是否允许SDK主动使用WRITE_EXTERNAL_STORAGE权限
        isCanUseWriteExternal: false,
        // 开发者可以传入oaid
        oaid: "b69cd3cf68900323",
        // 是否允许SDK主动获取设备上应用安装列表的采集权限
        alist: false,
        // 是否能获取android ID
        isCanUseAndroidId: false,
        // 开发者可以传入android ID
        androidId: "",
        // 是否允许SDK在申明和授权了的情况下使用录音权限
        isCanUsePermissionRecordAudio: false,
        // 是否限制个性化推荐接口
        isLimitPersonalAds: false,
        // 是否启用程序化广告推荐 true启用 false不启用
        isProgrammaticRecommend: false,
      ),
      iosPrivacy: IOSPrivacy(
        //允许个性化广告
        limitPersonalAds: false,
        //允许程序化广告
        limitProgrammaticAds: false,
        //允许CAID
        forbiddenCAID: false,
      )
  );
}
