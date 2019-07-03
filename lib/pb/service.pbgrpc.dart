///
//  Generated code. Do not modify.
//  source: service.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'service.pb.dart';
export 'service.pb.dart';

class SessionManagerClient extends $grpc.Client {
  static final _$createOneSession =
      $grpc.ClientMethod<SessionConfig, SessionConfig>(
          '/pb.SessionManager/CreateOneSession',
          (SessionConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => SessionConfig.fromBuffer(value));
  static final _$deleteOneSession = $grpc.ClientMethod<SessionConfig, Empty>(
      '/pb.SessionManager/DeleteOneSession',
      (SessionConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneSession =
      $grpc.ClientMethod<SessionConfig, SessionConfig>(
          '/pb.SessionManager/GetOneSession',
          (SessionConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => SessionConfig.fromBuffer(value));
  static final _$getAllSession = $grpc.ClientMethod<Empty, SessionList>(
      '/pb.SessionManager/GetAllSession',
      (Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => SessionList.fromBuffer(value));
  static final _$createOneSOCKS5 =
      $grpc.ClientMethod<SOCKS5Config, SOCKS5Config>(
          '/pb.SessionManager/CreateOneSOCKS5',
          (SOCKS5Config value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => SOCKS5Config.fromBuffer(value));
  static final _$deleteOneSOCKS5 = $grpc.ClientMethod<SOCKS5Config, Empty>(
      '/pb.SessionManager/DeleteOneSOCKS5',
      (SOCKS5Config value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneSOCKS5 = $grpc.ClientMethod<SOCKS5Config, SOCKS5Config>(
      '/pb.SessionManager/GetOneSOCKS5',
      (SOCKS5Config value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => SOCKS5Config.fromBuffer(value));
  static final _$createOneHTTP = $grpc.ClientMethod<HTTPConfig, HTTPConfig>(
      '/pb.SessionManager/CreateOneHTTP',
      (HTTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => HTTPConfig.fromBuffer(value));
  static final _$deleteOneHTTP = $grpc.ClientMethod<HTTPConfig, Empty>(
      '/pb.SessionManager/DeleteOneHTTP',
      (HTTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneHTTP = $grpc.ClientMethod<HTTPConfig, HTTPConfig>(
      '/pb.SessionManager/GetOneHTTP',
      (HTTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => HTTPConfig.fromBuffer(value));
  static final _$getAllHTTP = $grpc.ClientMethod<Empty, HTTPList>(
      '/pb.SessionManager/GetAllHTTP',
      (Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => HTTPList.fromBuffer(value));
  static final _$refreshmDNSProxyList =
      $grpc.ClientMethod<SessionConfig, Empty>(
          '/pb.SessionManager/RefreshmDNSProxyList',
          (SessionConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getAllTCP = $grpc.ClientMethod<SessionConfig, PortList>(
      '/pb.SessionManager/GetAllTCP',
      (SessionConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortList.fromBuffer(value));

  SessionManagerClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<SessionConfig> createOneSession(SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> deleteOneSession(SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<SessionConfig> getOneSession(SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getOneSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<SessionList> getAllSession(Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAllSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<SOCKS5Config> createOneSOCKS5(SOCKS5Config request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneSOCKS5, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> deleteOneSOCKS5(SOCKS5Config request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneSOCKS5, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<SOCKS5Config> getOneSOCKS5(SOCKS5Config request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getOneSOCKS5, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<HTTPConfig> createOneHTTP(HTTPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneHTTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> deleteOneHTTP(HTTPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneHTTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<HTTPConfig> getOneHTTP(HTTPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getOneHTTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<HTTPList> getAllHTTP(Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAllHTTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> refreshmDNSProxyList(SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$refreshmDNSProxyList, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortList> getAllTCP(SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class SessionManagerServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.SessionManager';

  SessionManagerServiceBase() {
    $addMethod($grpc.ServiceMethod<SessionConfig, SessionConfig>(
        'CreateOneSession',
        createOneSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => SessionConfig.fromBuffer(value),
        (SessionConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<SessionConfig, Empty>(
        'DeleteOneSession',
        deleteOneSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => SessionConfig.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<SessionConfig, SessionConfig>(
        'GetOneSession',
        getOneSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => SessionConfig.fromBuffer(value),
        (SessionConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Empty, SessionList>(
        'GetAllSession',
        getAllSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Empty.fromBuffer(value),
        (SessionList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<SOCKS5Config, SOCKS5Config>(
        'CreateOneSOCKS5',
        createOneSOCKS5_Pre,
        false,
        false,
        ($core.List<$core.int> value) => SOCKS5Config.fromBuffer(value),
        (SOCKS5Config value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<SOCKS5Config, Empty>(
        'DeleteOneSOCKS5',
        deleteOneSOCKS5_Pre,
        false,
        false,
        ($core.List<$core.int> value) => SOCKS5Config.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<SOCKS5Config, SOCKS5Config>(
        'GetOneSOCKS5',
        getOneSOCKS5_Pre,
        false,
        false,
        ($core.List<$core.int> value) => SOCKS5Config.fromBuffer(value),
        (SOCKS5Config value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<HTTPConfig, HTTPConfig>(
        'CreateOneHTTP',
        createOneHTTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => HTTPConfig.fromBuffer(value),
        (HTTPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<HTTPConfig, Empty>(
        'DeleteOneHTTP',
        deleteOneHTTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => HTTPConfig.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<HTTPConfig, HTTPConfig>(
        'GetOneHTTP',
        getOneHTTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => HTTPConfig.fromBuffer(value),
        (HTTPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Empty, HTTPList>(
        'GetAllHTTP',
        getAllHTTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Empty.fromBuffer(value),
        (HTTPList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<SessionConfig, Empty>(
        'RefreshmDNSProxyList',
        refreshmDNSProxyList_Pre,
        false,
        false,
        ($core.List<$core.int> value) => SessionConfig.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<SessionConfig, PortList>(
        'GetAllTCP',
        getAllTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => SessionConfig.fromBuffer(value),
        (PortList value) => value.writeToBuffer()));
  }

  $async.Future<SessionConfig> createOneSession_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createOneSession(call, await request);
  }

  $async.Future<Empty> deleteOneSession_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return deleteOneSession(call, await request);
  }

  $async.Future<SessionConfig> getOneSession_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOneSession(call, await request);
  }

  $async.Future<SessionList> getAllSession_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllSession(call, await request);
  }

  $async.Future<SOCKS5Config> createOneSOCKS5_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createOneSOCKS5(call, await request);
  }

  $async.Future<Empty> deleteOneSOCKS5_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return deleteOneSOCKS5(call, await request);
  }

  $async.Future<SOCKS5Config> getOneSOCKS5_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOneSOCKS5(call, await request);
  }

  $async.Future<HTTPConfig> createOneHTTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createOneHTTP(call, await request);
  }

  $async.Future<Empty> deleteOneHTTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return deleteOneHTTP(call, await request);
  }

  $async.Future<HTTPConfig> getOneHTTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOneHTTP(call, await request);
  }

  $async.Future<HTTPList> getAllHTTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllHTTP(call, await request);
  }

  $async.Future<Empty> refreshmDNSProxyList_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return refreshmDNSProxyList(call, await request);
  }

  $async.Future<PortList> getAllTCP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllTCP(call, await request);
  }

  $async.Future<SessionConfig> createOneSession(
      $grpc.ServiceCall call, SessionConfig request);
  $async.Future<Empty> deleteOneSession(
      $grpc.ServiceCall call, SessionConfig request);
  $async.Future<SessionConfig> getOneSession(
      $grpc.ServiceCall call, SessionConfig request);
  $async.Future<SessionList> getAllSession(
      $grpc.ServiceCall call, Empty request);
  $async.Future<SOCKS5Config> createOneSOCKS5(
      $grpc.ServiceCall call, SOCKS5Config request);
  $async.Future<Empty> deleteOneSOCKS5(
      $grpc.ServiceCall call, SOCKS5Config request);
  $async.Future<SOCKS5Config> getOneSOCKS5(
      $grpc.ServiceCall call, SOCKS5Config request);
  $async.Future<HTTPConfig> createOneHTTP(
      $grpc.ServiceCall call, HTTPConfig request);
  $async.Future<Empty> deleteOneHTTP(
      $grpc.ServiceCall call, HTTPConfig request);
  $async.Future<HTTPConfig> getOneHTTP(
      $grpc.ServiceCall call, HTTPConfig request);
  $async.Future<HTTPList> getAllHTTP($grpc.ServiceCall call, Empty request);
  $async.Future<Empty> refreshmDNSProxyList(
      $grpc.ServiceCall call, SessionConfig request);
  $async.Future<PortList> getAllTCP(
      $grpc.ServiceCall call, SessionConfig request);
}

class CommonDeviceManagerClient extends $grpc.Client {
  static final _$addDevice = $grpc.ClientMethod<Device, Empty>(
      '/pb.CommonDeviceManager/AddDevice',
      (Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$delDevice = $grpc.ClientMethod<Device, Empty>(
      '/pb.CommonDeviceManager/DelDevice',
      (Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getAllDevice = $grpc.ClientMethod<Empty, DeviceList>(
      '/pb.CommonDeviceManager/GetAllDevice',
      (Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => DeviceList.fromBuffer(value));
  static final _$createOneTCP = $grpc.ClientMethod<PortConfig, PortConfig>(
      '/pb.CommonDeviceManager/CreateOneTCP',
      (PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortConfig.fromBuffer(value));
  static final _$deleteOneTCP = $grpc.ClientMethod<PortConfig, Empty>(
      '/pb.CommonDeviceManager/DeleteOneTCP',
      (PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneTCP = $grpc.ClientMethod<PortConfig, PortConfig>(
      '/pb.CommonDeviceManager/GetOneTCP',
      (PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortConfig.fromBuffer(value));
  static final _$getAllTCP = $grpc.ClientMethod<Device, PortList>(
      '/pb.CommonDeviceManager/GetAllTCP',
      (Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortList.fromBuffer(value));
  static final _$createOneUDP = $grpc.ClientMethod<PortConfig, PortConfig>(
      '/pb.CommonDeviceManager/CreateOneUDP',
      (PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortConfig.fromBuffer(value));
  static final _$deleteOneUDP = $grpc.ClientMethod<PortConfig, Empty>(
      '/pb.CommonDeviceManager/DeleteOneUDP',
      (PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneUDP = $grpc.ClientMethod<PortConfig, PortConfig>(
      '/pb.CommonDeviceManager/GetOneUDP',
      (PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortConfig.fromBuffer(value));
  static final _$getAllUDP = $grpc.ClientMethod<Device, PortList>(
      '/pb.CommonDeviceManager/GetAllUDP',
      (Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortList.fromBuffer(value));
  static final _$createOneFTP = $grpc.ClientMethod<PortConfig, PortConfig>(
      '/pb.CommonDeviceManager/CreateOneFTP',
      (PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortConfig.fromBuffer(value));
  static final _$deleteOneFTP = $grpc.ClientMethod<PortConfig, Empty>(
      '/pb.CommonDeviceManager/DeleteOneFTP',
      (PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneFTP = $grpc.ClientMethod<PortConfig, PortConfig>(
      '/pb.CommonDeviceManager/GetOneFTP',
      (PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortConfig.fromBuffer(value));
  static final _$getAllFTP = $grpc.ClientMethod<Device, PortList>(
      '/pb.CommonDeviceManager/GetAllFTP',
      (Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => PortList.fromBuffer(value));

  CommonDeviceManagerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<Empty> addDevice(Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$addDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> delDevice(Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$delDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<DeviceList> getAllDevice(Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAllDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortConfig> createOneTCP(PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> deleteOneTCP(PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortConfig> getOneTCP(PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOneTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortList> getAllTCP(Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortConfig> createOneUDP(PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> deleteOneUDP(PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortConfig> getOneUDP(PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOneUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortList> getAllUDP(Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortConfig> createOneFTP(PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> deleteOneFTP(PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortConfig> getOneFTP(PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOneFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<PortList> getAllFTP(Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class CommonDeviceManagerServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.CommonDeviceManager';

  CommonDeviceManagerServiceBase() {
    $addMethod($grpc.ServiceMethod<Device, Empty>(
        'AddDevice',
        addDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Device.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Device, Empty>(
        'DelDevice',
        delDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Device.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Empty, DeviceList>(
        'GetAllDevice',
        getAllDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Empty.fromBuffer(value),
        (DeviceList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<PortConfig, PortConfig>(
        'CreateOneTCP',
        createOneTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => PortConfig.fromBuffer(value),
        (PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<PortConfig, Empty>(
        'DeleteOneTCP',
        deleteOneTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => PortConfig.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<PortConfig, PortConfig>(
        'GetOneTCP',
        getOneTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => PortConfig.fromBuffer(value),
        (PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Device, PortList>(
        'GetAllTCP',
        getAllTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Device.fromBuffer(value),
        (PortList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<PortConfig, PortConfig>(
        'CreateOneUDP',
        createOneUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => PortConfig.fromBuffer(value),
        (PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<PortConfig, Empty>(
        'DeleteOneUDP',
        deleteOneUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => PortConfig.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<PortConfig, PortConfig>(
        'GetOneUDP',
        getOneUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => PortConfig.fromBuffer(value),
        (PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Device, PortList>(
        'GetAllUDP',
        getAllUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Device.fromBuffer(value),
        (PortList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<PortConfig, PortConfig>(
        'CreateOneFTP',
        createOneFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => PortConfig.fromBuffer(value),
        (PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<PortConfig, Empty>(
        'DeleteOneFTP',
        deleteOneFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => PortConfig.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<PortConfig, PortConfig>(
        'GetOneFTP',
        getOneFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => PortConfig.fromBuffer(value),
        (PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Device, PortList>(
        'GetAllFTP',
        getAllFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Device.fromBuffer(value),
        (PortList value) => value.writeToBuffer()));
  }

  $async.Future<Empty> addDevice_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return addDevice(call, await request);
  }

  $async.Future<Empty> delDevice_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return delDevice(call, await request);
  }

  $async.Future<DeviceList> getAllDevice_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllDevice(call, await request);
  }

  $async.Future<PortConfig> createOneTCP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createOneTCP(call, await request);
  }

  $async.Future<Empty> deleteOneTCP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return deleteOneTCP(call, await request);
  }

  $async.Future<PortConfig> getOneTCP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOneTCP(call, await request);
  }

  $async.Future<PortList> getAllTCP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllTCP(call, await request);
  }

  $async.Future<PortConfig> createOneUDP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createOneUDP(call, await request);
  }

  $async.Future<Empty> deleteOneUDP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return deleteOneUDP(call, await request);
  }

  $async.Future<PortConfig> getOneUDP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOneUDP(call, await request);
  }

  $async.Future<PortList> getAllUDP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllUDP(call, await request);
  }

  $async.Future<PortConfig> createOneFTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createOneFTP(call, await request);
  }

  $async.Future<Empty> deleteOneFTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return deleteOneFTP(call, await request);
  }

  $async.Future<PortConfig> getOneFTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOneFTP(call, await request);
  }

  $async.Future<PortList> getAllFTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllFTP(call, await request);
  }

  $async.Future<Empty> addDevice($grpc.ServiceCall call, Device request);
  $async.Future<Empty> delDevice($grpc.ServiceCall call, Device request);
  $async.Future<DeviceList> getAllDevice($grpc.ServiceCall call, Empty request);
  $async.Future<PortConfig> createOneTCP(
      $grpc.ServiceCall call, PortConfig request);
  $async.Future<Empty> deleteOneTCP($grpc.ServiceCall call, PortConfig request);
  $async.Future<PortConfig> getOneTCP(
      $grpc.ServiceCall call, PortConfig request);
  $async.Future<PortList> getAllTCP($grpc.ServiceCall call, Device request);
  $async.Future<PortConfig> createOneUDP(
      $grpc.ServiceCall call, PortConfig request);
  $async.Future<Empty> deleteOneUDP($grpc.ServiceCall call, PortConfig request);
  $async.Future<PortConfig> getOneUDP(
      $grpc.ServiceCall call, PortConfig request);
  $async.Future<PortList> getAllUDP($grpc.ServiceCall call, Device request);
  $async.Future<PortConfig> createOneFTP(
      $grpc.ServiceCall call, PortConfig request);
  $async.Future<Empty> deleteOneFTP($grpc.ServiceCall call, PortConfig request);
  $async.Future<PortConfig> getOneFTP(
      $grpc.ServiceCall call, PortConfig request);
  $async.Future<PortList> getAllFTP($grpc.ServiceCall call, Device request);
}

class MiioGatewayManagerClient extends $grpc.Client {
  static final _$addDevice = $grpc.ClientMethod<MiioGatewayDevice, Empty>(
      '/pb.MiioGatewayManager/AddDevice',
      (MiioGatewayDevice value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$delDevice = $grpc.ClientMethod<MiioGatewayDevice, Empty>(
      '/pb.MiioGatewayManager/DelDevice',
      (MiioGatewayDevice value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getAllDevice =
      $grpc.ClientMethod<Empty, MiioGatewayDeviceList>(
          '/pb.MiioGatewayManager/GetAllDevice',
          (Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              MiioGatewayDeviceList.fromBuffer(value));
  static final _$setColor = $grpc.ClientMethod<MiioGatewayDevice, Empty>(
      '/pb.MiioGatewayManager/SetColor',
      (MiioGatewayDevice value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$setBrightness = $grpc.ClientMethod<MiioGatewayDevice, Empty>(
      '/pb.MiioGatewayManager/SetBrightness',
      (MiioGatewayDevice value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$on = $grpc.ClientMethod<MiioGatewayDevice, Empty>(
      '/pb.MiioGatewayManager/On',
      (MiioGatewayDevice value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$off = $grpc.ClientMethod<MiioGatewayDevice, Empty>(
      '/pb.MiioGatewayManager/Off',
      (MiioGatewayDevice value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$stop = $grpc.ClientMethod<MiioGatewayDevice, Empty>(
      '/pb.MiioGatewayManager/Stop',
      (MiioGatewayDevice value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$updateGetawayState =
      $grpc.ClientMethod<MiioGatewayDevice, Empty>(
          '/pb.MiioGatewayManager/UpdateGetawayState',
          (MiioGatewayDevice value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getGetawayUpdateMessage =
      $grpc.ClientMethod<MiioGatewayDevice, GatewayUpdateMessage>(
          '/pb.MiioGatewayManager/GetGetawayUpdateMessage',
          (MiioGatewayDevice value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              GatewayUpdateMessage.fromBuffer(value));

  MiioGatewayManagerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<Empty> addDevice(MiioGatewayDevice request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$addDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> delDevice(MiioGatewayDevice request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$delDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<MiioGatewayDeviceList> getAllDevice(Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAllDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> setColor(MiioGatewayDevice request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$setColor, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> setBrightness(MiioGatewayDevice request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$setBrightness, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> on(MiioGatewayDevice request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$on, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> off(MiioGatewayDevice request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$off, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> stop(MiioGatewayDevice request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$stop, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> updateGetawayState(MiioGatewayDevice request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateGetawayState, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<GatewayUpdateMessage> getGetawayUpdateMessage(
      MiioGatewayDevice request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getGetawayUpdateMessage, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class MiioGatewayManagerServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.MiioGatewayManager';

  MiioGatewayManagerServiceBase() {
    $addMethod($grpc.ServiceMethod<MiioGatewayDevice, Empty>(
        'AddDevice',
        addDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => MiioGatewayDevice.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<MiioGatewayDevice, Empty>(
        'DelDevice',
        delDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => MiioGatewayDevice.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Empty, MiioGatewayDeviceList>(
        'GetAllDevice',
        getAllDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Empty.fromBuffer(value),
        (MiioGatewayDeviceList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<MiioGatewayDevice, Empty>(
        'SetColor',
        setColor_Pre,
        false,
        false,
        ($core.List<$core.int> value) => MiioGatewayDevice.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<MiioGatewayDevice, Empty>(
        'SetBrightness',
        setBrightness_Pre,
        false,
        false,
        ($core.List<$core.int> value) => MiioGatewayDevice.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<MiioGatewayDevice, Empty>(
        'On',
        on_Pre,
        false,
        false,
        ($core.List<$core.int> value) => MiioGatewayDevice.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<MiioGatewayDevice, Empty>(
        'Off',
        off_Pre,
        false,
        false,
        ($core.List<$core.int> value) => MiioGatewayDevice.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<MiioGatewayDevice, Empty>(
        'Stop',
        stop_Pre,
        false,
        false,
        ($core.List<$core.int> value) => MiioGatewayDevice.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<MiioGatewayDevice, Empty>(
        'UpdateGetawayState',
        updateGetawayState_Pre,
        false,
        false,
        ($core.List<$core.int> value) => MiioGatewayDevice.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<MiioGatewayDevice, GatewayUpdateMessage>(
        'GetGetawayUpdateMessage',
        getGetawayUpdateMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => MiioGatewayDevice.fromBuffer(value),
        (GatewayUpdateMessage value) => value.writeToBuffer()));
  }

  $async.Future<Empty> addDevice_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return addDevice(call, await request);
  }

  $async.Future<Empty> delDevice_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return delDevice(call, await request);
  }

  $async.Future<MiioGatewayDeviceList> getAllDevice_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllDevice(call, await request);
  }

  $async.Future<Empty> setColor_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return setColor(call, await request);
  }

  $async.Future<Empty> setBrightness_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return setBrightness(call, await request);
  }

  $async.Future<Empty> on_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return on(call, await request);
  }

  $async.Future<Empty> off_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return off(call, await request);
  }

  $async.Future<Empty> stop_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return stop(call, await request);
  }

  $async.Future<Empty> updateGetawayState_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return updateGetawayState(call, await request);
  }

  $async.Future<GatewayUpdateMessage> getGetawayUpdateMessage_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getGetawayUpdateMessage(call, await request);
  }

  $async.Future<Empty> addDevice(
      $grpc.ServiceCall call, MiioGatewayDevice request);
  $async.Future<Empty> delDevice(
      $grpc.ServiceCall call, MiioGatewayDevice request);
  $async.Future<MiioGatewayDeviceList> getAllDevice(
      $grpc.ServiceCall call, Empty request);
  $async.Future<Empty> setColor(
      $grpc.ServiceCall call, MiioGatewayDevice request);
  $async.Future<Empty> setBrightness(
      $grpc.ServiceCall call, MiioGatewayDevice request);
  $async.Future<Empty> on($grpc.ServiceCall call, MiioGatewayDevice request);
  $async.Future<Empty> off($grpc.ServiceCall call, MiioGatewayDevice request);
  $async.Future<Empty> stop($grpc.ServiceCall call, MiioGatewayDevice request);
  $async.Future<Empty> updateGetawayState(
      $grpc.ServiceCall call, MiioGatewayDevice request);
  $async.Future<GatewayUpdateMessage> getGetawayUpdateMessage(
      $grpc.ServiceCall call, MiioGatewayDevice request);
}
