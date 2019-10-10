import 'package:http/http.dart' as http;
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

class PortService {
//  基础url，如：http://127.0.0.1:3679,不带根/
  String baseUrl;

//  是否是在本内外的设备
  bool noProxy = false;

//  设备的端口信息
  PortConfig portConfig;

//  设备的注册信息
  Map<String, dynamic> info;

  PortService({this.portConfig, this.info, this.noProxy, this.baseUrl});
}
