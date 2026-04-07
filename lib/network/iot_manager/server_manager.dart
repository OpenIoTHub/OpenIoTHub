import 'package:grpc/grpc.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pbgrpc.dart';

import 'package:openiothub/network/network_log.dart';

import 'iot_manager_channel.dart';

class ServerManager {
  // rpc addServer (ServerInfo) returns (OperationResponse) {}
  static Future<OperationResponse> addServer(ServerInfo serverInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.addServer(serverInfo);
    netLog('ServerManager', 'addServer: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc delServer (ServerInfo) returns (OperationResponse) {}
  static Future<OperationResponse> delServer(ServerInfo serverInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.delServer(serverInfo);
    netLog('ServerManager', 'delServer: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc updateServer (ServerInfo) returns (OperationResponse) {}
  static Future<OperationResponse> updateServer(ServerInfo serverInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.updateServer(serverInfo);
    netLog('ServerManager', 'updateServer: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc queryServer (StringValue) returns (ServerInfoList) {}
  static Future<ServerInfoList> queryServer(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    ServerInfoList serverInfoList = await stub.queryServer(stringValue);
    netLog('ServerManager', 'queryServer: $serverInfoList');
    channel.shutdown();
    return serverInfoList;
  }

  // rpc getAllServer (Empty) returns (ServerInfoList) {}
  static Future<ServerInfoList> getAllServer() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    ServerInfoList serverInfoList = await stub.getAllServer(empty);
    netLog('ServerManager', 'getAllServer: $serverInfoList');
    channel.shutdown();
    return serverInfoList;
  }

//    获取自己作为管理员的所有服务器
//   rpc getAllMyServers (Empty) returns (ServerInfoList) {}
  static Future<ServerInfoList> getAllMyServers() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    ServerInfoList serverInfoList = await stub.getAllMyServers(empty);
    netLog('ServerManager', 'getAllMyServers: $serverInfoList');
    channel.shutdown();
    return serverInfoList;
  }

//    获取别人分享给自己的所有服务器
//   rpc getAllMySharedServers (Empty) returns (ServerInfoList) {}
  static Future<ServerInfoList> getAllMySharedServers() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ServerManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    ServerInfoList serverInfoList = await stub.getAllMySharedServers(empty);
    netLog('ServerManager', 'getAllMySharedServers: $serverInfoList');
    channel.shutdown();
    return serverInfoList;
  }
}
