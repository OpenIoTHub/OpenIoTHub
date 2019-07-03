import 'package:flutter/material.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class MiioGatewayDeviceApi {
  static ClientChannel getClientChannel() {
    final channel = ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    return channel;
  }

  //设备的操作:增删
//  rpc AddDevice (MiioGatewayDevice) returns (Empty) {}
  static Future createOneDevice(MiioGatewayDevice device) async {
    final channel = getClientChannel();
    final stub = MiioGatewayManagerClient(channel);
    final response = await stub.addDevice(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc DelDevice (MiioGatewayDevice) returns (Empty) {}
  static Future deleteOneDevice(MiioGatewayDevice device) async {
    final channel = getClientChannel();
    final stub = MiioGatewayManagerClient(channel);
    final response = await stub.delDevice(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
  //网关本身的操作
//  rpc SetColor (MiioGatewayDevice) returns (Empty) {}
  static Future SetColor(MiioGatewayDevice device) async {
    final channel = getClientChannel();
    final stub = MiioGatewayManagerClient(channel);
    final response = await stub.setColor(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc SetBrightness (MiioGatewayDevice) returns (Empty) {}
  static Future SetBrightness(MiioGatewayDevice device) async {
    final channel = getClientChannel();
    final stub = MiioGatewayManagerClient(channel);
    final response = await stub.setBrightness(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc On (MiioGatewayDevice) returns (Empty) {}
  static Future OnLed(MiioGatewayDevice device) async {
    final channel = getClientChannel();
    final stub = MiioGatewayManagerClient(channel);
    final response = await stub.on(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc Off (MiioGatewayDevice) returns (Empty) {}
  static Future OffLed(MiioGatewayDevice device) async {
    final channel = getClientChannel();
    final stub = MiioGatewayManagerClient(channel);
    final response = await stub.off(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc Stop (MiioGatewayDevice) returns (Empty) {}
  static Future Stop(MiioGatewayDevice device) async {
    final channel = getClientChannel();
    final stub = MiioGatewayManagerClient(channel);
    final response = await stub.stop(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc UpdateGetawayState (MiioGatewayDevice) returns (Empty) {}
  static Future UpdateGetawayState(MiioGatewayDevice device) async {
    final channel = getClientChannel();
    final stub = MiioGatewayManagerClient(channel);
    final response = await stub.updateGetawayState(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc GetGetawayUpdateMessage (MiioGatewayDevice) returns (GatewayUpdateMessage) {}
  static Future<GatewayUpdateMessage> GetGetawayUpdateMessage(MiioGatewayDevice device) async {
    final channel = getClientChannel();
    final stub = MiioGatewayManagerClient(channel);
    final response = await stub.getGetawayUpdateMessage(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
}
