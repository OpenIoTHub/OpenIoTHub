import 'package:flutter/material.dart';
import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class Channel {
  static ClientChannel getClientChannel() {
    final channel = ClientChannel(Config.webgRpcIp,
        port: Config.webgRpcPort,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    return channel;
  }
}
