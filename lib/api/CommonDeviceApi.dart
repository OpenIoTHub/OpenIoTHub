import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

import 'Channel.dart';

class CommonDeviceApi {
  //设置设备的物理地址
  static Future setDeviceMac(Device device) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.setDeviceMac(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

//  设备网络唤醒
  static Future wakeOnLAN(Device device) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.wakeOnLAN(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

  //设备的操作:增删
//  rpc AddDevice (Device) returns (Empty) {}
  static Future createOneDevice(Device device) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.addDevice(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

//  rpc DelDevice (Device) returns (Empty) {}
  static Future deleteOneDevice(Device device) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.delDevice(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

//  rpc GetAllDevice (Empty) returns (DeviceList) {}
  static Future<DeviceList> getAllDevice() async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllDevice(Empty());
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

  // TCP
//  rpc CreateOneTCP (PortConfig) returns (PortConfig) {}
  static Future createOneTCP(PortConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.createOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

//  rpc DeleteOneTCP (PortConfig) returns (Empty) {}
  static Future deleteOneTCP(PortConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.deleteOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

//  rpc GetOneTCP (PortConfig) returns (PortConfig) {}
  static Future<PortConfig> getOneTCP(PortConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

//  rpc GetAllTCP (Device) returns (PortList) {}
  static Future<PortList> getAllTCP(Device device) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllTCP(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

  // UDP
//  rpc CreateOneUDP (PortConfig) returns (PortConfig) {}
  static Future createOneUDP(PortConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.createOneUDP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

//  rpc DeleteOneUDP (PortConfig) returns (Empty) {}
  static Future deleteOneUDP(PortConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.deleteOneUDP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

//  rpc GetOneUDP (PortConfig) returns (PortConfig) {}
  static Future<PortConfig> getOneUDP(PortConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getOneUDP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

//  rpc GetAllUDP (Device) returns (PortList) {}
  static Future<PortList> getAllUDP(Device device) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllUDP(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

  // FTP
//  rpc CreateOneFTP (PortConfig) returns (PortConfig) {}
  static Future createOneFTP(PortConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.createOneFTP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

//  rpc DeleteOneFTP (PortConfig) returns (Empty) {}
  static Future deleteOneFTP(PortConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.deleteOneFTP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

//  rpc GetOneFTP (PortConfig) returns (PortConfig) {}
  static Future<PortConfig> getOneFTP(PortConfig config) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getOneFTP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

//  rpc GetAllFTP (Device) returns (PortList) {}
  static Future<PortList> getAllFTP(Device device) async {
    final channel = await Channel.getClientChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllFTP(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
}
