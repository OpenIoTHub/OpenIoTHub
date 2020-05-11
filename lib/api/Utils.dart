import 'package:flutter/material.dart';
import 'Channel.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class UtilApi {
//获取本地的所有mdns列表
  static Future<MDNSServiceList> getAllmDNSServiceList() async {
    final channel = await Channel.getClientChannel();
    final stub = UtilsClient(channel);
    final response = await stub.getAllmDNSServiceList(Empty());
    channel.shutdown();
    print("===getAllmDNSServiceList：${response.mDNSServices}");
    return response;
  }

  //获取本地的指定条件的mdns列表
  static Future<MDNSServiceList> getOnemDNSServiceList(String type) async {
    final channel = await Channel.getClientChannel();
    final stub = UtilsClient(channel);
    StringValue sv = StringValue();
    sv.value = type;
    final response = await stub.getmDNSServiceListByType(sv);
    channel.shutdown();
    print("===getOnemDNSServiceList：${response.mDNSServices}");
    return response;
  }

//将形如：\228\184\178\229\143\163\232\189\172TCP的utf-8乱码转换成正常的中文
  static Future<String> convertOctonaryUtf8(String oldString) async {
    final channel = await Channel.getClientChannel();
    final stub = UtilsClient(channel);
    var stringValue = StringValue();
    stringValue.value = oldString;
    final response = await stub.convertOctonaryUtf8(stringValue);
    channel.shutdown();
    return response.value;
  }
}
