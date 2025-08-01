import 'package:grpc/grpc.dart';
import 'package:openiothub_api/api/IoTManager/IoTManagerChannel.dart';
import 'package:openiothub_api/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/mqttDeviceManager.pbgrpc.dart';

class MqttDeviceManager {
  // rpc AddMqttDevice (MqttDeviceInfo) returns (OperationResponse) {}
  static Future<OperationResponse> AddMqttDevice(
      MqttDeviceInfo mqttDeviceInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = MqttDeviceManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.addMqttDevice(mqttDeviceInfo);
    print('OperationResponse: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc DelMqttDevice (MqttDeviceInfo) returns (OperationResponse) {}
  static Future<OperationResponse> DelMqttDevice(
      MqttDeviceInfo mqttDeviceInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = MqttDeviceManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.delMqttDevice(mqttDeviceInfo);
    print('OperationResponse: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc GetAllMqttDevice (Empty) returns (MqttDeviceInfoList) {}
  static Future<MqttDeviceInfoList> GetAllMqttDevice() async {
    String jwt = await getJWT();
    Empty empty = Empty();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = MqttDeviceManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    MqttDeviceInfoList mqttDeviceInfoList = await stub.getAllMqttDevice(empty);
    print('MqttDeviceInfoList: ${mqttDeviceInfoList}');
    channel.shutdown();
    return mqttDeviceInfoList;
  }

  // rpc GenerateMqttUsernamePassword (MqttDeviceInfo) returns (MqttInfo) {}
  static Future<MqttInfo> GenerateMqttUsernamePassword(
      MqttDeviceInfo mqttDeviceInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = MqttDeviceManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    MqttInfo mqttInfo = await stub.generateMqttUsernamePassword(mqttDeviceInfo);
    print('MqttInfo: ${mqttInfo}');
    channel.shutdown();
    return mqttInfo;
  }
}
