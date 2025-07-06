import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';

void main() async {
  LoginInfo loginInfo = LoginInfo();
  loginInfo.userMobile = "17076241859";
  loginInfo.password = "123456";
  UserLoginResponse userLoginResponse = await UserManager.LoginWithUserLoginInfo(loginInfo);
  print(userLoginResponse.userInfo);
}
