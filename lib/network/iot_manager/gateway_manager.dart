import 'package:grpc/grpc.dart';
import 'package:openiothub/network/iot_manager/iot_manager_channel.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pbgrpc.dart';

//  网关操作
class GatewayManager {
  // rpc addGateway (GatewayInfo) returns (OperationResponse) {}
  static Future<OperationResponse> addGateway(GatewayInfo gatewayInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.addGateway(gatewayInfo);
    print('registerUserWithUserInfo: ${operationResponse}');
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
    print('registerUserWithUserInfo: ${operationResponse}');
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
    print('registerUserWithUserInfo: ${operationResponse}');
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
    print('registerUserWithUserInfo: ${newGatewayInfo}');
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
    print('registerUserWithUserInfo: ${gatewayInfoList}');
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
    print('registerUserWithUserInfo: ${gatewayInfo}');
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
    print('registerUserWithUserInfo: ${gatewayInfo}');
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
    print('getGatewayJwtByGatewayUuid: ${s}');
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
    print('getOpenIoTHubJwtByGatewayUuid: ${s}');
    channel.shutdown();
    return s;
  }
}
