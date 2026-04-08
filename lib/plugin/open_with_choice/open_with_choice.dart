import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub/common_pages/web/web.dart';
import 'package:openiothub/plugin/mdns_service/services/aria2c.dart' show Aria2Page;
import 'package:openiothub/plugin/mdns_service/services/nas/casa_zima_os/casaos_login.dart'
    show CasaLoginPage;
import 'package:openiothub/plugin/mdns_service/services/nas/casa_zima_os/zima_login.dart'
    show ZimaLoginPage;
import 'package:openiothub/plugin/mdns_service/services/nas/unraid/login.dart'
    show UnraidLoginPage;
import 'package:openiothub/plugin/mdns_service/services/ssh/ssh_page.dart'
    show SSHNativePage;
import 'package:openiothub/plugin/mdns_service/services/vncrfb_web_page.dart'
    show VNCWebPage;
import 'package:openiothub/plugin/registry/plugin_navigation.dart';
import 'package:openiothub/plugin/utils/port_config_to_port_service.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:openiothub/utils/openiothub_desktop_layout.dart';

enum _OpenWithChoiceKind {
  web,
  aria2,
  ssh,
  vnc,
  rdp,
  casaos,
  zimaos,
  unraid,
}

String _choiceLabel(OpenIoTHubLocalizations l10n, _OpenWithChoiceKind k) {
  switch (k) {
    case _OpenWithChoiceKind.web:
      return l10n.web_browser;
    case _OpenWithChoiceKind.aria2:
      return l10n.open_with_aria2;
    case _OpenWithChoiceKind.ssh:
      return l10n.open_with_ssh;
    case _OpenWithChoiceKind.vnc:
      return l10n.open_with_vnc;
    case _OpenWithChoiceKind.rdp:
      return l10n.rdp_remote_desktop;
    case _OpenWithChoiceKind.casaos:
      return l10n.open_with_casaos;
    case _OpenWithChoiceKind.zimaos:
      return l10n.open_with_zimaos;
    case _OpenWithChoiceKind.unraid:
      return l10n.open_with_unraid;
  }
}

class OpenWithChoice extends StatelessWidget {
  const OpenWithChoice({super.key, required this.portConfig});

  final PortConfig portConfig;

  static const String _tagStart = 'startDivider';
  static const String _tagEnd = 'endDivider';
  static const String _tagCenter = 'centerDivider';
  static const String _tagBlank = 'blankDivider';

  static const double _imageIconWidth = 30.0;
  static const String _rowIcon = 'assets/images/ic_discover_nearby.png';

  static const List<Object> _rows = <Object>[
    _tagBlank,
    _tagStart,
    _OpenWithChoiceKind.web,
    _tagCenter,
    _OpenWithChoiceKind.aria2,
    _tagCenter,
    _OpenWithChoiceKind.ssh,
    _tagCenter,
    _OpenWithChoiceKind.vnc,
    _tagCenter,
    _OpenWithChoiceKind.rdp,
    _tagCenter,
    _OpenWithChoiceKind.casaos,
    _tagCenter,
    _OpenWithChoiceKind.zimaos,
    _tagCenter,
    _OpenWithChoiceKind.unraid,
    _tagEnd,
  ];

  Widget _iconImage(String path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: Image.asset(path, width: _imageIconWidth, height: _imageIconWidth),
    );
  }

  Future<void> _pushPluginThenDismiss(
    BuildContext ctx,
    String modelId,
  ) async {
    final service = portConfig2portService(portConfig);
    final opened = await ctx.pushPluginPage(modelId, service);
    if (opened) {
      if (ctx.mounted) Navigator.of(ctx).pop();
    } else {
      debugPrint('OpenWithChoice: no plugin registered for modelId=$modelId');
    }
  }

  Future<void> _handleChoice(BuildContext ctx, _OpenWithChoiceKind kind) async {
    switch (kind) {
      case _OpenWithChoiceKind.aria2:
        await _pushPluginThenDismiss(ctx, Aria2Page.modelName);
      case _OpenWithChoiceKind.ssh:
        await _pushPluginThenDismiss(ctx, SSHNativePage.modelName);
      case _OpenWithChoiceKind.vnc:
        await _pushPluginThenDismiss(ctx, VNCWebPage.modelName);
      case _OpenWithChoiceKind.web:
        final webUrl = 'http://${Config.webgRpcIp}:${portConfig.localProt}';
        if (Platform.isLinux) {
          await _launchUrl(webUrl);
          if (ctx.mounted) Navigator.of(ctx).pop();
        } else {
          final nav = Navigator.of(ctx);
          nav.pop();
          nav.push<void>(
            MaterialPageRoute<void>(
              builder: (routeCtx) => WebScreen(startUrl: webUrl),
            ),
          );
        }
      case _OpenWithChoiceKind.rdp:
        final url =
            'rdp://full%20address=s:${Config.webgRpcIp}:${portConfig.localProt}&audiomode=i:2&disable%20themes=i:1';
        await _launchUrl(url);
        if (ctx.mounted) Navigator.of(ctx).pop();
      case _OpenWithChoiceKind.casaos:
        await _pushPluginThenDismiss(ctx, CasaLoginPage.modelName);
      case _OpenWithChoiceKind.zimaos:
        await _pushPluginThenDismiss(ctx, ZimaLoginPage.modelName);
      case _OpenWithChoiceKind.unraid:
        await _pushPluginThenDismiss(ctx, UnraidLoginPage.modelName);
    }
  }

  Widget _renderRow(BuildContext ctx, Object item) {
    if (item is String) {
      switch (item) {
        case _tagStart:
        case _tagEnd:
          return const Divider(height: 1.0);
        case _tagCenter:
          return Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
            child: Divider(height: 1.0),
          );
        case _tagBlank:
          return const SizedBox(height: 20.0);
        default:
          return const Divider(height: 1.0);
      }
    }
    if (item is _OpenWithChoiceKind) {
      final l10n = OpenIoTHubLocalizations.of(ctx);
      final title = _choiceLabel(l10n, item);
      final listItemContent = Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Row(
          children: <Widget>[
            _iconImage(_rowIcon),
            Expanded(
              child: Text(title, style: Constants.titleTextStyle),
            ),
            Constants.rightArrowIcon,
          ],
        ),
      );
      return InkWell(
        onTap: () => _handleChoice(ctx, item),
        child: listItemContent,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _rows.length,
      itemBuilder: (ctx, i) => _renderRow(ctx, _rows[i]),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}

/// 展示映射端口的「打开方式」对话框。
///
/// 关闭后若 [context] 仍 [mounted]，则执行 [onDialogClosed]（例如刷新端口列表）。
Future<void> showOpenWithChoiceDialog(
  BuildContext context, {
  required PortConfig portConfig,
  Future<void> Function()? onDialogClosed,
}) async {
  await showDialog<void>(
    context: context,
    builder: (dialogCtx) {
      final mq = MediaQuery.sizeOf(dialogCtx);
      final desktop = openIoTHubUseDesktopHomeLayout;
      return AlertDialog(
        title: Text(OpenIoTHubLocalizations.of(context).opening_method),
        content: desktop
            ? SizedBox(
                width: 420,
                height: math.min(520, mq.height * 0.72),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: OpenWithChoice(portConfig: portConfig),
                ),
              )
            : SizedBox.expand(
                child: OpenWithChoice(portConfig: portConfig),
              ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(OpenIoTHubLocalizations.of(context).cancel),
          ),
        ],
      );
    },
  );
  if (onDialogClosed != null && context.mounted) {
    await onDialogClosed();
  }
}
