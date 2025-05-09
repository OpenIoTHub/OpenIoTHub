import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:openiothub/pages/homePage/all/homePage.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/splashPage/widgets/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/consts.dart';

class SplashAdPage extends StatefulWidget {
  const SplashAdPage({super.key});

  @override
  State<StatefulWidget> createState() => SplashAdPageState();
}

class SplashAdPageState extends State<SplashAdPage> {
  final String launchImage = "assets/images/splash/1.jpg";
  int _countdown = 1;
  late Timer _countdownTimer;

  bool? _init;
  String? _version;
  StreamSubscription? _adViewStream;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.initState();
    _startRecordTime();
    _initRegister();
    _adViewStream = FlutterUnionadStream.initAdStream(
      flutterUnionadFullVideoCallBack: FlutterUnionadFullVideoCallBack(
        onShow: () {
          print("全屏广告显示");
        },
        onSkip: () {
          print("全屏广告跳过");
        },
        onClick: () {
          print("全屏广告点击");
        },
        onFinish: () {
          print("全屏广告结束");
        },
        onFail: (error) {
          print("全屏广告错误 $error");
        },
        onClose: () {
          print("全屏广告关闭");
        },
      ),
      //插屏广告回调
      flutterUnionadInteractionCallBack: FlutterUnionadInteractionCallBack(
        onShow: () {
          print("插屏广告展示");
        },
        onClose: () {
          print("插屏广告关闭");
        },
        onFail: (error) {
          print("插屏广告失败 $error");
        },
        onClick: () {
          print("插屏广告点击");
        },
        onDislike: (message) {
          print("插屏广告不喜欢  $message");
        },
      ),
      // 新模板渲染插屏广告回调
      flutterUnionadNewInteractionCallBack:
      FlutterUnionadNewInteractionCallBack(onShow: () {
        print("新模板渲染插屏广告显示");
      }, onSkip: () {
        print("新模板渲染插屏广告跳过");
      }, onClick: () {
        print("新模板渲染插屏广告点击");
      }, onFinish: () {
        print("新模板渲染插屏广告结束");
      }, onFail: (error) {
        print("新模板渲染插屏广告错误 $error");
      }, onClose: () {
        print("新模板渲染插屏广告关闭");
      }, onReady: () async {
        print("新模板渲染插屏广告预加载准备就绪");
        //显示新模板渲染插屏
        await FlutterUnionad.showFullScreenVideoAdInteraction();
      }, onUnReady: () {
        print("新模板渲染插屏广告预加载未准备就绪");
      }, onEcpm: (info) {
        print("新模板渲染插屏广告ecpm $info");
      }),
      //激励广告
      flutterUnionadRewardAdCallBack: FlutterUnionadRewardAdCallBack(
          onShow: () {
            print("激励广告显示");
          }, onClick: () {
        print("激励广告点击");
      }, onFail: (error) {
        print("激励广告失败 $error");
      }, onClose: () {
        print("激励广告关闭");
      }, onSkip: () {
        print("激励广告跳过");
      }, onReady: () async {
        print("激励广告预加载准备就绪");
        await FlutterUnionad.showRewardVideoAd();
      }, onCache: () async {
        print("激励广告物料缓存成功。建议在这里进行广告展示，可保证播放流畅和展示流畅，用户体验更好。");
      }, onUnReady: () {
        print("激励广告预加载未准备就绪");
      }, onVerify: (rewardVerify, rewardAmount, rewardName, errorCode, error) {
        print(
            "激励广告奖励  验证结果=$rewardVerify 奖励=$rewardAmount  奖励名称$rewardName 错误码=$errorCode 错误$error");
      }, onRewardArrived: (rewardVerify, rewardType, rewardAmount, rewardName,
          errorCode, error, propose) {
        print(
            "阶段激励广告奖励  验证结果=$rewardVerify 奖励类型<FlutterUnionadRewardType>=$rewardType 奖励=$rewardAmount"
                "奖励名称$rewardName 错误码=$errorCode 错误$error 建议奖励$propose");
      }, onEcpm: (info) {
        print("激励广告 ecpm: $info");
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    print('启动页面结束');
    if (_countdownTimer.isActive) {
      _countdownTimer.cancel();
    }
  }

  void _startRecordTime() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown <= 1) {
//          Navigator.of(context).pushNamed("/demo1");
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MyHomePage(
              key: UniqueKey(),
              title: '',
            );
          }));
          _countdownTimer.cancel();
        } else {
          _countdown -= 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO 等待加载完成就切换到列表页或者等到超时；加载网络图片或者广告
    if (_init != null) {
      if (_countdownTimer.isActive){
        _countdownTimer.cancel();
      }
      return SplashPage();
    }
    return Scaffold(
      extendBody: true, //底部NavigationBar透明
      extendBodyBehindAppBar: true, //顶部Bar透明
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(child: Image.asset(launchImage, fit: BoxFit.fill)),
          Positioned(
            top: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                _countdown = 1;
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                child: RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: '$_countdown',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        )),
                    TextSpan(
                      text: OpenIoTHubLocalizations.of(context).skip_ad,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //注册
  void _initRegister() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey(Agreed_Privacy_Policy) || !(await prefs.getBool(Agreed_Privacy_Policy)!)){
      return;
    }
    _init = await FlutterUnionad.register(
      //穿山甲广告 Android appid 必填
        androidAppId: "5695020",
        //穿山甲广告 ios appid 必填
        iosAppId: "5695009",
        ohosAppId: "5638354",
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
          oaid: "0dd76120810c6946",
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
        ));
    setState(() {});
  }
}
