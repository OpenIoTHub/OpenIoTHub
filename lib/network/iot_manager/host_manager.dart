import 'package:grpc/grpc.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/hostManager.pbgrpc.dart';

import 'iot_manager_channel.dart';

class HostManager {
  // rpc getAllHosts (Empty) returns (HostInfoList) {}
  static Future<HostInfoList> getAllHosts() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = HostManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    HostInfoList hostInfoList = await stub.getAllHosts(empty);
    print('getAllHosts: ${hostInfoList}');
    channel.shutdown();
    return hostInfoList;
  }

  // rpc AddHost (HostInfo) returns (OperationResponse) {}
  static Future<OperationResponse> addHost(HostInfo hostInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = HostManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse hostInfoList = await stub.addHost(hostInfo);
    print('OperationResponse: ${hostInfoList}');
    channel.shutdown();
    return hostInfoList;
  }

  // rpc updateHost (HostInfo) returns (OperationResponse) {}
  static Future<OperationResponse> updateHost(HostInfo hostInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = HostManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse hostInfoList = await stub.updateHost(hostInfo);
    print('OperationResponse: ${hostInfoList}');
    channel.shutdown();
    return hostInfoList;
  }

  // rpc delHost (HostInfo) returns (OperationResponse) {}
  static Future<OperationResponse> delHost(HostInfo hostInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = HostManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse hostInfoList = await stub.delHost(hostInfo);
    print('delHost: ${hostInfoList}');
    channel.shutdown();
    return hostInfoList;
  }

  // rpc setDeviceMac (HostInfo) returns (OperationResponse) {}
  static Future<OperationResponse> setDeviceMac(HostInfo hostInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = HostManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse hostInfoList = await stub.setDeviceMac(hostInfo);
    print('setDeviceMac: ${hostInfoList}');
    channel.shutdown();
    return hostInfoList;
  }
}
