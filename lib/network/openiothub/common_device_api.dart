import 'dart:developer' as developer;

import 'package:openiothub/network/openiothub/openiothub_channel.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub_grpc_api/google/protobuf/empty.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/hostManager.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/portManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';

/// 客户端与后端一致的「同主机同网络协议远程端口重复」校验失败时抛出，由 UI 展示本地化文案。
class RemotePortDuplicateException implements Exception {
  const RemotePortDuplicateException();

  @override
  String toString() => 'RemotePortDuplicateException';
}

class CommonDeviceApi {
  /// 与后端一致：同一主机下，同一网络协议（TCP / UDP）的远程端口不可重复；TCP 与 UDP 可同号。
  /// FTP 走 TCP，与 [getAllTCP] / [getAllFTP] 列表一并校验。
  static Future<bool> hostHasConflictingRemotePort(
    Device device,
    String networkProtocol,
    int remotePort, {
    String? excludePortUuid,
  }) async {
    final want = networkProtocol.toLowerCase();
    if (want == 'udp') {
      final list = await getAllUDP(device);
      return _existingPortConflicts(
        list.portConfigs,
        want,
        remotePort,
        excludePortUuid,
      );
    }
    final tcp = await getAllTCP(device);
    final ftp = await getAllFTP(device);
    final merged = <PortConfig>[
      ...tcp.portConfigs,
      ...ftp.portConfigs,
    ];
    return _existingPortConflicts(merged, 'tcp', remotePort, excludePortUuid);
  }

  static bool _existingPortConflicts(
    Iterable<PortConfig> existing,
    String networkProtocolLower,
    int remotePort,
    String? excludePortUuid,
  ) {
    for (final c in existing) {
      if (excludePortUuid != null && c.uuid == excludePortUuid) {
        continue;
      }
      if (c.remotePort != remotePort) {
        continue;
      }
      if (c.networkProtocol.toLowerCase() == networkProtocolLower) {
        return true;
      }
    }
    return false;
  }

  //设置设备的物理地址
  static Future setDeviceMac(Device device) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.setDeviceMac(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    //服务器同步
    HostInfo hostInfo = HostInfo();
    hostInfo.uUID = device.uuid;
    hostInfo.mac = device.mac;
    await HostManager.setDeviceMac(hostInfo);
  }

//  设备网络唤醒
  static Future wakeOnLAN(Device device) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.wakeOnLAN(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
  }

  //设备的操作:增删
//  rpc AddDevice (Device) returns (Empty) {}
  static Future createOneDevice(Device device) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.addDevice(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    //服务器同步
    HostInfo hostInfo = HostInfo();
    hostInfo.uUID = device.uuid;
    hostInfo.name = device.name;
    hostInfo.description = device.description;
    hostInfo.gatewayUUID = device.runId;
    hostInfo.hostAddr = device.addr;
    hostInfo.mac = device.mac;
    await HostManager.addHost(hostInfo);
  }

//  rpc DelDevice (Device) returns (Empty) {}
  static Future deleteOneDevice(Device device) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.delDevice(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    //服务器同步
    HostInfo hostInfo = HostInfo();
    hostInfo.uUID = device.uuid;
    await HostManager.delHost(hostInfo);
  }

//  rpc GetAllDevice (Empty) returns (DeviceList) {}
  static Future<DeviceList> getAllDevice() async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllDevice(Empty());
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

