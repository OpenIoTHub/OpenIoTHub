import 'package:grpc/grpc.dart';
import 'package:openiothub_api/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/configManager.pbgrpc.dart';

import 'IoTManagerChannel.dart';

class ConfigManager {
  //    普通配置一次性操作多个
  // rpc GetUserConfigByKey (StringValue) returns (StringValue) {}
  static Future<StringValue> GetUserConfigByKey(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValueKey = StringValue();
    stringValueKey.value = value;
    StringValue stringValue = await stub.getUserConfigByKey(stringValueKey);
    print('GetUserConfigByKey: ${stringValue}');
    channel.shutdown();
    return stringValue;
  }

  // rpc GetAllUserConfig (Empty) returns (UserConfigMap) {}
  static Future<UserConfigMap> GetAllUserConfig() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    UserConfigMap configMap = await stub.getAllUserConfig(empty);
    print('GetAllUserConfig: ${configMap}');
    channel.shutdown();
    return configMap;
  }

  //    创建或者更新
  // rpc SetUserConfigByKey (UserConfigMap) returns (OperationResponse) {}
  static Future<OperationResponse> SetUserConfigByKey(
      UserConfigMap userConfigMap) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.setUserConfigByKey(userConfigMap);
    print('SetUserConfigByKey: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  //    删除
  // rpc DelAllUserConfig (UserConfigMap) returns (OperationResponse) {}
  static Future<OperationResponse> DelAllUserConfig(
      UserConfigMap userConfigMap) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.delAllUserConfig(userConfigMap);
    print('DelAllUserConfig: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc DelUserConfigByKey (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> DelUserConfigByKey(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    OperationResponse operationResponse =
        await stub.delUserConfigByKey(stringValue);
    print('DelUserConfigByKey: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }
}
