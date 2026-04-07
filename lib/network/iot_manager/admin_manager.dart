import 'package:grpc/grpc.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/adminManager.pbgrpc.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';

import 'package:openiothub/network/network_log.dart';

import 'iot_manager_channel.dart';

class AdminManager {
//获取所有用户
// rpc getAllUser (Empty) returns (UserInfoList) {}
  static Future<UserInfoList> getAllUser() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = AdminManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    UserInfoList userInfoList = await stub.getAllUser(empty);
    netLog('AdminManager', 'getAllUser: $userInfoList');
    channel.shutdown();
    return userInfoList;
  }

//禁用一个用户(不可以禁用管理员)
// rpc banUser (UserInfo) returns (OperationResponse) {}
  static Future<OperationResponse> banUser(UserInfo userInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = AdminManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.banUser(userInfo);
    netLog('AdminManager', 'banUser: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }
}
