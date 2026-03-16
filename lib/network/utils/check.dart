import 'package:openiothub/core/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//获取用户是否已经登录
Future<bool> userSignedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(SharedPreferencesKey.userTokenKey) &&
      prefs.getString(SharedPreferencesKey.userTokenKey) != null &&
      !(prefs.getString(SharedPreferencesKey.userTokenKey)!.isEmpty)){
    return true;
  }
  return false;
}
