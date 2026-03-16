import 'package:grpc/grpc.dart';
import 'package:openiothub/network/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/cnameManager.pbgrpc.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'iot_manager_channel.dart';

class CnameManager {
  //    普通配置一次性操作多个
  // rpc getCnameByKey (StringValue) returns (StringValue) {}
  static Future<StringValue> getCnameByKey(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValueKey = StringValue();
    stringValueKey.value = value;
    StringValue stringValue = await stub.getCnameByKey(stringValueKey);
    print('getCnameByKey: ${stringValue}');
    channel.shutdown();
    return stringValue;
  }

  // rpc getAllCname (Empty) returns (CnameMap) {}
  static Future<CnameMap> getAllCname() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    CnameMap cnameMap = await stub.getAllCname(empty);
    print('getAllCname: ${cnameMap}');
    channel.shutdown();
    return cnameMap;
  }

  //    创建或者更新
  // rpc setCnameByKey (CnameMap) returns (OperationResponse) {}
  static Future<OperationResponse> setCnameByKey(CnameMap cnameMap) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.setCnameByKey(cnameMap);
    print('setCnameByKey: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  //    删除
  // rpc delAllCname (CnameMap) returns (OperationResponse) {}
  static Future<OperationResponse> delAllCname(CnameMap cnameMap) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.delAllCname(cnameMap);
    print('delAllCname: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc delCnameByKey (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> delCnameByKey(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    OperationResponse operationResponse = await stub.delCnameByKey(stringValue);
    print('delCnameByKey: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  //本地的操作接口(结合本地和远程接口)
  static Future<void> loadAllCnameFromRemote() async {
    CnameMap c = await getAllCname();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    c.config.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  static Future<String> getCname(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey(key)) {
      return prefs.getString(key)!;
    }
    StringValue c = await getCnameByKey(key);
    prefs.setString(key, c.value);
    return c.value;
  }

  static Future<void> setCname(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    CnameMap cnameMap = CnameMap();
    cnameMap.config.addAll({key: value});
    setCnameByKey(cnameMap);
  }
}
