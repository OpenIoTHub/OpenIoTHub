
import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

show_success(String msg, BuildContext context) {
  TDMessage.showMessage(
    context: context,
    content: msg,
    visible: true,
    icon: false,
    theme: MessageTheme.success,
    duration: 3000,
    onDurationEnd: () {
      print('message end');
    },
  );
}

show_failed(String msg, BuildContext context) {
  TDMessage.showMessage(
    context: context,
    content: msg,
    visible: true,
    icon: false,
    theme: MessageTheme.error,
    duration: 3000,
    onDurationEnd: () {
      print('message end');
    },
  );
}