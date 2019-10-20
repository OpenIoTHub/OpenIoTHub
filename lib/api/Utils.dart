import 'package:flutter/material.dart';
import 'Channel.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class UtilApi {
//获取本地的指定条件的mdns列表
  static Future<MDNSServiceList> getAllmDNSServiceList(
      MDNSService config) async {
    final channel = Channel.getClientChannel();
    final stub = UtilsClient(channel);
    final response = await stub.getAllmDNSServiceList(config);
    channel.shutdown();
    return response;
  }

//将形如：\228\184\178\229\143\163\232\189\172TCP的utf-8乱码转换成正常的中文
  static Future<String> convertOctonaryUtf8(String oldString) async {
    final channel = Channel.getClientChannel();
    final stub = UtilsClient(channel);
    var stringValue = StringValue();
    stringValue.value = oldString;
    final response = await stub.convertOctonaryUtf8(stringValue);
    channel.shutdown();
    return response.value;
  }
}
