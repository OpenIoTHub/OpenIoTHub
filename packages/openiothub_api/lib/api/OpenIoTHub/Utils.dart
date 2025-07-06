import 'package:grpc/grpc.dart';
import 'package:openiothub_api/api/OpenIoTHub/OpenIoTHubChannel.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilApi {
  static Future<void> Ping() async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = UtilsClient(channel, options: CallOptions(timeout: Duration(seconds: 3)));
    Empty empty = Empty();
    await stub.ping(empty);
    channel.shutdown();
  }

  static Future<OpenIoTHubOperationResponse> SyncConfigWithToken() async {
    String jwt = await getJWT();
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = UtilsClient(channel);
    IoTManagerServerAndToken ioTManagerServerAndToken =
        IoTManagerServerAndToken();
    ioTManagerServerAndToken.host = Config.iotManagerGrpcIp;
    ioTManagerServerAndToken.port = Config.iotManagerGrpcPort;
    ioTManagerServerAndToken.token = jwt;
    OpenIoTHubOperationResponse response =
        await stub.syncConfigWithToken(ioTManagerServerAndToken);
    channel.shutdown();
    return response;
  }

  static Future<OpenIoTHubOperationResponse> SyncConfigWithJsonConfig(String config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = UtilsClient(channel);
    StringValue stringValue = StringValue();
    stringValue.value = config;
    OpenIoTHubOperationResponse response =
    await stub.syncConfigWithJsonConfig(stringValue);
    channel.shutdown();
    return response;
  }

  static Future<void> saveAllConfig() async {
    final allconfig = await getAllConfig();
    print("====saveAllConfig:$allconfig");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        SharedPreferencesKey.OPENIOTHUB_GO_AAR_CONFIG_KEY, allconfig);
  }

  static Future<void> loadAllConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!await prefs
        .containsKey(SharedPreferencesKey.OPENIOTHUB_GO_AAR_CONFIG_KEY)) {
      return;
    }
    String? allconfig =
        prefs.getString(SharedPreferencesKey.OPENIOTHUB_GO_AAR_CONFIG_KEY);
    if (allconfig != null) {
      print("====loadAllConfig:$allconfig");
      setAllConfig(allconfig);
    }
  }

//获取本地的所有mdns列表
  static Future<MDNSServiceList> getAllmDNSServiceList() async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = UtilsClient(channel);
    final response = await stub.getAllmDNSServiceList(Empty());
    channel.shutdown();
    print("===getAllmDNSServiceList：${response.mDNSServices}");
    return response;
  }

  //获取本地的指定条件的mdns列表
  static Future<MDNSServiceList> getOnemDNSServiceList(String type) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = UtilsClient(channel);
    StringValue sv = StringValue();
    sv.value = type;
    final response = await stub.getmDNSServiceListByType(sv);
    channel.shutdown();
    print("===getOnemDNSServiceList：${response.mDNSServices}");
    return response;
  }

//将形如：\228\184\178\229\143\163\232\189\172TCP的utf-8乱码转换成正常的中文
  static Future<String> convertOctonaryUtf8(String oldString) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = UtilsClient(channel);
    var openIoTHubStringValue = StringValue();
    openIoTHubStringValue.value = oldString;
    final response = await stub.convertOctonaryUtf8(openIoTHubStringValue);
    channel.shutdown();
    return response.value;
  }

  //获取所有的配置
  static Future<String> getAllConfig() async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = UtilsClient(channel);
    Empty empty = Empty();
    final response = await stub.getAllConfig(empty);
    channel.shutdown();
    return response.value;
  }

  //获取本地的指定条件的mdns列表
  static Future<Empty> setAllConfig(String config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = UtilsClient(channel);
    StringValue sv = StringValue();
    sv.value = config;
    final response = await stub.loadAllConfig(sv);
    channel.shutdown();
    return response;
  }

  //从Token字符串解析TokenModel
  static Future<TokenModel> getTokenModel(String tokenStr) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = UtilsClient(channel);
    StringValue sv = StringValue();
    sv.value = tokenStr;
    final response = await stub.getTokenModel(sv);
    channel.shutdown();
    return response;
  }
}
