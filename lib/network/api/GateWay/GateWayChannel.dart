import 'package:grpc/grpc.dart';

class Channel {
  static Future<ClientChannel> getGateWayChannel(String ip, int port) async {
    final channel = ClientChannel(ip,
        port: port,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    return channel;
  }
}
