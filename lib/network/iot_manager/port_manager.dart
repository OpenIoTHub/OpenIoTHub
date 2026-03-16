import 'package:grpc/grpc.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/portManager.pbgrpc.dart';

import 'iot_manager_channel.dart';

class PortManager {
  // rpc getAllPorts (Empty) returns (PortInfoList) {}
  static Future<PortInfoList> getAllPorts() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = PortManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    PortInfoList portInfoList = await stub.getAllPorts(empty);
    print('getAllPorts: ${portInfoList}');
    channel.shutdown();
    return portInfoList;
  }

  // rpc addPort (PortInfo) returns (OperationResponse) {}
  static Future<OperationResponse> addPort(PortInfo portInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = PortManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.addPort(portInfo);
    print('addPort: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc updatePort (PortInfo) returns (OperationResponse) {}
  static Future<OperationResponse> updatePort(PortInfo portInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = PortManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.updatePort(portInfo);
    print('updatePort: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc delPort (PortInfo) returns (OperationResponse) {}
  static Future<OperationResponse> delPort(PortInfo portInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = PortManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.delPort(portInfo);
    print('delPort: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }
}
