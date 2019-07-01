import 'package:flutter/material.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class SessionApi {
  static ClientChannel getClientChannel() {
    final channel = ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    return channel;
  }
  static Future createOneSession(SessionConfig config) async {
    final channel = getClientChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.createOneSession(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

  static Future deleteOneSession(SessionConfig config) async {
    final channel = getClientChannel();
    final stub = SessionManagerClient(channel);
    await stub.deleteOneSession(config);
    channel.shutdown();
  }

  static Future<SessionList> getAllSession() async {
    final channel = getClientChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.getAllSession(new Empty());
    print('Greeter client received: ${response.sessionConfigs}');
    channel.shutdown();
    return response;
  }

  static Future<PortList> getAllTCP(SessionConfig sessionConfig) async {
    final channel = getClientChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.getAllTCP(sessionConfig);
    print('Greeter client received: ${response.portConfigs}');
    channel.shutdown();
    return response;
  }

  static Future<Empty> refreshmDNSServices(SessionConfig sessionConfig) async {
    final channel = getClientChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.refreshmDNSProxyList(sessionConfig);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
}
