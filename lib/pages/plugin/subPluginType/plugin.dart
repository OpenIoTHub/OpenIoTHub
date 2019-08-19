import 'package:http/http.dart' as http;
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

class Plugin {
  PortConfig portConfig;
  http.Response response;
  Plugin({this.portConfig, this.response});
}
