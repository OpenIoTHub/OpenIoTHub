import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/consts.dart';

Future<bool> agreedPrivacyPolicy() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  bool agreed = prefs.getBool(Agreed_Privacy_Policy) != null
      ? prefs.getBool(Agreed_Privacy_Policy)!
      : false;
  return agreed;
}
