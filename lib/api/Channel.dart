import 'package:flutter/material.dart';
import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';
import 'package:openiothub/constants/Config.dart';
import 'package:openiothub/pb/service.pb.dart';
import 'package:openiothub/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class Channel {
  static Future<ClientChannel> getClientChannel() async {
    final channel = ClientChannel(Config.webgRpcIp,
        port: Config.webgRpcPort,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    try {
      await channel.getConnection();
    } catch (e) {
      await FlutterNatcloudService.start();
      return ClientChannel(Config.webgRpcIp,
          port: Config.webgRpcPort,
          options: const ChannelOptions(
              credentials: const ChannelCredentials.insecure()));
    }
    return channel;
  }
}
