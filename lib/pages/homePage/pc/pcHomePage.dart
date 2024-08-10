import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/mdnsService/mdnsServiceListPage.dart';
import 'package:openiothub/pages/user/profilePage.dart';
import 'package:openiothub_api/utils/check.dart';
import 'package:openiothub_common_pages/commPages/appInfo.dart';
import 'package:openiothub_common_pages/gateway/GatewayQrPage.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../commonDevice/commonDeviceListPage.dart';
import '../../gateway/gatewayListPage.dart';

class NavigationBodyItem extends StatelessWidget {
  const NavigationBodyItem({
    super.key,
    this.header,
    this.content,
  });

  final String? header;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: PageHeader(title: Text(header ?? 'This is a header text')),
      content: content ?? const SizedBox.shrink(),
    );
  }
}

class PcHomePage extends StatefulWidget {
  const PcHomePage({super.key, required this.title});

  final String title;

  @override
  State<PcHomePage> createState() => _PcHomePageState();
}

class _PcHomePageState extends State<PcHomePage> {
  int topIndex = 0; //默认第一个选中

  @override
  void initState() {
    super.initState();
    _goto_local_gateway();
  }

  @override
  Widget build(BuildContext context) {
    List<NavigationPaneItem> items = [
      PaneItem(
        icon: const Icon(TDIcons.home),
        title: Text(OpenIoTHubLocalizations.of(context).tab_smart),
        body: MdnsServiceListPage(
          title: OpenIoTHubLocalizations.of(context).tab_smart,
          key: UniqueKey(),
        ),
      ),
      PaneItem(
        icon: const Icon(TDIcons.internet),
        title: Text(OpenIoTHubLocalizations.of(context).tab_gateway),
        body: GatewayListPage(
          title: OpenIoTHubLocalizations.of(context).tab_gateway,
          key: UniqueKey(),
        ),
      ),
      PaneItem(
        icon: const Icon(TDIcons.desktop),
        title: Text(OpenIoTHubLocalizations.of(context).tab_host),
        body: CommonDeviceListPage(
          title: OpenIoTHubLocalizations.of(context).tab_host,
          key: UniqueKey(),
        ),
      ),
    ];
    return NavigationView(
      appBar: const NavigationAppBar(
        leading: Icon(FluentIcons.a_t_p_logo),
        title: Text('云亿连'),
      ),
      pane: NavigationPane(
        selected: topIndex,
        onChanged: (index) => setState(() => topIndex = index),
        displayMode: PaneDisplayMode.auto,
        items: items,
        footerItems: [
          PaneItem(
            icon: const Icon(TDIcons.user),
            title: Text(OpenIoTHubLocalizations.of(context).tab_user),
            body: const ProfilePage(),
          ),
          PaneItem(
            icon: const Icon(TDIcons.info_circle),
            title: const Text("关于"),
            body: AppInfoPage(key: UniqueKey()),
          ),
        ],
      ),
    );
  }

  Future<void> _goto_local_gateway() async {
    // 如果没有登陆并且是PC平台则跳转到本地网关页面
    bool userSignedIned = await userSignedIn();
    if (!userSignedIned &&
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        timer.cancel();
        Navigator.of(context).push(FluentPageRoute(builder: (context) {
          return GatewayQrPage(
            key: UniqueKey(),
          );
        }));
      });
    }
  }
}
