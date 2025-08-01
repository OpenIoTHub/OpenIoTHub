import 'package:grpc/grpc.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_api/api/Server/ServerChannel.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart' as mobile;
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/server/server.pb.dart';
import 'package:openiothub_grpc_api/proto/server/server.pbgrpc.dart' as server;

class HttpManager {
//  rpc CreateOneHTTP (HTTPConfig) returns (HTTPConfig) {}
  static Future<HTTPConfig> CreateOneHTTP(HTTPConfig httpConfig) async {
    final channel = await Channel.getServerChannel(httpConfig.runId);
    SessionConfig sessionConfig =
        await SessionApi.getOneSession(httpConfig.runId);
    final stub = server.HttpManagerClient(channel,
        options: CallOptions(metadata: {'jwt': sessionConfig.token}));

    HTTPConfig httpConfigResponse = await stub.createOneHTTP(httpConfig);
    print('httpConfigResponse: ${httpConfigResponse}');
    channel.shutdown();
    return httpConfigResponse;
  }

//  rpc DeleteOneHTTP (HTTPConfig) returns (Empty) {}
  static Future<void> DeleteOneHTTP(HTTPConfig httpConfig) async {
    final channel = await Channel.getServerChannel(httpConfig.runId);
    SessionConfig sessionConfig =
        await SessionApi.getOneSession(httpConfig.runId);
    final stub = server.HttpManagerClient(channel,
        options: CallOptions(metadata: {'jwt': sessionConfig.token}));

    await stub.deleteOneHTTP(httpConfig);
    channel.shutdown();
  }

//  rpc GetOneHTTP (HTTPConfig) returns (HTTPConfig) {}
  static Future<HTTPConfig> GetOneHTTP(HTTPConfig httpConfig) async {
    final channel = await Channel.getServerChannel(httpConfig.runId);
    SessionConfig sessionConfig =
        await SessionApi.getOneSession(httpConfig.runId);
    final stub = server.HttpManagerClient(channel,
        options: CallOptions(metadata: {'jwt': sessionConfig.token}));

    HTTPConfig newHttpConfig = await stub.getOneHTTP(httpConfig);
    channel.shutdown();
    return newHttpConfig;
  }

//  rpc GetAllHTTP (Empty) returns (HTTPList) {}
  static Future<HTTPList> GetAllHTTP(mobile.Device device) async {
    final channel = await Channel.getServerChannel(device.runId);
    SessionConfig sessionConfig = await SessionApi.getOneSession(device.runId);
    final stub = server.HttpManagerClient(channel,
        options: CallOptions(metadata: {'jwt': sessionConfig.token}));

    server.Device sdevice = server.Device();
    sdevice.runId = device.runId;
    sdevice.addr = device.addr;
    sdevice.mac = device.mac;
    sdevice.description = device.description;
    HTTPList httpList = await stub.getAllHTTP(sdevice);
    channel.shutdown();
    return httpList;
  }
}
