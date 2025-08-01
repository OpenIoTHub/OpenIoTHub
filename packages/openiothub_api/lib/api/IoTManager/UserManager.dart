import 'package:grpc/grpc.dart';
import 'package:openiothub_api/api/IoTManager/IoTManagerChannel.dart';
import 'package:openiothub_api/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pbgrpc.dart';

class UserManager {
//  注册用户
//  rpc RegisterUserWithUserInfo (LoginInfo) returns (OperationResponse) {}
  static Future<OperationResponse> RegisterUserWithUserInfo(
      LoginInfo loginInfo) async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel);
    OperationResponse operationResponse =
        await stub.registerUserWithLoginInfo(loginInfo);
    print('RegisterUserWithUserInfo: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

//  登录 获取Token
//  rpc LoginWithUserLoginInfo (LoginInfo) returns (UserLoginResponse) {}
  static Future<UserLoginResponse> LoginWithUserLoginInfo(
      LoginInfo loginInfo) async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel);
    UserLoginResponse userLoginResponse =
        await stub.loginWithUserLoginInfo(loginInfo);
    print('GetUserLoginResponse: ${userLoginResponse}');
    channel.shutdown();
    return userLoginResponse;
  }

//    使用微信登录账号获取jwt
//    rpc LoginWithWechatCode (StringValue) returns (UserLoginResponse) {}
  static Future<UserLoginResponse> LoginWithWechatCode(String code) async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel);
    StringValue stringValue = StringValue();
    stringValue.value = code;
    UserLoginResponse userLoginResponse =
        await stub.loginWithWechatCode(stringValue);
    print('GetUserLoginResponse: ${userLoginResponse}');
    channel.shutdown();
    return userLoginResponse;
  }

//    账号绑定微信
//    rpc BindWithWechatCode (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> BindWithWechatCode(String code) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = code;
    OperationResponse operationResponse =
        await stub.bindWithWechatCode(stringValue);
    print('GetUserLoginResponse: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

//    账号解绑微信
//   rpc UnbindWechat (Empty) returns (OperationResponse) {}
  static Future<OperationResponse> UnbindWechat() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    OperationResponse operationResponse = await stub.unbindWechat(empty);
    print('GetUserLoginResponse: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

//  rpc GetUserInfo (Empty) returns (UserInfo) {}
  static Future<UserInfo> GetUserInfo() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    UserInfo userInfo = await stub.getUserInfo(empty);
    print('UserInfo: ${userInfo}');
    channel.shutdown();
    return userInfo;
  }

  //    获取用户的微信信息
  // rpc GetUserWechatInfoByCode (StringValue) returns (WechatUserInfo) {}
  static Future<WechatUserInfo> GetUserWechatInfoByCode(String code) async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel);
    StringValue stringValue = StringValue();
    stringValue.value = code;
    WechatUserInfo wechatUserInfo =
        await stub.getUserWechatInfoByCode(stringValue);
    print('GetUserLoginResponse: ${wechatUserInfo}');
    channel.shutdown();
    return wechatUserInfo;
  }

//  更新用户信息
//  rpc UpdateUserNanme (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> UpdateUserNanme(
      StringValue stringValue) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserName(stringValue);
    print('UpdateUserNanme: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

//  rpc UpdateUserEmail (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> UpdateUserEmail(
      StringValue stringValue) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserEmail(stringValue);
    print('UpdateUserEmail: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

//  rpc UpdateUserMobile (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> UpdateUserMobile(
      StringValue stringValue) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserMobile(stringValue);
    print('UpdateUserMobile: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

//  rpc UpdateUserPassword (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> UpdateUserPassword(
      StringValue stringValue) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserPassword(stringValue);
    print('UpdateUserPassword: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

//  rpc UpdateUserAvatar (UpdateAvatar) returns (OperationResponse) {}
  static Future<OperationResponse> UpdateUserAvatar(
      UpdateAvatar updateAvatar) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserAvatar(updateAvatar);
    print('OperationResponse: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc GetAllConfig (Empty) returns (StringValue) {}
  static Future<StringValue> GetAllConfig() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    StringValue stringValue = await stub.getAllConfig(empty);
    print('GetAllConfig: ${stringValue}');
    channel.shutdown();
    return stringValue;
  }

  // rpc DeleteMyAccount (LoginInfo) returns (OperationResponse) {}
  static Future<OperationResponse> DeleteMyAccount(LoginInfo loginInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.deleteMyAccount(loginInfo);
    print('OperationResponse: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }
}
