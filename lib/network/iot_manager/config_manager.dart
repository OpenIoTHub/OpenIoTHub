import 'package:grpc/grpc.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/configManager.pbgrpc.dart';

import 'package:openiothub/network/network_log.dart';

import 'iot_manager_channel.dart';

class ConfigManager {
  //    普通配置一次性操作多个
  // rpc getUserConfigByKey (StringValue) returns (StringValue) {}
  static Future<StringValue> getUserConfigByKey(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValueKey = StringValue();
    stringValueKey.value = value;
    StringValue stringValue = await stub.getUserConfigByKey(stringValueKey);
    netLog('ConfigManager', 'getUserConfigByKey: $stringValue');
    channel.shutdown();
    return stringValue;
  }

  // rpc getAllUserConfig (Empty) returns (UserConfigMap) {}
  static Future<UserConfigMap> getAllUserConfig() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    UserConfigMap configMap = await stub.getAllUserConfig(empty);
    netLog('ConfigManager', 'getAllUserConfig: $configMap');
    channel.shutdown();
    return configMap;
  }

  //    创建或者更新
  // rpc setUserConfigByKey (UserConfigMap) returns (OperationResponse) {}
  static Future<OperationResponse> setUserConfigByKey(
      UserConfigMap userConfigMap) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.setUserConfigByKey(userConfigMap);
    netLog('ConfigManager', 'setUserConfigByKey: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  //    删除
  // rpc delAllUserConfig (UserConfigMap) returns (OperationResponse) {}
  static Future<OperationResponse> delAllUserConfig(
      UserConfigMap userConfigMap) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse =
        await stub.delAllUserConfig(userConfigMap);
    netLog('ConfigManager', 'delAllUserConfig: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }

  // rpc delUserConfigByKey (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> delUserConfigByKey(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = ConfigManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    OperationResponse operationResponse =
        await stub.delUserConfigByKey(stringValue);
    netLog('ConfigManager', 'delUserConfigByKey: $operationResponse');
    channel.shutdown();
    return operationResponse;
  }
}
