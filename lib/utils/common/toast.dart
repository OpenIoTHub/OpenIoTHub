import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

showSuccess(String msg, BuildContext context) {
  TDMessage.showMessage(
    context: context,
    content: msg,
    visible: true,
    icon: true,
    theme: MessageTheme.success,
    duration: 3000,
    onDurationEnd: () {},
  );
}

showFailed(String msg, BuildContext context) {
  TDMessage.showMessage(
    context: context,
    content: msg,
    visible: true,
    icon: true,
    theme: MessageTheme.error,
    duration: 3000,
    onDurationEnd: () {},
  );
}

showInfo(String msg, BuildContext context) {
  TDMessage.showMessage(
    context: context,
    content: msg,
    visible: true,
    icon: true,
    theme: MessageTheme.info,
    duration: 3000,
    onDurationEnd: () {},
  );
}
