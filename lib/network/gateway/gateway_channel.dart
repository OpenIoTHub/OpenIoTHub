import 'package:grpc/grpc.dart';

class Channel {
  static Future<ClientChannel> getGatewayChannel(String ip, int port) async {
    final channel = ClientChannel(ip,
        port: port,
        options: const ChannelOptions(
            credentials: ChannelCredentials.insecure()));
    return channel;
  }
}
