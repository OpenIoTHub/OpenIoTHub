import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/util/ThemeUtils.dart';
import 'package:openiothub/widgets/BuildGlobalActions.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/findGatewayGoList.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../widgets/ads/banner_gtads.dart';
import './mDNSServiceListPage.dart';

class GatewayListPage extends StatefulWidget {
  const GatewayListPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  _GatewayListPageState createState() => _GatewayListPageState();
}

class _GatewayListPageState extends State<GatewayListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;

  List<SessionConfig> _SessionList = [];
  late Timer _timerPeriod;

  @override
  void initState() {
    super.initState();
    getAllSession();
    _timerPeriod = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      getAllSession();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timerPeriod.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _SessionList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: pair.name[0],
            shape: TDAvatarShape.square,
            backgroundColor: Color.fromRGBO(
              Random().nextInt(156) + 50, // 随机生成0到255之间的整数
              Random().nextInt(156) + 50, // 随机生成0到255之间的整数
              Random().nextInt(156) + 50, // 随机生成0到255之间的整数
              1, // 不透明度，1表示完全不透明
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                  "${pair.name.substring(0, pair.name.length > 20 ? 20 : pair.name.length)}${pair.name.length > 20 ? "..." : ""}(${pair.description.substring(0, pair.description.length > 10 ? 10 : pair.description.length)}${pair.description.length > 10 ? "..." : ""})",
                  style: Constants.titleTextStyle),
            ],
          ),
          subtitle: pair.statusToClient ||
                  pair.statusP2PAsClient ||
                  pair.statusP2PAsServer
              ? TDTag(
                    OpenIoTHubLocalizations.of(context).online,
                    theme: TDTagTheme.success,
                    // isOutline: true,
                    isLight: true,
                    fixedWidth: 100,
                  )
              : TDTag(
                    OpenIoTHubLocalizations.of(context).offline,
                    theme: TDTagTheme.danger,
                    // isOutline: true,
                    isLight: true,
                    fixedWidth: 100,
                  ),
          trailing: Constants.rightArrowIcon,
        );
        return InkWell(
          onTap: () {
            _pushmDNSServices(pair);
          },
          child: listItemContent,
        );
      },
    );
    final divided = ListView.separated(
      // padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      itemCount: tiles.length+1,
      itemBuilder: (context, index) {
        if(index == 0){
          return build30075Banner();
        }
        return tiles.elementAt(index-1);
      },
      separatorBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 70), // 添加左侧缩进
          child: TDDivider(),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: build_actions(context),
      ),
      body: RefreshIndicator(
        onRefresh: getAllSession,
        child: tiles.isNotEmpty
            ? divided
            : Column(children: [
                ThemeUtils.isDarkMode(context)
                    ? Center(
                        child:
                            Image.asset('assets/images/empty_list_black.png'),
                      )
                    : Center(
                        child: Image.asset('assets/images/empty_list.png'),
                      ),
                Text(OpenIoTHubLocalizations.of(context)
                    .please_use_the_magnifying_glass_in_the_upper_right_corner),
              ]),
      ),
    );
  }

  void _pushmDNSServices(SessionConfig config) async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return MDNSServiceListPage(
            sessionConfig: config,
            key: UniqueKey(),
          );
        },
      ),
    ).then((result) {
      setState(() {
        getAllSession();
      });
    });
  }

  void _pushFindmDNSClientListPage() async {
//:TODO    这里显示内网的服务，socks5等，右上角详情才展示详细信息
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return FindGatewayGoListPage(
            key: UniqueKey(),
          );
        },
      ),
    ).then((result) {
      setState(() {
        // showToast( "我返回回来了");
        getAllSession();
      });
    });
  }

  Future createOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.createOneSession(config);
      print('Greeter client received: $response');
    } catch (e) {
      print('Caught error: $e');
    }
  }

  void deleteOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.deleteOneSession(config);
      print('Greeter client received: $response');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title:
                      Text(OpenIoTHubLocalizations.of(context).delete_result),
                  content: SizedBox.expand(
                      child: Text(OpenIoTHubLocalizations.of(context)
                          .delete_successful)),
                  actions: <Widget>[
                    TextButton(
                      child: Text(OpenIoTHubLocalizations.of(context).confirm),
                      onPressed: () {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    )
                  ])).then((result) {
        if (!context.mounted) return;
        Navigator.of(context).pop();
      });
    } catch (e) {
      print('Caught error: $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title:
                      Text(OpenIoTHubLocalizations.of(context).delete_result),
                  content: SizedBox.expand(
                      child: Text(
                          "${OpenIoTHubLocalizations.of(context).delete_failed}:$e")),
                  actions: <Widget>[
                    TextButton(
                      child: Text(OpenIoTHubLocalizations.of(context).cancel),
                      onPressed: () {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(OpenIoTHubLocalizations.of(context).confirm),
                      onPressed: () {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  Future<void> getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('Greeter client received: ${response.sessionConfigs}');
      setState(() {
        _SessionList = response.sessionConfigs;
      });
    } catch (e) {
      print('Caught error: $e');
    }
    return;
  }

  Future refreshmDNSServices(SessionConfig sessionConfig) async {
    try {
      await SessionApi.refreshmDNSServices(sessionConfig);
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }
}
