import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';

void main() async {
  LoginInfo loginInfo = LoginInfo();
  loginInfo.userMobile = "17076241859";
  loginInfo.password = "123456";
  OperationResponse operationResponse = await UserManager.RegisterUserWithUserInfo(loginInfo);
  print(operationResponse);
}
