import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher_string.dart';

launchUrl(String url) async {
//    await intent.launch();
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    debugPrint('Could not launch $url');
  }
}
