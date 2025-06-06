import 'package:openiothub_constants/constants/SharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/consts.dart';

Future<bool> agreedPrivacyPolicy() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  bool agreed = prefs.getBool(Agreed_Privacy_Policy) != null
      ? prefs.getBool(Agreed_Privacy_Policy)!
      : false;
  return agreed;
}

Future<bool> userSignedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(SharedPreferencesKey.USER_TOKEN_KEY) &&
      prefs.getString(SharedPreferencesKey.USER_TOKEN_KEY) != null &&
      prefs.getString(SharedPreferencesKey.USER_TOKEN_KEY)!.isNotEmpty){
    return true;
  }
  return false;
}
