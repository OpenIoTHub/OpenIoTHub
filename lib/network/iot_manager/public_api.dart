import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/publicApi.pbgrpc.dart';

import 'package:openiothub/network/network_log.dart';

import 'iot_manager_channel.dart';

class PublicApi {
  // rpc generateJwtQrCodePair (Empty) returns (JwtQRCodePair) {}
  // 服务器获取网关登陆秘钥和手机添加的二维码
  static Future<JwtQRCodePair> generateJwtQrCodePair() async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = PublicApiClient(channel);
    Empty empty = Empty();
    JwtQRCodePair jwtQRCodePair = await stub.generateJwtQRCodePair(empty);
    netLog('PublicApi', 'generateJwtQRCodePair: $jwtQRCodePair');
    channel.shutdown();
    return jwtQRCodePair;
  }
}
