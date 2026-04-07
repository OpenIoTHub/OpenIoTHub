import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 桌面端 / 开屏后主页：底部 Tab + [StatefulNavigationShell] 多栈保留各 Tab 状态。
class OpenIoTHubHomeShell extends StatefulWidget {
  const OpenIoTHubHomeShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<OpenIoTHubHomeShell> createState() => _OpenIoTHubHomeShellState();
}

class _OpenIoTHubHomeShellState extends State<OpenIoTHubHomeShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthProvider>().loadCurrentToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shell = widget.navigationShell;
    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(TDIcons.internet),
        label: OpenIoTHubLocalizations.of(context).tab_gateway,
      ),
      BottomNavigationBarItem(
        icon: const Icon(TDIcons.desktop),
        label: OpenIoTHubLocalizations.of(context).tab_host,
      ),
      BottomNavigationBarItem(
        icon: const Icon(TDIcons.control_platform),
        label: OpenIoTHubLocalizations.of(context).tab_smart,
      ),
      BottomNavigationBarItem(
        icon: const Icon(TDIcons.user),
        label: OpenIoTHubLocalizations.of(context).tab_user,
      ),
    ];

    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: shell.currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => shell.goBranch(
          index,
          initialLocation: index == shell.currentIndex,
        ),
      ),
    );
  }
}
