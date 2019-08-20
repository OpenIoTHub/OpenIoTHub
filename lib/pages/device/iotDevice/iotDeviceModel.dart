import 'package:http/http.dart' as http;
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

class IoTDevice {
//  是否是在本内外的设备
  bool noProxy = false;
//  设备的端口信息
  PortConfig portConfig;
//  设备的注册信息
  dynamic info;

  IoTDevice({this.portConfig, this.info});
}
