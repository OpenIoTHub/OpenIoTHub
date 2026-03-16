import 'package:grpc/grpc.dart';
import 'package:openiothub/network/openiothub/session_api.dart';
import 'package:openiothub/network/openiothub/utils.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

import '../utils/ip.dart';

class Channel {
  static Future<ClientChannel> getServerChannel(String runId) async {
    SessionConfig sessionConfig = await SessionApi.getOneSession(runId);
    TokenModel tokenModel = await UtilApi.getTokenModel(sessionConfig.token);
    final ChannelCredentials credentials = isIp(tokenModel.host) ? const ChannelCredentials.insecure() : const ChannelCredentials.secure();
    final channel = ClientChannel(
      tokenModel.host,
      port: tokenModel.grpcPort,
      options: ChannelOptions(
          credentials: credentials)
    );
    return channel;
  }
}
