import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../web/web.dart';

launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    if (kDebugMode) {
      print('Could not launch $url');
    }
  }
}

goToURL(BuildContext context, String url, title) async {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    launchURL(url);
    return;
  }
  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
    return WebScreen(startUrl: url,title: title,);
  }));
}
