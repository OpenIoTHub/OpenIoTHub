import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

class Constants {
  static final double ARROW_ICON_WIDTH = 16.0;
  static final titleTextStyle = const TextStyle(fontSize: 16.0);
  static final rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  static final String redirectUrl = "http://nat-cloud.com/osc/osc.php";

  static final String loginUrl =
      "https://www.iotserv.com/action/oauth2/authorize?client_id=4rWcDXCNTV5gMWxtagxI&response_type=code&redirect_uri=" +
          redirectUrl;

  static final String oscClientID = "4rWcDXCNTV5gMWxtagxI";

  static final String endLineTag = "COMPLETE";

  static final EventBus eventBus = new EventBus();
}
