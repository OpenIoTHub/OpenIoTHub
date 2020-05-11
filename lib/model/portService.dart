import 'package:http/http.dart' as http;
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';

class PortService {
//  基础url，如：http://127.0.0.1:3679,不带根/
//  String baseUrl;
  String ip;
  int port;

//  是否是在本内外的设备
  bool isLocal = false;

//  设备的端口信息
  PortConfig portConfig;

//  设备的注册信息
  Map<String, dynamic> info;

  PortService({this.portConfig, this.info, this.isLocal, this.ip, this.port});
}
