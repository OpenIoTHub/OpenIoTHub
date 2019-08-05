import 'package:http/http.dart' as http;
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

class IoTDevice {
  PortConfig portConfig;
  http.Response response;
  IoTDevice({this.portConfig, this.response});
}
