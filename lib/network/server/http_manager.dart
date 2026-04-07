import 'package:grpc/grpc.dart';
import 'package:openiothub/network/openiothub/session_api.dart';
import 'package:openiothub/network/server/server_channel.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart' as mobile;
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/server/server.pb.dart';
import 'package:openiothub_grpc_api/proto/server/server.pbgrpc.dart' as server;
import 'package:openiothub/network/network_log.dart';

class HttpManager {
//  rpc createOneHttp (HTTPConfig) returns (HTTPConfig) {}
  static Future<HTTPConfig> createOneHttp(HTTPConfig httpConfig) async {
    final channel = await Channel.getServerChannel(httpConfig.runId);
    SessionConfig sessionConfig =
        await SessionApi.getOneSession(httpConfig.runId);
    final stub = server.HttpManagerClient(channel,
        options: CallOptions(metadata: {'jwt': sessionConfig.token}));

    HTTPConfig httpConfigResponse = await stub.createOneHTTP(httpConfig);
    netLog('HttpManager', 'createOneHttp: $httpConfigResponse');
    channel.shutdown();
    return httpConfigResponse;
  }

//  rpc deleteOneHttp (HTTPConfig) returns (Empty) {}
  static Future<void> deleteOneHttp(HTTPConfig httpConfig) async {
    final channel = await Channel.getServerChannel(httpConfig.runId);
    SessionConfig sessionConfig =
        await SessionApi.getOneSession(httpConfig.runId);
    final stub = server.HttpManagerClient(channel,
        options: CallOptions(metadata: {'jwt': sessionConfig.token}));

    await stub.deleteOneHTTP(httpConfig);
    channel.shutdown();
  }

//  rpc getOneHttp (HTTPConfig) returns (HTTPConfig) {}
  static Future<HTTPConfig> getOneHttp(HTTPConfig httpConfig) async {
    final channel = await Channel.getServerChannel(httpConfig.runId);
    SessionConfig sessionConfig =
        await SessionApi.getOneSession(httpConfig.runId);
    final stub = server.HttpManagerClient(channel,
        options: CallOptions(metadata: {'jwt': sessionConfig.token}));

    HTTPConfig newhttpConfig = await stub.getOneHTTP(httpConfig);
    channel.shutdown();
    return newhttpConfig;
  }

//  rpc getAllHttp (Empty) returns (HTTPList) {}
  static Future<HTTPList> getAllHttp(mobile.Device device) async {
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
