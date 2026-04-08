import 'package:flutter/widgets.dart';

/// 根 [Navigator]，用于 [GoRouter]；子路由可通过 [GoRoute.parentNavigatorKey] 将全屏页叠在底部 Tab 之上。
final GlobalKey<NavigatorState> openIoTHubRootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'openIoTHubRoot');
