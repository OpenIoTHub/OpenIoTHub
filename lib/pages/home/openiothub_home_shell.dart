import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/home/openiothub_home_shell_desktop.dart';
import 'package:openiothub/app/providers/auth_provider.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 移动端：底部 Tab；桌面端：系统风格侧栏 + [StatefulNavigationShell] 多栈保留各 Tab 状态。
class OpenIoTHubHomeShell extends StatefulWidget {
  const OpenIoTHubHomeShell({super.key, required this.navigationShell});

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
    if (openIoTHubUseDesktopHomeLayout) {
      return OpenIoTHubDesktopHomeShell(navigationShell: shell);
    }
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

    final theme = Theme.of(context);
    final barTheme = theme.bottomNavigationBarTheme;
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: shell.currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: barTheme.selectedItemColor ?? theme.primaryColor,
        unselectedItemColor: barTheme.unselectedItemColor ?? Colors.grey,
        backgroundColor: barTheme.backgroundColor,
        elevation: barTheme.elevation ?? 8,
        selectedFontSize: barTheme.selectedLabelStyle?.fontSize ?? 12,
        unselectedFontSize: barTheme.unselectedLabelStyle?.fontSize ?? 11,
        selectedLabelStyle: barTheme.selectedLabelStyle,
        unselectedLabelStyle: barTheme.unselectedLabelStyle,
        showUnselectedLabels: true,
        enableFeedback: true,
        onTap:
            (index) => shell.goBranch(
              index,
              initialLocation: index == shell.currentIndex,
            ),
      ),
    );
  }
}
