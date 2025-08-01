import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_common_pages/utils/goToUrl.dart';
import 'package:openiothub_common_pages/utils/toast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
// import 'package:tencent_kit/tencent_kit.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'package:openiothub_common_pages/openiothub_common_pages.dart';

class AppInfoPage extends StatefulWidget {
  AppInfoPage({required Key key}) : super(key: key);

  @override
  _AppInfoPageState createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  //APP名称
  String appName = "";

  //包名
  String packageName = "";

  //版本名
  String version = "";

  //版本号
  String buildNumber = "";

  // 微信分享
  late final StreamSubscription<WechatResp> _share;

  String share_success = "share success";
  String share_failed = "share failed";
  // QQ分享
  // late final StreamSubscription<TencentResp> _respSubs;
  // TencentLoginResp? _loginResp;

  void _listenShareMsg(WechatResp resp) {
    // final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
    if (resp.errorCode == 0) {
      show_success(share_success,context);
    } else {
      show_failed(share_failed,context);
    }
  }

  // void _listenLogin(TencentResp resp) {
  //   if (resp is TencentLoginResp) {
  //     _loginResp = resp;
  //     final String content = 'login: ${resp.openid} - ${resp.accessToken}';
  //     showToast('登录:$content');
  //   } else if (resp is TencentShareMsgResp) {
  //     // final String content = 'share: ${resp.ret} - ${resp.msg}';
  //     // showToast('分享:$content');
  //     if (resp.ret == 0) {
  //       showToast("分享成功！");
  //     } else {
  //       showToast("分享失败！");
  //     }
  //   }
  // }

  @override
  void initState() {
    _share = WechatKitPlatform.instance.respStream().listen(_listenShareMsg);
    // _respSubs = TencentKitPlatform.instance.respStream().listen(_listenLogin);
    super.initState();
    _getAppInfo();
  }

  @override
  void dispose() {
    _share.cancel();
    // _respSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.add("${OpenIoTHubCommonLocalizations.of(context).app_name}$appName");
    _result.add("${OpenIoTHubCommonLocalizations.of(context).package_name}$packageName");
    _result.add("${OpenIoTHubCommonLocalizations.of(context).version}$version");
    _result.add("${OpenIoTHubCommonLocalizations.of(context).version_sn}$buildNumber");
    _result.add("${OpenIoTHubCommonLocalizations.of(context).icp_number}皖ICP备2022013511号-2A");

    final tiles = _result.map(
      (pair) {
        return ListTile(
          title: Text(
            pair,
          ),
        );
      },
    );
    List<ListTile> tilesList = tiles.toList();
    tilesList.add(ListTile(
      title: Text(
        OpenIoTHubCommonLocalizations.of(context).feedback_channels,
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//              return Text("${pair.iP}:${pair.port}");
          return FeedbackPage(
            key: UniqueKey(),
          );
        }));
      },
    ));
    tilesList.add(ListTile(
      title: Text(
          OpenIoTHubCommonLocalizations.of(context).online_feedback,
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        launchURL("https://support.qq.com/product/657356");
      },
    ));
    tilesList.add(ListTile(
      title: Text(
        OpenIoTHubCommonLocalizations.of(context).privacy_policy,
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        goToURL(context, "https://docs.iothub.cloud/privacyPolicy/index.html",
            OpenIoTHubCommonLocalizations.of(context).privacy_policy);
      },
    ));
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tilesList,
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text(OpenIoTHubCommonLocalizations.of(context).app_info), actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.share,
              // color: Colors.white,
            ),
            onPressed: () {
              _shareAction();
            }),
      ]),
      body: ListView(children: divided),
    );
  }

  _getAppInfo() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
  }

  _shareAction() async {
    var title = OpenIoTHubCommonLocalizations.of(context).share_app_title;
    var description = OpenIoTHubCommonLocalizations.of(context).share_app_description;
    var url = "https://m.malink.cn/s/RNzqia";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubCommonLocalizations.of(context).share),
                content: Text(OpenIoTHubCommonLocalizations.of(context).share_to_where),
                actions: <Widget>[
                  Row(
                    children: [
                      TDButton(
                        icon: TDIcons.logo_wechat_stroke,
                        text: OpenIoTHubCommonLocalizations.of(context).share_to_wechat,
                        size: TDButtonSize.small,
                        type: TDButtonType.outline,
                        shape: TDButtonShape.rectangle,
                        theme: TDButtonTheme.primary,
                        onTap: () async {
                          if (!await WechatKitPlatform.instance.isInstalled()) {
                            show_failed(OpenIoTHubCommonLocalizations.of(context).wechat_not_installed, context);
                            return;
                          }
                          WechatKitPlatform.instance.shareWebpage(
                            scene: WechatScene.kSession,
                            title: title,
                            description: description,
                            // thumbData:,
                            webpageUrl: url,
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0), // 设置左边距离
                        child: TDButton(
                          icon: TDIcons.logo_wechat_stroke,
                          text: OpenIoTHubCommonLocalizations.of(context).share_on_moments,
                          size: TDButtonSize.small,
                          type: TDButtonType.outline,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                          onTap: () async {
                            if (!await WechatKitPlatform.instance
                                .isInstalled()) {
                              show_failed(OpenIoTHubCommonLocalizations.of(context).wechat_not_installed, context);
                              return;
                            }
                            WechatKitPlatform.instance.shareWebpage(
                              scene: WechatScene.kTimeline,
                              title: title,
                              description: description,
                              // thumbData:,
                              webpageUrl: url,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      // TDButton(
                      //   icon: TDIcons.logo_qq,
                      //   text: '分享到QQ',
                      //   size: TDButtonSize.small,
                      //   type: TDButtonType.outline,
                      //   shape: TDButtonShape.rectangle,
                      //   theme: TDButtonTheme.primary,
                      //   onTap: () async {
                      //     if (!await TencentKitPlatform.instance
                      //             .isQQInstalled() &&
                      //         !await TencentKitPlatform.instance
                      //             .isTIMInstalled()) {
                      //       showToast("QQ未安装！");
                      //       return;
                      //     }
                      //     TencentKitPlatform.instance.shareWebpage(
                      //       scene: TencentScene.kScene_QQ,
                      //       title: title,
                      //       summary: description,
                      //       targetUrl: url,
                      //     );
                      //     Navigator.of(context).pop();
                      //   },
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10.0), // 设置左边距离
                      //   child: TDButton(
                      //     icon: TDIcons.logo_qq,
                      //     text: '分享到QQ空间',
                      //     size: TDButtonSize.small,
                      //     type: TDButtonType.outline,
                      //     shape: TDButtonShape.rectangle,
                      //     theme: TDButtonTheme.primary,
                      //     onTap: () async {
                      //       if (!await TencentKitPlatform.instance
                      //               .isQQInstalled() &&
                      //           !await TencentKitPlatform.instance
                      //               .isTIMInstalled()) {
                      //         showToast("QQ未安装！");
                      //         return;
                      //       }
                      //       TencentKitPlatform.instance.shareWebpage(
                      //         scene: TencentScene.kScene_QZone,
                      //         title: title,
                      //         summary: description,
                      //         targetUrl: url,
                      //       );
                      //       Navigator.of(context).pop();
                      //     },
                      //   ),
                      // )
                    ],
                  )
                ]));
  }
}
