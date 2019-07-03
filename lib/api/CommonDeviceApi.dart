import 'package:flutter/material.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class CommonDeviceApi {
  static ClientChannel getClientChannel() {
    final channel = ClientChannel('localhost',
        port: 2080,
        options: const ChannelOptions(
            credentials: const ChannelCredentials.insecure()));
    return channel;
  }

  //设备的操作:增删
//  rpc AddDevice (Device) returns (Empty) {}
  static Future createOneDevice(Device device) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.addDevice(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc DelDevice (Device) returns (Empty) {}
  static Future deleteOneDevice(Device device) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.delDevice(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
  // TCP
//  rpc CreateOneTCP (PortConfig) returns (PortConfig) {}
  static Future createOneTCP(PortConfig config) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.createOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc DeleteOneTCP (PortConfig) returns (Empty) {}
  static Future deleteOneTCP(PortConfig config) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.deleteOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc GetOneTCP (PortConfig) returns (PortConfig) {}
  static Future<PortConfig> getOneTCP(PortConfig config) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
//  rpc GetAllTCP (Device) returns (PortList) {}
  static Future<PortList> getAllTCP(Device device) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllTCP(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
  // UDP
//  rpc CreateOneUDP (PortConfig) returns (PortConfig) {}
  static Future createOneUDP(PortConfig config) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.createOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc DeleteOneUDP (PortConfig) returns (Empty) {}
  static Future deleteOneUDP(PortConfig config) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.deleteOneUDP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc GetOneUDP (PortConfig) returns (PortConfig) {}
  static Future<PortConfig> GetOneUDP(PortConfig config) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getOneUDP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
//  rpc GetAllUDP (Device) returns (PortList) {}
  static Future<PortList> getAllUDP(Device device) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllUDP(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
  // FTP
//  rpc CreateOneFTP (PortConfig) returns (PortConfig) {}
  static Future CreateOneFTP(PortConfig config) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.createOneFTP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc DeleteOneFTP (PortConfig) returns (Empty) {}
  static Future deleteOneFTP(PortConfig config) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.deleteOneFTP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }
//  rpc GetOneFTP (PortConfig) returns (PortConfig) {}
  static Future<PortConfig> getOneFTP(PortConfig config) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
//  rpc GetAllFTP (Device) returns (PortList) {}
  static Future<PortList> getAllFTP(Device device) async {
    final channel = getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllFTP(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
}
