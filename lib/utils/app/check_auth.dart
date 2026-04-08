import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:openiothub/core/storage/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> agreedPrivacyPolicy() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  bool agreed = prefs.getBool(SharedPreferencesKey.agreedPrivacyPolicy) != null
      ? prefs.getBool(SharedPreferencesKey.agreedPrivacyPolicy)!
      : false;
  return agreed;
}

Future<bool> userSignedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(SharedPreferencesKey.userTokenKey) &&
      prefs.getString(SharedPreferencesKey.userTokenKey) != null &&
      prefs.getString(SharedPreferencesKey.userTokenKey)!.isNotEmpty){
    // 判断Token有没有过期，过期则删除Token
    var jwt = prefs.getString(SharedPreferencesKey.userTokenKey)!;
    if (JwtDecoder.isExpired(jwt)){
      prefs.remove(SharedPreferencesKey.userTokenKey);
      return false;
    }
    return true;
  }
  return false;
}
