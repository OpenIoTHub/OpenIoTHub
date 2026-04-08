import 'package:flutter/material.dart';
import 'package:openiothub/app/providers/auth_provider.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:provider/provider.dart';

/// 根路径 `/` 的占位页：仅展示加载状态；登录态跳转由 go_router 的 redirect 处理。
class InitialRoute extends StatefulWidget {
  const InitialRoute({super.key});

  @override
  State<InitialRoute> createState() => _InitialRouteState();
}

class _InitialRouteState extends State<InitialRoute> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isLoading) {
        authProvider.loadCurrentToken();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          body: openIoTHubDesktopConstrainedBody(
            maxWidth: 400,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
