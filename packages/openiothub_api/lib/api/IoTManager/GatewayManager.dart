import 'package:grpc/grpc.dart';
import 'package:openiothub_api/api/IoTManager/IoTManagerChannel.dart';
import 'package:openiothub_api/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pbgrpc.dart';

//  网关操作
class GatewayManager {
  // rpc AddGateway (GatewayInfo) returns (OperationResponse) {}
  static Future<OperationResponse> AddGateway(GatewayInfo gatewayInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.addGateway(gatewayInfo);
    print('RegisterUserWithUserInfo: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc DelGateway (GatewayInfo) returns (OperationResponse) {}
  static Future<OperationResponse> DelGateway(GatewayInfo gatewayInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.delGateway(gatewayInfo);
    print('RegisterUserWithUserInfo: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc UpdateGateway (GatewayInfo) returns (OperationResponse) {}
  static Future<OperationResponse> UpdateGateway(
      GatewayInfo gatewayInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.updateGateway(gatewayInfo);
    print('RegisterUserWithUserInfo: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc QueryGateway (GatewayInfo) returns (GatewayInfo) {}
  static Future<GatewayInfo> QueryGateway(GatewayInfo gatewayInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    GatewayInfo newGatewayInfo = await stub.queryGateway(gatewayInfo);
    print('RegisterUserWithUserInfo: ${newGatewayInfo}');
    channel.shutdown();
    return newGatewayInfo;
  }

  // rpc GetAllGateway (Empty) returns (GatewayInfoList) {}
  static Future<GatewayInfoList> GetAllGateway() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    GatewayInfoList gatewayInfoList = await stub.getAllGateway(empty);
    print('RegisterUserWithUserInfo: ${gatewayInfoList}');
    channel.shutdown();
    return gatewayInfoList;
  }

  // rpc GenerateOneGatewayWithDefaultServer (Empty) returns (GatewayInfo) {}
  static Future<GatewayInfo> GenerateOneGatewayWithDefaultServer() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    GatewayInfo gatewayInfo =
        await stub.generateOneGatewayWithDefaultServer(empty);
    print('RegisterUserWithUserInfo: ${gatewayInfo}');
    channel.shutdown();
    return gatewayInfo;
  }

  // rpc GenerateOneGatewayWithServerUuid (StringValue) returns (GatewayInfo) {}
  static Future<GatewayInfo> GenerateOneGatewayWithServerUuid(
      String uuid) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = uuid;
    GatewayInfo gatewayInfo =
        await stub.generateOneGatewayWithServerUuid(stringValue);
    print('RegisterUserWithUserInfo: ${gatewayInfo}');
    channel.shutdown();
    return gatewayInfo;
  }

  // rpc GetGatewayJwtByGatewayUuid (StringValue) returns (StringValue) {}
  static Future<StringValue> GetGatewayJwtByGatewayUuid(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    StringValue s = await stub.getGatewayJwtByGatewayUuid(stringValue);
    print('GetGatewayJwtByGatewayUuid: ${s}');
    channel.shutdown();
    return s;
  }

  // rpc GetOpenIoTHubJwtByGatewayUuid (StringValue) returns (StringValue) {}
  static Future<StringValue> GetOpenIoTHubJwtByGatewayUuid(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = GatewayManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    StringValue s = await stub.getOpenIoTHubJwtByGatewayUuid(stringValue);
    print('GetOpenIoTHubJwtByGatewayUuid: ${s}');
    channel.shutdown();
    return s;
  }
}
