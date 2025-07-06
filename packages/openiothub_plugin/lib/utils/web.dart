import 'package:url_launcher/url_launcher_string.dart';

launchURL(String url) async {
//    await intent.launch();
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    print('Could not launch $url');
  }
}
