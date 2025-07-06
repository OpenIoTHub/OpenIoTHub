import 'package:grpc/grpc.dart';
import 'package:openiothub_constants/openiothub_constants.dart';

class Channel {
  static Future<ClientChannel> getDefaultIoTManagerChannel() async {
    ClientChannel channel;
    channel = ClientChannel(
      Config.iotManagerGrpcIp,
      port: Config.iotManagerGrpcPort,
      // options: const ChannelOptions(
      //     credentials: const ChannelCredentials.insecure())
    );
    return channel;
  }
}
