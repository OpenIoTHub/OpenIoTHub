import 'package:openiothub/network/iot_manager/gateway_manager.dart';
import 'package:openiothub/network/openiothub/openiothub_channel.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub/network/network_log.dart';

class SessionApi {
//  TODO 可以选择grpc所执行的主机，可以是安卓本机也可以是pc，也可以是服务器
  static Future createOneSession(SessionConfig config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.createOneSession(config);
    netLog('SessionApi', 'createOneSession: $response');
    channel.shutdown();
    //  从服务器创建配置再同步，所以这里不需要保存到服务器
  }

  static Future deleteOneSession(SessionConfig config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    await stub.deleteOneSession(config);
    channel.shutdown();
    //同步删除服务器上的配置
    GatewayInfo gatewayInfo = GatewayInfo();
    gatewayInfo.gatewayUuid = config.runId;
    await GatewayManager.delGateway(gatewayInfo);
  }

  static Future<SessionList> getAllSession() async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.getAllSession(Empty());
    netLog('SessionApi', 'getAllSession: ${response.sessionConfigs}');
    channel.shutdown();
    return response;
  }

  static Future<SessionConfig> getOneSession(String runId) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    SessionConfig sessionConfig = SessionConfig();
    sessionConfig.runId = runId;
    final newSessionConfig = await stub.getOneSession(sessionConfig);
    channel.shutdown();
    return newSessionConfig;
  }

  // rpc updateSessionNameDescription (SessionConfig) returns (SessionConfig) {}
  static Future<void> updateSessionNameDescription(
      SessionConfig sessionConfig) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    await stub.updateSessionNameDescription(sessionConfig);
    channel.shutdown();
    return;
  }

  // rpc getOneSocks5PortByRunId (google.protobuf.StringValue) returns (google.protobuf.Int64Value) {}
  static Future<int> getOneSocks5PortByRunId(String runId) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    final port = await stub.getOneSOCKS5PortByRunId(StringValue(value: runId));
    channel.shutdown();
    return port.value.toInt();
  }
  // rpc getOneHttpProxyPortByRunId (google.protobuf.StringValue) returns (google.protobuf.Int64Value) {}
  static Future<int> getOneHttpProxyPortByRunId(String runId) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    final port = await stub.getOneHttpProxyPortByRunId(StringValue(value: runId));
    channel.shutdown();
    return port.value.toInt();
  }

  static Future<PortList> getAllTCP(SessionConfig sessionConfig) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.getAllTCP(sessionConfig);
    netLog('SessionApi', 'getAllTCP: ${response.portConfigs}');
    channel.shutdown();
    return response;
  }

  static Future<Empty> refreshmDNSServices(SessionConfig sessionConfig) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.refreshmDNSProxyList(sessionConfig);
    netLog('SessionApi', 'refreshmDNSServices: $response');
    channel.shutdown();
    return response;
  }

  static Future<Empty> createTcpProxyList(PortList portList) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    final response = await stub.createTcpProxyList(portList);
    netLog('SessionApi', 'createTcpProxyList: $response');
    channel.shutdown();
    return response;
  }

  // 通知这个网关删除配置文件中的token
  // rpc DeletRemoteGatewayConfig (SessionConfig) returns (OpenIoTHubOperationResponse) {}
  static Future<OpenIoTHubOperationResponse> deleteRemoteGatewayConfig(
      SessionConfig sessionConfig) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = SessionManagerClient(channel);
    OpenIoTHubOperationResponse response =
        await stub.deleteRemoteGatewayConfig(sessionConfig);
    netLog('SessionApi',
        'deleteRemoteGatewayConfig runId=${sessionConfig.runId} response=$response');
    channel.shutdown();
    return response;
  }
}
