import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/publicApi.pbgrpc.dart';

import 'IoTManagerChannel.dart';

class PublicApi {
  // rpc GenerateJwtQRCodePair (Empty) returns (JwtQRCodePair) {}
  // 服务器获取网关登陆秘钥和手机添加的二维码
  static Future<JwtQRCodePair> GenerateJwtQRCodePair() async {
    final channel = await Channel.getDefaultIoTManagerChannel();
    final stub = PublicApiClient(channel);
    Empty empty = Empty();
    JwtQRCodePair jwtQRCodePair = await stub.generateJwtQRCodePair(empty);
    print('generateJwtQRCodePair: ${jwtQRCodePair}');
    channel.shutdown();
    return jwtQRCodePair;
  }
}
