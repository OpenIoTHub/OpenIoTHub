import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../web/web.dart';

launchUrl(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    if (kDebugMode) {
      debugPrint('Could not launch $url');
    }
  }
}

goToUrl(BuildContext context, String url, title) async {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    launchUrl(url);
    return;
  }
  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
    return WebScreen(startUrl: url,title: title,);
  }));
}