  // TCP
//  rpc CreateOneTCP (PortConfig) returns (PortConfig) {}
  static Future createOneTCP(PortConfig config) async {
    if (await hostHasConflictingRemotePort(
      config.device,
      config.networkProtocol,
      config.remotePort,
    )) {
      throw const RemotePortDuplicateException();
    }
    config.uuid = getOneUUID();
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.createOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    //服务器同步
    PortInfo portInfo = PortInfo();
    portInfo.uUID = config.uuid;
    portInfo.hostUUID = config.device.uuid;
    portInfo.name = config.name;
    portInfo.description = config.description;
    portInfo.bindAllAddr = config.bindAllAddr;
    portInfo.domain = config.domain;
    portInfo.port = config.remotePort;
    portInfo.localPort = config.localProt;
    portInfo.networkProtocol = config.networkProtocol;
    portInfo.applicationProtocol = config.applicationProtocol;
    await PortManager.addPort(portInfo);
  }

//  rpc DeleteOneTCP (PortConfig) returns (Empty) {}
  static Future deleteOneTCP(PortConfig config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    try {
      final stub = CommonDeviceManagerClient(channel);
      final response = await stub.deleteOneTCP(config);
      print('Greeter client received: ${response}');
      PortInfo portInfo = PortInfo();
      portInfo.uUID = config.uuid;
      await PortManager.delPort(portInfo);
    } catch (e, st) {
      developer.log(
        'deleteOneTCP failed uuid=${config.uuid}',
        name: 'CommonDeviceApi',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } finally {
      channel.shutdown();
    }
  }

  /// 根据 [PortConfig] 的协议字段调用对应的删除 RPC（与 [getAllTCP] / [getAllUDP] / [getAllFTP] 列表一致）。
  static Future<void> deleteOnePortForConfig(PortConfig config) async {
    final app = config.applicationProtocol.toLowerCase();
    final net = config.networkProtocol.toLowerCase();
    if (app == 'ftp') {
      await deleteOneFTP(config);
    } else if (net == 'udp') {
      await deleteOneUDP(config);
    } else {
      await deleteOneTCP(config);
    }
  }

//  rpc GetOneTCP (PortConfig) returns (PortConfig) {}
  static Future<PortConfig> getOneTCP(PortConfig config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getOneTCP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

//  rpc GetAllTCP (Device) returns (PortList) {}
  static Future<PortList> getAllTCP(Device device) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllTCP(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

  // UDP
//  rpc CreateOneUDP (PortConfig) returns (PortConfig) {}
  static Future createOneUDP(PortConfig config) async {
    if (await hostHasConflictingRemotePort(
      config.device,
      config.networkProtocol,
      config.remotePort,
    )) {
      throw const RemotePortDuplicateException();
    }
    config.uuid = getOneUUID();
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.createOneUDP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    //服务器同步
    PortInfo portInfo = PortInfo();
    portInfo.uUID = config.uuid;
    portInfo.hostUUID = config.device.uuid;
    portInfo.name = config.name;
    portInfo.description = config.description;
    portInfo.bindAllAddr = config.bindAllAddr;
    portInfo.domain = config.domain;
    portInfo.port = config.remotePort;
    portInfo.localPort = config.localProt;
    portInfo.networkProtocol = config.networkProtocol;
    portInfo.applicationProtocol = config.applicationProtocol;
    await PortManager.addPort(portInfo);
  }

//  rpc DeleteOneUDP (PortConfig) returns (Empty) {}
  static Future deleteOneUDP(PortConfig config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    try {
      final stub = CommonDeviceManagerClient(channel);
      final response = await stub.deleteOneUDP(config);
      print('Greeter client received: ${response}');
      PortInfo portInfo = PortInfo();
      portInfo.uUID = config.uuid;
      await PortManager.delPort(portInfo);
    } catch (e, st) {
      developer.log(
        'deleteOneUDP failed uuid=${config.uuid}',
        name: 'CommonDeviceApi',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } finally {
      channel.shutdown();
    }
  }

//  rpc GetOneUDP (PortConfig) returns (PortConfig) {}
  static Future<PortConfig> getOneUDP(PortConfig config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getOneUDP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

//  rpc GetAllUDP (Device) returns (PortList) {}
  static Future<PortList> getAllUDP(Device device) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllUDP(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

  // FTP
//  rpc CreateOneFTP (PortConfig) returns (PortConfig) {}
  static Future createOneFTP(PortConfig config) async {
    if (await hostHasConflictingRemotePort(
      config.device,
      config.networkProtocol,
      config.remotePort,
    )) {
      throw const RemotePortDuplicateException();
    }
    config.uuid = getOneUUID();
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.createOneFTP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    //服务器同步
    PortInfo portInfo = PortInfo();
    portInfo.uUID = config.uuid;
    portInfo.hostUUID = config.device.uuid;
    portInfo.name = config.name;
    portInfo.description = config.description;
    portInfo.bindAllAddr = config.bindAllAddr;
    portInfo.domain = config.domain;
    portInfo.port = config.remotePort;
    portInfo.localPort = config.localProt;
    portInfo.networkProtocol = config.networkProtocol;
    portInfo.applicationProtocol = config.applicationProtocol;
    await PortManager.addPort(portInfo);
  }

//  rpc DeleteOneFTP (PortConfig) returns (Empty) {}
  static Future deleteOneFTP(PortConfig config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    try {
      final stub = CommonDeviceManagerClient(channel);
      final response = await stub.deleteOneFTP(config);
      print('Greeter client received: ${response}');
      PortInfo portInfo = PortInfo();
      portInfo.uUID = config.uuid;
      await PortManager.delPort(portInfo);
    } catch (e, st) {
      developer.log(
        'deleteOneFTP failed uuid=${config.uuid}',
        name: 'CommonDeviceApi',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } finally {
      channel.shutdown();
    }
  }

//  rpc GetOneFTP (PortConfig) returns (PortConfig) {}
  static Future<PortConfig> getOneFTP(PortConfig config) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getOneFTP(config);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }

//  rpc GetAllFTP (Device) returns (PortList) {}
  static Future<PortList> getAllFTP(Device device) async {
    final channel = await Channel.getOpenIoTHubChannel();
    final stub = CommonDeviceManagerClient(channel);
    final response = await stub.getAllFTP(device);
    print('Greeter client received: ${response}');
    channel.shutdown();
    return response;
  }
}
