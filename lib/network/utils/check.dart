import 'package:openiothub/core/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//获取用户是否已经登录
Future<bool> userSignedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(SharedPreferencesKey.userTokenKey);
  return token != null && token.isNotEmpty;
}
