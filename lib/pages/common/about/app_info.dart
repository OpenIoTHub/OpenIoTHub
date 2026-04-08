import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openiothub/pages/common/openiothub_common_pages.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
// import 'package:tencent_kit/tencent_kit.dart';
import 'package:wechat_kit/wechat_kit.dart';


class AppInfoPage extends StatefulWidget {
  const AppInfoPage({required Key key}) : super(key: key);

  @override
  State<AppInfoPage> createState() => AppInfoPageState();
}

class AppInfoPageState extends State<AppInfoPage> {
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

  String shareSuccess = "share success";
  String shareFailed = "share failed";
  // QQ分享
  // late final StreamSubscription<TencentResp> _respSubs;
  // TencentLoginResp? _loginResp;
  final githubRepo = "https://github.com/OpenIoTHub/OpenIoTHub";

  void _listenShareMsg(WechatResp resp) {
    // final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
    if (resp.errorCode == 0) {
      showSuccess(shareSuccess,context);
    } else {
      showFailed(shareFailed,context);
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
    final List result = [];
    result.add("${OpenIoTHubLocalizations.of(context).app_name}$appName");
    result.add("${OpenIoTHubLocalizations.of(context).package_name}$packageName");
    result.add("${OpenIoTHubLocalizations.of(context).version}$version");
    result.add("${OpenIoTHubLocalizations.of(context).version_sn}$buildNumber");
    result.add("${OpenIoTHubLocalizations.of(context).icp_number}皖ICP备2022013511号-2A");

    final tiles = result.map(
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
        OpenIoTHubLocalizations.of(context).github_repo,
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        launchUrl(githubRepo);
      },
    ));
    tilesList.add(ListTile(
      title: Text(
        OpenIoTHubLocalizations.of(context).common_feedback_channels,
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
          OpenIoTHubLocalizations.of(context).online_feedback,
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        launchUrl("https://support.qq.com/product/657356");
      },
    ));
    tilesList.add(ListTile(
      title: Text(
        OpenIoTHubLocalizations.of(context).common_privacy_policy,
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        goToUrl(context, "https://docs.iothub.cloud/privacyPolicy/index.html",
            OpenIoTHubLocalizations.of(context).common_privacy_policy);
      },
    ));
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tilesList,
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text(OpenIoTHubLocalizations.of(context).app_info), actions: <Widget>[
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
    var title = OpenIoTHubLocalizations.of(context).share_app_title;
    var description = OpenIoTHubLocalizations.of(context).share_app_description;
    var url = "https://m.malink.cn/s/RNzqia";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).share),
                content: Text(OpenIoTHubLocalizations.of(context).share_to_where),
                actions: <Widget>[
                  Row(
                    children: [
                      TDButton(
                        icon: TDIcons.logo_wechat_stroke,
                        text: OpenIoTHubLocalizations.of(context).share_to_wechat,
                        size: TDButtonSize.small,
                        type: TDButtonType.outline,
                        shape: TDButtonShape.rectangle,
                        theme: TDButtonTheme.primary,
                        onTap: () async {
                          final ctx = context;
                          final l10n = OpenIoTHubLocalizations.of(ctx);
                          if (!await WechatKitPlatform.instance.isInstalled()) {
                            if (!ctx.mounted) return;
                            showFailed(l10n.wechat_not_installed, ctx);
                            return;
                          }
                          WechatKitPlatform.instance.shareWebpage(
                            scene: WechatScene.kSession,
                            title: title,
                            description: description,
                            // thumbData:,
                            webpageUrl: url,
                          );
                          if (!ctx.mounted) return;
                          Navigator.of(ctx).pop();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0), // 设置左边距离
                        child: TDButton(
                          icon: TDIcons.logo_wechat_stroke,
                          text: OpenIoTHubLocalizations.of(context).share_on_moments,
                          size: TDButtonSize.small,
                          type: TDButtonType.outline,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                          onTap: () async {
                            final ctx = context;
                            final l10n = OpenIoTHubLocalizations.of(ctx);
                            if (!await WechatKitPlatform.instance
                                .isInstalled()) {
                              if (!ctx.mounted) return;
                              showFailed(l10n.wechat_not_installed, ctx);
                              return;
                            }
                            WechatKitPlatform.instance.shareWebpage(
                              scene: WechatScene.kTimeline,
                              title: title,
                              description: description,
                              // thumbData:,
                              webpageUrl: url,
                            );
                            if (!ctx.mounted) return;
                            Navigator.of(ctx).pop();
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
