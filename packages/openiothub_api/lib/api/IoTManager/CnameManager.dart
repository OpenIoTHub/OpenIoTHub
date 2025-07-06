import 'package:grpc/grpc.dart';
import 'package:openiothub_api/utils/jwt.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/cnameManager.pbgrpc.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'IoTManagerChannel.dart';

class CnameManager {
  //    普通配置一次性操作多个
  // rpc GetCnameByKey (StringValue) returns (StringValue) {}
  static Future<StringValue> GetCnameByKey(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValueKey = StringValue();
    stringValueKey.value = value;
    StringValue stringValue = await stub.getCnameByKey(stringValueKey);
    print('GetCnameByKey: ${stringValue}');
    channel.shutdown();
    return stringValue;
  }

  // rpc GetAllCname (Empty) returns (CnameMap) {}
  static Future<CnameMap> GetAllCname() async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    Empty empty = Empty();
    CnameMap cnameMap = await stub.getAllCname(empty);
    print('GetAllCname: ${cnameMap}');
    channel.shutdown();
    return cnameMap;
  }

  //    创建或者更新
  // rpc SetCnameByKey (CnameMap) returns (OperationResponse) {}
  static Future<OperationResponse> SetCnameByKey(CnameMap cnameMap) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.setCnameByKey(cnameMap);
    print('SetCnameByKey: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  //    删除
  // rpc DelAllCname (CnameMap) returns (OperationResponse) {}
  static Future<OperationResponse> DelAllCname(CnameMap cnameMap) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    OperationResponse operationResponse = await stub.delAllCname(cnameMap);
    print('DelAllCname: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  // rpc DelCnameByKey (StringValue) returns (OperationResponse) {}
  static Future<OperationResponse> DelCnameByKey(String value) async {
    String jwt = await getJWT();
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = CnameManagerClient(channel,
        options: CallOptions(metadata: {'jwt': jwt}));
    StringValue stringValue = StringValue();
    stringValue.value = value;
    OperationResponse operationResponse = await stub.delCnameByKey(stringValue);
    print('DelCnameByKey: ${operationResponse}');
    channel.shutdown();
    return operationResponse;
  }

  //本地的操作接口(结合本地和远程接口)
  static Future<void> LoadAllCnameFromRemote() async {
    CnameMap c = await GetAllCname();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    c.config.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  static Future<String> GetCname(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey(key)) {
      return prefs.getString(key)!;
    }
    StringValue c = await GetCnameByKey(key);
    prefs.setString(key, c.value);
    return c.value;
  }

  static Future<void> SetCname(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    CnameMap cnameMap = CnameMap();
    cnameMap.config.addAll({key: value});
    SetCnameByKey(cnameMap);
  }
}
