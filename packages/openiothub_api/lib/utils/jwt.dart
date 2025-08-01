// import 'package:fluttertoast/fluttertoast.dart';
import 'package:openiothub_api/utils/check.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getJWT() async {
  bool userSignedIned = await userSignedIn();
  if (!userSignedIned) {
    // Fluttertoast.showToast(msg: "您还没有登录!请先登录再添加设备");
    return "";
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferencesKey.USER_TOKEN_KEY)!;
  }
}
