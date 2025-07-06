import 'package:grpc/grpc.dart';
import 'package:openiothub_api/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pbgrpc.dart';

import 'IoTManagerChannel.dart';

class ServerManager {
  // rpc AddServer (ServerInfo) returns (OperationResponse) {}
  static Future<OperationResponse> AddServer(ServerInfo serverInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.addServer(serverInfo);
    print('AddServer: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc DelServer (ServerInfo) returns (OperationResponse) {}
  static Future<OperationResponse> DelServer(ServerInfo serverInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.delServer(serverInfo);
    print('DelServer: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc UpdateServer (ServerInfo) returns (OperationResponse) {}
  static Future<OperationResponse> UpdateServer(ServerInfo serverInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.updateServer(serverInfo);
    print('UpdateServer: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc QueryServer (StringValue) returns (ServerInfoList) {}
  static Future<ServerInfoList> QueryServer(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    ServerInfoList serverInfoList = await stub.queryServer(stringValue);
    print('QueryServer: ${serverInfoList}');
    channel.shutdown();
    return serverInfoList;
  }

  // rpc GetAllServer (Empty) returns (ServerInfoList) {}
  static Future<ServerInfoList> GetAllServer() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    ServerInfoList serverInfoList = await stub.getAllServer(empty);
    print('GetAllServer: ${serverInfoList}');
    channel.shutdown();
    return serverInfoList;
  }

//    获取自己作为管理员的所有服务器
//   rpc GetAllMyServers (Empty) returns (ServerInfoList) {}
  static Future<ServerInfoList> GetAllMyServers() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    ServerInfoList serverInfoList = await stub.getAllMyServers(empty);
    print('GetAllServer: ${serverInfoList}');
    channel.shutdown();
    return serverInfoList;
  }

//    获取别人分享给自己的所有服务器
//   rpc GetAllMySharedServers (Empty) returns (ServerInfoList) {}
  static Future<ServerInfoList> GetAllMySharedServers() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    ServerInfoList serverInfoList = await stub.getAllMySharedServers(empty);
    print('GetAllServer: ${serverInfoList}');
    channel.shutdown();
    return serverInfoList;
  }
}
