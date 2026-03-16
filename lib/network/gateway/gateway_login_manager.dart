import 'package:openiothub/network/gateway/gateway_channel.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/gateway/gateway.pbgrpc.dart';

class GatewayLoginManager {
  static Future<LoginResponse> checkGatewayLoginStatus(
      String gatewayIp, int gatewayPort) async {
    final channel = await Channel.getGatewayChannel(gatewayIp, gatewayPort);
    final stub = GatewayLoginManagerClient(channel);
    LoginResponse loginResponse = await stub.checkGatewayLoginStatus(Empty());
    print('GetOpenIoTHubToken: ${loginResponse}');
    channel.shutdown();
    //未登录返回false，登录了返回true
    return loginResponse;
  }

  static Future<LoginResponse> loginServerByToken(
      String tokenValue, String gatewayIp, int gatewayPort) async {
    final channel = await Channel.getGatewayChannel(gatewayIp, gatewayPort);
    final stub = GatewayLoginManagerClient(channel);
    Token token = Token();
    token.value = tokenValue;
    LoginResponse loginResponse = await stub.loginServerByToken(token);
    print('LoginServerByServerInfo: ${loginResponse}');
    channel.shutdown();
    return loginResponse;
  }
}
