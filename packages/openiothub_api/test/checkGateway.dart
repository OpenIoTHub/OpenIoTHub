import 'package:openiothub_grpc_api/proto/gateway/gateway.pb.dart';

import 'package:openiothub_api/openiothub_api.dart';

void main() async {
  String ip = "iotserv-desktop.local";
  int port = 38825;
  LoginResponse loginResponse = await GatewayLoginManager.CheckGatewayLoginStatus(ip, port);
  print(loginResponse.message);
}
