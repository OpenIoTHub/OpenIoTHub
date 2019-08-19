import 'package:http/http.dart' as http;
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

class Plugin {
  PortConfig portConfig;
  dynamic info;
  Plugin({this.portConfig, this.info});
}
