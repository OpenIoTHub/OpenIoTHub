import 'package:grpc/grpc.dart';
import 'package:openiothub/network/iot_manager/iot_manager_channel.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pbgrpc.dart';
import 'package:openiothub/network/network_log.dart';

class UserManager {
//  注册用户
//  rpc registerUserWithUserInfo (LoginInfo) returns (OperationResponse) {}
  static Future<OperationResponse> registerUserWithUserInfo(
      LoginInfo loginInfo) async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel);
    OperationResponse operationResponse =
        await stub.registerUserWithLoginInfo(loginInfo);
    netLog('UserManager', 'registerUserWithUserInfo: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

//  登录 获取Token
//  rpc loginWithUserLoginInfo (LoginInfo) returns (UserLoginResponse) {}
  static Future<UserLoginResponse> loginWithUserLoginInfo(
      LoginInfo loginInfo) async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel);
    UserLoginResponse userLoginResponse =
        await stub.loginWithUserLoginInfo(loginInfo);
    netLog('UserManager', 'loginWithUserLoginInfo: $userLoginResponse');
    channel.shutdown();
    return userLoginResponse;
  }

//    使用微信登录账号获取jwt
//    rpc loginWithWechatCode (StringValue) returns (UserLoginResponse) {}
  static Future<UserLoginResponse> loginWithWechatCode(String code) async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel);
    StringValue stringValue = StringValue();
    stringValue.value = code;
    UserLoginResponse userLoginResponse =
        await stub.loginWithWechatCode(stringValue);
    netLog('UserManager', 'loginWithWechatCode: $userLoginResponse');
    channel.shutdown();
    return userLoginResponse;
  }

//    账号绑定微信
//    rpc bindWithWechatCode (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> bindWithWechatCode(String code) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = code;
    OperationResponse operationResponse =
        await stub.bindWithWechatCode(stringValue);
    netLog('UserManager', 'bindWithWechatCode: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

//    账号解绑微信
//   rpc unbindWechat (Empty) returns (OperationResponse) {}
  static Future<OperationResponse> unbindWechat() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    OperationResponse operationResponse = await stub.unbindWechat(empty);
    netLog('UserManager', 'unbindWechat: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

//  rpc getUserInfo (Empty) returns (UserInfo) {}
  static Future<UserInfo> getUserInfo() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    UserInfo userInfo = await stub.getUserInfo(empty);
    netLog('UserManager', 'getUserInfo: $userInfo');
    channel.shutdown();
    return userInfo;
  }

  //    获取用户的微信信息
  // rpc getUserWechatInfoByCode (StringValue) returns (WechatUserInfo) {}
  static Future<WechatUserInfo> getUserWechatInfoByCode(String code) async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel);
    StringValue stringValue = StringValue();
    stringValue.value = code;
    WechatUserInfo wechatUserInfo =
        await stub.getUserWechatInfoByCode(stringValue);
    netLog('UserManager', 'getUserWechatInfoByCode: $wechatUserInfo');
    channel.shutdown();
    return wechatUserInfo;
  }

//  更新用户信息
//  rpc updateUserName (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> updateUserName(
      StringValue stringValue) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserName(stringValue);
    netLog('UserManager', 'updateUserName: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

//  rpc updateUserEmail (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> updateUserEmail(
      StringValue stringValue) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserEmail(stringValue);
    netLog('UserManager', 'updateUserEmail: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

//  rpc updateUserMobile (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> updateUserMobile(
      StringValue stringValue) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserMobile(stringValue);
    netLog('UserManager', 'updateUserMobile: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

//  rpc updateUserPassword (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> updateUserPassword(
      StringValue stringValue) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserPassword(stringValue);
    netLog('UserManager', 'updateUserPassword: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

//  rpc updateUserAvatar (UpdateAvatar) returns (OperationResponse) {}
  static Future<OperationResponse> updateUserAvatar(
      UpdateAvatar updateAvatar) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.updateUserAvatar(updateAvatar);
    netLog('UserManager', 'updateUserAvatar: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc getAllConfig (Empty) returns (StringValue) {}
  static Future<StringValue> getAllConfig() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    StringValue stringValue = await stub.getAllConfig(empty);
    netLog('UserManager', 'getAllConfig: $stringValue');
    channel.shutdown();
    return stringValue;
  }

  // rpc deleteMyAccount (LoginInfo) returns (OperationResponse) {}
  static Future<OperationResponse> deleteMyAccount(LoginInfo loginInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = UserManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.deleteMyAccount(loginInfo);
    netLog('UserManager', 'deleteMyAccount: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }
}
