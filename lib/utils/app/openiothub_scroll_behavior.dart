import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

/// 按平台区分滚动物理效果：桌面指针滚动用阻尼/clamp，移动端保留弹性。
class OpenIoTHubScrollBehavior extends MaterialScrollBehavior {
  const OpenIoTHubScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    if (openIoTHubUseDesktopHomeLayout) {
      return const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      );
    }
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}
