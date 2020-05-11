import 'package:flutter/material.dart';
import 'Channel.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class SessionApi {
//  TODO 可以选择grpc所执行的主机，可以是安卓本机也可以是pc，也可以是服务器
  static Future createOneSession(SessionConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.createOneSession(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

  static Future deleteOneSession(SessionConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = SessionManagerClient(channel);
    await stub.deleteOneSession(config);
    channel.shutdown();
  }

  static Future<SessionList> getAllSession() async {
    final channel = await Channel.getClientChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.getAllSession(new Empty());
    print('Greeter client received: ${response.sessionConfigs}');
    channel.shutdown();
    return response;
  }

  static Future<PortList> getAllTCP(SessionConfig sessionConfig) async {
    final channel = await Channel.getClientChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.getAllTCP(sessionConfig);
    print('Greeter client received: ${response.portConfigs}');
    channel.shutdown();
    return response;
  }

  static Future<Empty> refreshmDNSServices(SessionConfig sessionConfig) async {
    final channel = await Channel.getClientChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.refreshmDNSProxyList(sessionConfig);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
}
