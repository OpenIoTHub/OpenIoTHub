import 'package:http/http.dart' as http;
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

class IoTDevice {
  PortConfig portConfig;
  dynamic info;
  IoTDevice({this.portConfig, this.info});
}
