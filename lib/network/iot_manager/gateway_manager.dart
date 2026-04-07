import 'package:grpc/grpc.dart';
import 'package:openiothub/network/iot_manager/iot_manager_channel.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pbgrpc.dart';
import 'package:openiothub/network/network_log.dart';

//  网关操作
class GatewayManager {
  // rpc addGateway (GatewayInfo) returns (OperationResponse) {}
  static Future<OperationResponse> addGateway(GatewayInfo gatewayInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.addGateway(gatewayInfo);
    netLog('GatewayManager', 'addGateway: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc delGateway (GatewayInfo) returns (OperationResponse) {}
  static Future<OperationResponse> delGateway(GatewayInfo gatewayInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.delGateway(gatewayInfo);
    netLog('GatewayManager', 'delGateway: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc updateGateway (GatewayInfo) returns (OperationResponse) {}
  static Future<OperationResponse> updateGateway(
      GatewayInfo gatewayInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.updateGateway(gatewayInfo);
    netLog('GatewayManager', 'updateGateway: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc queryGateway (GatewayInfo) returns (GatewayInfo) {}
  static Future<GatewayInfo> queryGateway(GatewayInfo gatewayInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    GatewayInfo newGatewayInfo = await stub.queryGateway(gatewayInfo);
    netLog('GatewayManager', 'queryGateway: $newGatewayInfo');
    channel.shutdown();
    return newGatewayInfo;
  }

  // rpc getAllGateway (Empty) returns (GatewayInfoList) {}
  static Future<GatewayInfoList> getAllGateway() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    GatewayInfoList gatewayInfoList = await stub.getAllGateway(empty);
    netLog('GatewayManager', 'getAllGateway: $gatewayInfoList');
    channel.shutdown();
    return gatewayInfoList;
  }

  // rpc generateOneGatewayWithDefaultServer (Empty) returns (GatewayInfo) {}
  static Future<GatewayInfo> generateOneGatewayWithDefaultServer() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    GatewayInfo gatewayInfo =
        await stub.generateOneGatewayWithDefaultServer(empty);
    netLog('GatewayManager', 'generateOneGatewayWithDefaultServer: $gatewayInfo');
    channel.shutdown();
    return gatewayInfo;
  }

  // rpc generateOneGatewayWithServerUuid (StringValue) returns (GatewayInfo) {}
  static Future<GatewayInfo> generateOneGatewayWithServerUuid(
      String uuid) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = uuid;
    GatewayInfo gatewayInfo =
        await stub.generateOneGatewayWithServerUuid(stringValue);
    netLog('GatewayManager', 'generateOneGatewayWithServerUuid: $gatewayInfo');
    channel.shutdown();
    return gatewayInfo;
  }

  // rpc getGatewayJwtByGatewayUuid (StringValue) returns (StringValue) {}
  static Future<StringValue> getGatewayJwtByGatewayUuid(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    StringValue s = await stub.getGatewayJwtByGatewayUuid(stringValue);
    netLog('GatewayManager', 'getGatewayJwtByGatewayUuid: $s');
    channel.shutdown();
    return s;
  }

  // rpc getOpenIoTHubJwtByGatewayUuid (StringValue) returns (StringValue) {}
  static Future<StringValue> getOpenIoTHubJwtByGatewayUuid(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    StringValue s = await stub.getOpenIoTHubJwtByGatewayUuid(stringValue);
    netLog('GatewayManager', 'getOpenIoTHubJwtByGatewayUuid: $s');
    channel.shutdown();
    return s;
  }
}
