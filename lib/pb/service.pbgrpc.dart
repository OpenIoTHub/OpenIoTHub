///
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core show int, String, List;

import 'package:grpc/service_api.dart' as $grpc;
import 'service.pb.dart' as $0;
export 'service.pb.dart';

class SessionManagerClient extends $grpc.Client {
  static final _$createOneSession =
      $grpc.ClientMethod<$0.SessionConfig, $0.SessionConfig>(
          '/pb.SessionManager/CreateOneSession',
          ($0.SessionConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SessionConfig.fromBuffer(value));
  static final _$deleteOneSession =
      $grpc.ClientMethod<$0.SessionConfig, $0.Empty>(
          '/pb.SessionManager/DeleteOneSession',
          ($0.SessionConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getOneSession =
      $grpc.ClientMethod<$0.SessionConfig, $0.SessionConfig>(
          '/pb.SessionManager/GetOneSession',
          ($0.SessionConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SessionConfig.fromBuffer(value));
  static final _$getAllSession = $grpc.ClientMethod<$0.Empty, $0.SessionList>(
      '/pb.SessionManager/GetAllSession',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SessionList.fromBuffer(value));
  static final _$createOneSOCKS5 =
      $grpc.ClientMethod<$0.SOCKS5Config, $0.SOCKS5Config>(
          '/pb.SessionManager/CreateOneSOCKS5',
          ($0.SOCKS5Config value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SOCKS5Config.fromBuffer(value));
  static final _$deleteOneSOCKS5 =
      $grpc.ClientMethod<$0.SOCKS5Config, $0.Empty>(
          '/pb.SessionManager/DeleteOneSOCKS5',
          ($0.SOCKS5Config value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getOneSOCKS5 =
      $grpc.ClientMethod<$0.SOCKS5Config, $0.SOCKS5Config>(
          '/pb.SessionManager/GetOneSOCKS5',
          ($0.SOCKS5Config value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SOCKS5Config.fromBuffer(value));
  static final _$createOneHTTP =
      $grpc.ClientMethod<$0.HTTPConfig, $0.HTTPConfig>(
          '/pb.SessionManager/CreateOneHTTP',
          ($0.HTTPConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.HTTPConfig.fromBuffer(value));
  static final _$deleteOneHTTP = $grpc.ClientMethod<$0.HTTPConfig, $0.Empty>(
      '/pb.SessionManager/DeleteOneHTTP',
      ($0.HTTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getOneHTTP = $grpc.ClientMethod<$0.HTTPConfig, $0.HTTPConfig>(
      '/pb.SessionManager/GetOneHTTP',
      ($0.HTTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.HTTPConfig.fromBuffer(value));
  static final _$getAllHTTP = $grpc.ClientMethod<$0.Empty, $0.HTTPList>(
      '/pb.SessionManager/GetAllHTTP',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.HTTPList.fromBuffer(value));
  static final _$refreshmDNSProxyList =
      $grpc.ClientMethod<$0.SessionConfig, $0.Empty>(
          '/pb.SessionManager/RefreshmDNSProxyList',
          ($0.SessionConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getAllTCP = $grpc.ClientMethod<$0.SessionConfig, $0.PortList>(
      '/pb.SessionManager/GetAllTCP',
      ($0.SessionConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PortList.fromBuffer(value));

  SessionManagerClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.SessionConfig> createOneSession(
      $0.SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> deleteOneSession($0.SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.SessionConfig> getOneSession($0.SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getOneSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.SessionList> getAllSession($0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAllSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.SOCKS5Config> createOneSOCKS5($0.SOCKS5Config request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneSOCKS5, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> deleteOneSOCKS5($0.SOCKS5Config request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneSOCKS5, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.SOCKS5Config> getOneSOCKS5($0.SOCKS5Config request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getOneSOCKS5, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.HTTPConfig> createOneHTTP($0.HTTPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneHTTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> deleteOneHTTP($0.HTTPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneHTTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.HTTPConfig> getOneHTTP($0.HTTPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getOneHTTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.HTTPList> getAllHTTP($0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAllHTTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> refreshmDNSProxyList($0.SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$refreshmDNSProxyList, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortList> getAllTCP($0.SessionConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class SessionManagerServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.SessionManager';

  SessionManagerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SessionConfig, $0.SessionConfig>(
        'CreateOneSession',
        createOneSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SessionConfig.fromBuffer(value),
        ($0.SessionConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SessionConfig, $0.Empty>(
        'DeleteOneSession',
        deleteOneSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SessionConfig.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SessionConfig, $0.SessionConfig>(
        'GetOneSession',
        getOneSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SessionConfig.fromBuffer(value),
        ($0.SessionConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.SessionList>(
        'GetAllSession',
        getAllSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.SessionList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SOCKS5Config, $0.SOCKS5Config>(
        'CreateOneSOCKS5',
        createOneSOCKS5_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SOCKS5Config.fromBuffer(value),
        ($0.SOCKS5Config value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SOCKS5Config, $0.Empty>(
        'DeleteOneSOCKS5',
        deleteOneSOCKS5_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SOCKS5Config.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SOCKS5Config, $0.SOCKS5Config>(
        'GetOneSOCKS5',
        getOneSOCKS5_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SOCKS5Config.fromBuffer(value),
        ($0.SOCKS5Config value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HTTPConfig, $0.HTTPConfig>(
        'CreateOneHTTP',
        createOneHTTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HTTPConfig.fromBuffer(value),
        ($0.HTTPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HTTPConfig, $0.Empty>(
        'DeleteOneHTTP',
        deleteOneHTTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HTTPConfig.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HTTPConfig, $0.HTTPConfig>(
        'GetOneHTTP',
        getOneHTTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HTTPConfig.fromBuffer(value),
        ($0.HTTPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.HTTPList>(
        'GetAllHTTP',
        getAllHTTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.HTTPList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SessionConfig, $0.Empty>(
        'RefreshmDNSProxyList',
        refreshmDNSProxyList_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SessionConfig.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SessionConfig, $0.PortList>(
        'GetAllTCP',
        getAllTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SessionConfig.fromBuffer(value),
        ($0.PortList value) => value.writeToBuffer()));
  }

  $async.Future<$0.SessionConfig> createOneSession_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SessionConfig> request) async {
    return createOneSession(call, await request);
  }

  $async.Future<$0.Empty> deleteOneSession_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SessionConfig> request) async {
    return deleteOneSession(call, await request);
  }

  $async.Future<$0.SessionConfig> getOneSession_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SessionConfig> request) async {
    return getOneSession(call, await request);
  }

  $async.Future<$0.SessionList> getAllSession_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getAllSession(call, await request);
  }

  $async.Future<$0.SOCKS5Config> createOneSOCKS5_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SOCKS5Config> request) async {
    return createOneSOCKS5(call, await request);
  }

  $async.Future<$0.Empty> deleteOneSOCKS5_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SOCKS5Config> request) async {
    return deleteOneSOCKS5(call, await request);
  }

  $async.Future<$0.SOCKS5Config> getOneSOCKS5_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SOCKS5Config> request) async {
    return getOneSOCKS5(call, await request);
  }

  $async.Future<$0.HTTPConfig> createOneHTTP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.HTTPConfig> request) async {
    return createOneHTTP(call, await request);
  }

  $async.Future<$0.Empty> deleteOneHTTP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.HTTPConfig> request) async {
    return deleteOneHTTP(call, await request);
  }

  $async.Future<$0.HTTPConfig> getOneHTTP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.HTTPConfig> request) async {
    return getOneHTTP(call, await request);
  }

  $async.Future<$0.HTTPList> getAllHTTP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getAllHTTP(call, await request);
  }

  $async.Future<$0.Empty> refreshmDNSProxyList_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SessionConfig> request) async {
    return refreshmDNSProxyList(call, await request);
  }

  $async.Future<$0.PortList> getAllTCP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SessionConfig> request) async {
    return getAllTCP(call, await request);
  }

  $async.Future<$0.SessionConfig> createOneSession(
      $grpc.ServiceCall call, $0.SessionConfig request);
  $async.Future<$0.Empty> deleteOneSession(
      $grpc.ServiceCall call, $0.SessionConfig request);
  $async.Future<$0.SessionConfig> getOneSession(
      $grpc.ServiceCall call, $0.SessionConfig request);
  $async.Future<$0.SessionList> getAllSession(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.SOCKS5Config> createOneSOCKS5(
      $grpc.ServiceCall call, $0.SOCKS5Config request);
  $async.Future<$0.Empty> deleteOneSOCKS5(
      $grpc.ServiceCall call, $0.SOCKS5Config request);
  $async.Future<$0.SOCKS5Config> getOneSOCKS5(
      $grpc.ServiceCall call, $0.SOCKS5Config request);
  $async.Future<$0.HTTPConfig> createOneHTTP(
      $grpc.ServiceCall call, $0.HTTPConfig request);
  $async.Future<$0.Empty> deleteOneHTTP(
      $grpc.ServiceCall call, $0.HTTPConfig request);
  $async.Future<$0.HTTPConfig> getOneHTTP(
      $grpc.ServiceCall call, $0.HTTPConfig request);
  $async.Future<$0.HTTPList> getAllHTTP(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> refreshmDNSProxyList(
      $grpc.ServiceCall call, $0.SessionConfig request);
  $async.Future<$0.PortList> getAllTCP(
      $grpc.ServiceCall call, $0.SessionConfig request);
}

class CommonDeviceManagerClient extends $grpc.Client {
  static final _$addDevice = $grpc.ClientMethod<$0.Device, $0.Empty>(
      '/pb.CommonDeviceManager/AddDevice',
      ($0.Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$delDevice = $grpc.ClientMethod<$0.Device, $0.Empty>(
      '/pb.CommonDeviceManager/DelDevice',
      ($0.Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getAllDevice = $grpc.ClientMethod<$0.Empty, $0.DeviceList>(
      '/pb.CommonDeviceManager/GetAllDevice',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DeviceList.fromBuffer(value));
  static final _$setDeviceMac = $grpc.ClientMethod<$0.Device, $0.Empty>(
      '/pb.CommonDeviceManager/SetDeviceMac',
      ($0.Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$wakeOnLAN = $grpc.ClientMethod<$0.Device, $0.Empty>(
      '/pb.CommonDeviceManager/WakeOnLAN',
      ($0.Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$createOneTCP =
      $grpc.ClientMethod<$0.PortConfig, $0.PortConfig>(
          '/pb.CommonDeviceManager/CreateOneTCP',
          ($0.PortConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value));
  static final _$deleteOneTCP = $grpc.ClientMethod<$0.PortConfig, $0.Empty>(
      '/pb.CommonDeviceManager/DeleteOneTCP',
      ($0.PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getOneTCP = $grpc.ClientMethod<$0.PortConfig, $0.PortConfig>(
      '/pb.CommonDeviceManager/GetOneTCP',
      ($0.PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value));
  static final _$getAllTCP = $grpc.ClientMethod<$0.Device, $0.PortList>(
      '/pb.CommonDeviceManager/GetAllTCP',
      ($0.Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PortList.fromBuffer(value));
  static final _$createOneUDP =
      $grpc.ClientMethod<$0.PortConfig, $0.PortConfig>(
          '/pb.CommonDeviceManager/CreateOneUDP',
          ($0.PortConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value));
  static final _$deleteOneUDP = $grpc.ClientMethod<$0.PortConfig, $0.Empty>(
      '/pb.CommonDeviceManager/DeleteOneUDP',
      ($0.PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getOneUDP = $grpc.ClientMethod<$0.PortConfig, $0.PortConfig>(
      '/pb.CommonDeviceManager/GetOneUDP',
      ($0.PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value));
  static final _$getAllUDP = $grpc.ClientMethod<$0.Device, $0.PortList>(
      '/pb.CommonDeviceManager/GetAllUDP',
      ($0.Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PortList.fromBuffer(value));
  static final _$createOneFTP =
      $grpc.ClientMethod<$0.PortConfig, $0.PortConfig>(
          '/pb.CommonDeviceManager/CreateOneFTP',
          ($0.PortConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value));
  static final _$deleteOneFTP = $grpc.ClientMethod<$0.PortConfig, $0.Empty>(
      '/pb.CommonDeviceManager/DeleteOneFTP',
      ($0.PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getOneFTP = $grpc.ClientMethod<$0.PortConfig, $0.PortConfig>(
      '/pb.CommonDeviceManager/GetOneFTP',
      ($0.PortConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value));
  static final _$getAllFTP = $grpc.ClientMethod<$0.Device, $0.PortList>(
      '/pb.CommonDeviceManager/GetAllFTP',
      ($0.Device value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PortList.fromBuffer(value));

  CommonDeviceManagerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.Empty> addDevice($0.Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$addDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> delDevice($0.Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$delDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.DeviceList> getAllDevice($0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAllDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> setDeviceMac($0.Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$setDeviceMac, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> wakeOnLAN($0.Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$wakeOnLAN, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortConfig> createOneTCP($0.PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> deleteOneTCP($0.PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortConfig> getOneTCP($0.PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOneTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortList> getAllTCP($0.Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortConfig> createOneUDP($0.PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> deleteOneUDP($0.PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortConfig> getOneUDP($0.PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOneUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortList> getAllUDP($0.Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortConfig> createOneFTP($0.PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> deleteOneFTP($0.PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortConfig> getOneFTP($0.PortConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOneFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.PortList> getAllFTP($0.Device request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class CommonDeviceManagerServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.CommonDeviceManager';

  CommonDeviceManagerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Device, $0.Empty>(
        'AddDevice',
        addDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Device.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Device, $0.Empty>(
        'DelDevice',
        delDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Device.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.DeviceList>(
        'GetAllDevice',
        getAllDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.DeviceList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Device, $0.Empty>(
        'SetDeviceMac',
        setDeviceMac_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Device.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Device, $0.Empty>(
        'WakeOnLAN',
        wakeOnLAN_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Device.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PortConfig, $0.PortConfig>(
        'CreateOneTCP',
        createOneTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value),
        ($0.PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PortConfig, $0.Empty>(
        'DeleteOneTCP',
        deleteOneTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PortConfig, $0.PortConfig>(
        'GetOneTCP',
        getOneTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value),
        ($0.PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Device, $0.PortList>(
        'GetAllTCP',
        getAllTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Device.fromBuffer(value),
        ($0.PortList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PortConfig, $0.PortConfig>(
        'CreateOneUDP',
        createOneUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value),
        ($0.PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PortConfig, $0.Empty>(
        'DeleteOneUDP',
        deleteOneUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PortConfig, $0.PortConfig>(
        'GetOneUDP',
        getOneUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value),
        ($0.PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Device, $0.PortList>(
        'GetAllUDP',
        getAllUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Device.fromBuffer(value),
        ($0.PortList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PortConfig, $0.PortConfig>(
        'CreateOneFTP',
        createOneFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value),
        ($0.PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PortConfig, $0.Empty>(
        'DeleteOneFTP',
        deleteOneFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PortConfig, $0.PortConfig>(
        'GetOneFTP',
        getOneFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PortConfig.fromBuffer(value),
        ($0.PortConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Device, $0.PortList>(
        'GetAllFTP',
        getAllFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Device.fromBuffer(value),
        ($0.PortList value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> addDevice_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Device> request) async {
    return addDevice(call, await request);
  }

  $async.Future<$0.Empty> delDevice_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Device> request) async {
    return delDevice(call, await request);
  }

  $async.Future<$0.DeviceList> getAllDevice_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getAllDevice(call, await request);
  }

  $async.Future<$0.Empty> setDeviceMac_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Device> request) async {
    return setDeviceMac(call, await request);
  }

  $async.Future<$0.Empty> wakeOnLAN_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Device> request) async {
    return wakeOnLAN(call, await request);
  }

  $async.Future<$0.PortConfig> createOneTCP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PortConfig> request) async {
    return createOneTCP(call, await request);
  }

  $async.Future<$0.Empty> deleteOneTCP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PortConfig> request) async {
    return deleteOneTCP(call, await request);
  }

  $async.Future<$0.PortConfig> getOneTCP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PortConfig> request) async {
    return getOneTCP(call, await request);
  }

  $async.Future<$0.PortList> getAllTCP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Device> request) async {
    return getAllTCP(call, await request);
  }

  $async.Future<$0.PortConfig> createOneUDP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PortConfig> request) async {
    return createOneUDP(call, await request);
  }

  $async.Future<$0.Empty> deleteOneUDP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PortConfig> request) async {
    return deleteOneUDP(call, await request);
  }

  $async.Future<$0.PortConfig> getOneUDP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PortConfig> request) async {
    return getOneUDP(call, await request);
  }

  $async.Future<$0.PortList> getAllUDP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Device> request) async {
    return getAllUDP(call, await request);
  }

  $async.Future<$0.PortConfig> createOneFTP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PortConfig> request) async {
    return createOneFTP(call, await request);
  }

  $async.Future<$0.Empty> deleteOneFTP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PortConfig> request) async {
    return deleteOneFTP(call, await request);
  }

  $async.Future<$0.PortConfig> getOneFTP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PortConfig> request) async {
    return getOneFTP(call, await request);
  }

  $async.Future<$0.PortList> getAllFTP_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Device> request) async {
    return getAllFTP(call, await request);
  }

  $async.Future<$0.Empty> addDevice($grpc.ServiceCall call, $0.Device request);
  $async.Future<$0.Empty> delDevice($grpc.ServiceCall call, $0.Device request);
  $async.Future<$0.DeviceList> getAllDevice(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> setDeviceMac(
      $grpc.ServiceCall call, $0.Device request);
  $async.Future<$0.Empty> wakeOnLAN($grpc.ServiceCall call, $0.Device request);
  $async.Future<$0.PortConfig> createOneTCP(
      $grpc.ServiceCall call, $0.PortConfig request);
  $async.Future<$0.Empty> deleteOneTCP(
      $grpc.ServiceCall call, $0.PortConfig request);
  $async.Future<$0.PortConfig> getOneTCP(
      $grpc.ServiceCall call, $0.PortConfig request);
  $async.Future<$0.PortList> getAllTCP(
      $grpc.ServiceCall call, $0.Device request);
  $async.Future<$0.PortConfig> createOneUDP(
      $grpc.ServiceCall call, $0.PortConfig request);
  $async.Future<$0.Empty> deleteOneUDP(
      $grpc.ServiceCall call, $0.PortConfig request);
  $async.Future<$0.PortConfig> getOneUDP(
      $grpc.ServiceCall call, $0.PortConfig request);
  $async.Future<$0.PortList> getAllUDP(
      $grpc.ServiceCall call, $0.Device request);
  $async.Future<$0.PortConfig> createOneFTP(
      $grpc.ServiceCall call, $0.PortConfig request);
  $async.Future<$0.Empty> deleteOneFTP(
      $grpc.ServiceCall call, $0.PortConfig request);
  $async.Future<$0.PortConfig> getOneFTP(
      $grpc.ServiceCall call, $0.PortConfig request);
  $async.Future<$0.PortList> getAllFTP(
      $grpc.ServiceCall call, $0.Device request);
}

class UtilsClient extends $grpc.Client {
  static final _$getAllmDNSServiceList =
      $grpc.ClientMethod<$0.Empty, $0.MDNSServiceList>(
          '/pb.Utils/GetAllmDNSServiceList',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.MDNSServiceList.fromBuffer(value));
  static final _$getmDNSServiceListByType =
      $grpc.ClientMethod<$0.StringValue, $0.MDNSServiceList>(
          '/pb.Utils/GetmDNSServiceListByType',
          ($0.StringValue value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.MDNSServiceList.fromBuffer(value));
  static final _$convertOctonaryUtf8 =
      $grpc.ClientMethod<$0.StringValue, $0.StringValue>(
          '/pb.Utils/ConvertOctonaryUtf8',
          ($0.StringValue value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.StringValue.fromBuffer(value));

  UtilsClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.MDNSServiceList> getAllmDNSServiceList(
      $0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAllmDNSServiceList, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.MDNSServiceList> getmDNSServiceListByType(
      $0.StringValue request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getmDNSServiceListByType, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.StringValue> convertOctonaryUtf8(
      $0.StringValue request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$convertOctonaryUtf8, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class UtilsServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.Utils';

  UtilsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.MDNSServiceList>(
        'GetAllmDNSServiceList',
        getAllmDNSServiceList_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.MDNSServiceList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StringValue, $0.MDNSServiceList>(
        'GetmDNSServiceListByType',
        getmDNSServiceListByType_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StringValue.fromBuffer(value),
        ($0.MDNSServiceList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StringValue, $0.StringValue>(
        'ConvertOctonaryUtf8',
        convertOctonaryUtf8_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StringValue.fromBuffer(value),
        ($0.StringValue value) => value.writeToBuffer()));
  }

  $async.Future<$0.MDNSServiceList> getAllmDNSServiceList_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getAllmDNSServiceList(call, await request);
  }

  $async.Future<$0.MDNSServiceList> getmDNSServiceListByType_Pre(
      $grpc.ServiceCall call, $async.Future<$0.StringValue> request) async {
    return getmDNSServiceListByType(call, await request);
  }

  $async.Future<$0.StringValue> convertOctonaryUtf8_Pre(
      $grpc.ServiceCall call, $async.Future<$0.StringValue> request) async {
    return convertOctonaryUtf8(call, await request);
  }

  $async.Future<$0.MDNSServiceList> getAllmDNSServiceList(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.MDNSServiceList> getmDNSServiceListByType(
      $grpc.ServiceCall call, $0.StringValue request);
  $async.Future<$0.StringValue> convertOctonaryUtf8(
      $grpc.ServiceCall call, $0.StringValue request);
}
