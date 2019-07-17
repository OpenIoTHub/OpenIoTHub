import 'package:flutter/material.dart';
import 'Channel.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class UtilApi {
  static Future<MDNSServiceList> getAllmDNSServiceList(MDNSService config) async {
    final channel = Channel.getClientChannel();
    final stub = UtilsClient(channel);
    final response = await stub.getAllmDNSServiceList(config);
    channel.shutdown();
    return response;
  }
}
