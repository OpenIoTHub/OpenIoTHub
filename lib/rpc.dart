import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

//API操作的工具函数
void runGrpc() async {
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