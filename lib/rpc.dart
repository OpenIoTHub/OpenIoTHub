import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

//API操作的工具函数
//SessionClient
void createOneSession(SessionConfig config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new SessionClient(channel);
  try {
    final response = await stub.createOneSession(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void deleteOneSession(OneSession config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new SessionClient(channel);
  try {
    final response = await stub.deleteOneSession(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void getAllSession() async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new SessionClient(channel);
  try {
    final response = await stub.getAllSession(new Empty());
    print('Greeter client received: ${response.sessionConfigs}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

//TCPClient
void createOneTCP(TCPConfig config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new TCPClient(channel);
  try {
    final response = await stub.createOneTCP(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void deleteOneTCP(TCPConfig config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new TCPClient(channel);
  try {
    final response = await stub.deleteOneTCP(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void getAllTCP() async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new TCPClient(channel);
  try {
    final response = await stub.getAllTCP(new Empty());
    print('Greeter client received: ${response.tCPConfigs}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

//UDPClient
void createOneUDP(UDPConfig config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new UDPClient(channel);
  try {
    final response = await stub.createOneUDP(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void deleteOneUDP(UDPConfig config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new UDPClient(channel);
  try {
    final response = await stub.deleteOneUDP(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void getAllUDP() async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new UDPClient(channel);
  try {
    final response = await stub.getAllUDP(new Empty());
    print('Greeter client received: ${response.uDPConfigs}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

//HTTPClient
void createOneHTTP(HTTPConfig config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new HTTPClient(channel);
  try {
    final response = await stub.createOneHTTP(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void deleteOneHTTP(HTTPConfig config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new HTTPClient(channel);
  try {
    final response = await stub.deleteOneHTTP(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void getAllHTTP() async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new HTTPClient(channel);
  try {
    final response = await stub.getAllHTTP(new Empty());
    print('Greeter client received: ${response.hTTPConfigs}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

//FTPClient
void createOneFTP(FTPConfig config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new FTPClient(channel);
  try {
    final response = await stub.createOneFTP(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void deleteOneFTP(FTPConfig config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new FTPClient(channel);
  try {
    final response = await stub.deleteOneFTP(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void getAllFTP() async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new FTPClient(channel);
  try {
    final response = await stub.getAllFTP(new Empty());
    print('Greeter client received: ${response.fTPConfigs}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

//SOCKS5Client
void createOneSOCKS5(SOCKS5Config config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new SOCKS5Client(channel);
  try {
    final response = await stub.createOneSOCKS5(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void deleteOneSOCKS5(SOCKS5Config config) async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new SOCKS5Client(channel);
  try {
    final response = await stub.deleteOneSOCKS5(config);
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}

void getAllSOCKS5() async {
  final channel = new ClientChannel('localhost',
      port: 2080,
      options: const ChannelOptions(
          credentials: const ChannelCredentials.insecure()));
  final stub = new SOCKS5Client(channel);
  try {
    final response = await stub.getAllSOCKS5(new Empty());
    print('Greeter client received: ${response.sOCKS5Configs}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}