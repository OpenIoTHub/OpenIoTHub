import 'package:grpc/grpc.dart';
import 'package:openiothub_api/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/adminManager.pbgrpc.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';

import 'IoTManagerChannel.dart';

class AdminManager {
//获取所有用户
// rpc GetAllUser (Empty) returns (UserInfoList) {}
  static Future<UserInfoList> GetAllUser() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = AdminManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    UserInfoList userInfoList = await stub.getAllUser(empty);
    print('GetAllUser: ${userInfoList}');
    channel.shutdown();
    return userInfoList;
  }

//禁用一个用户(不可以禁用管理员)
// rpc BanUser (UserInfo) returns (OperationResponse) {}
  static Future<OperationResponse> BanUser(UserInfo userInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = AdminManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.banUser(userInfo);
    print('GetAllUser: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }
}
