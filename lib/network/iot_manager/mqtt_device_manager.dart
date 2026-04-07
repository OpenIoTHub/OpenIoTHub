import 'package:grpc/grpc.dart';
import 'package:openiothub/network/iot_manager/iot_manager_channel.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/mqttDeviceManager.pbgrpc.dart';
import 'package:openiothub/network/network_log.dart';

class MqttDeviceManager {
  // rpc AddMqttDevice (MqttDeviceInfo) returns (OperationResponse) {}
  static Future<OperationResponse> addMqttDevice(
      MqttDeviceInfo mqttDeviceInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = MqttDeviceManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.addMqttDevice(mqttDeviceInfo);
    netLog('MqttDeviceManager', 'addMqttDevice: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc delMqttDevice (MqttDeviceInfo) returns (OperationResponse) {}
  static Future<OperationResponse> delMqttDevice(
      MqttDeviceInfo mqttDeviceInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = MqttDeviceManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.delMqttDevice(mqttDeviceInfo);
    netLog('MqttDeviceManager', 'delMqttDevice: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc getAllMqttDevice (Empty) returns (MqttDeviceInfoList) {}
  static Future<MqttDeviceInfoList> getAllMqttDevice() async {
    String jwt = await getJWT();
    Empty empty = Empty();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = MqttDeviceManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    MqttDeviceInfoList mqttDeviceInfoList = await stub.getAllMqttDevice(empty);
    netLog('MqttDeviceManager', 'getAllMqttDevice: $mqttDeviceInfoList');
    channel.shutdown();
    return mqttDeviceInfoList;
  }

  // rpc generateMqttUsernamePassword (MqttDeviceInfo) returns (MqttInfo) {}
  static Future<MqttInfo> generateMqttUsernamePassword(
      MqttDeviceInfo mqttDeviceInfo) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = MqttDeviceManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    MqttInfo mqttInfo = await stub.generateMqttUsernamePassword(mqttDeviceInfo);
    netLog('MqttDeviceManager', 'generateMqttUsernamePassword: $mqttInfo');
    channel.shutdown();
    return mqttInfo;
  }
}
