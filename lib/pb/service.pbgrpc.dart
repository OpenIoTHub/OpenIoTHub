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

class TCPClient extends $grpc.Client {
  static final _$createOneTCP = $grpc.ClientMethod<TCPConfig, TCPConfig>(
      '/pb.TCP/CreateOneTCP',
      (TCPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => TCPConfig.fromBuffer(value));
  static final _$deleteOneTCP = $grpc.ClientMethod<TCPConfig, Empty>(
      '/pb.TCP/DeleteOneTCP',
      (TCPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneTCP = $grpc.ClientMethod<TCPConfig, TCPConfig>(
      '/pb.TCP/GetOneTCP',
      (TCPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => TCPConfig.fromBuffer(value));
  static final _$getAllTCP = $grpc.ClientMethod<Empty, TCPList>(
      '/pb.TCP/GetAllTCP',
      (Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => TCPList.fromBuffer(value));

  TCPClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<TCPConfig> createOneTCP(TCPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> deleteOneTCP(TCPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<TCPConfig> getOneTCP(TCPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOneTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<TCPList> getAllTCP(Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllTCP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class TCPServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.TCP';

  TCPServiceBase() {
    $addMethod($grpc.ServiceMethod<TCPConfig, TCPConfig>(
        'CreateOneTCP',
        createOneTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => TCPConfig.fromBuffer(value),
        (TCPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<TCPConfig, Empty>(
        'DeleteOneTCP',
        deleteOneTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => TCPConfig.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<TCPConfig, TCPConfig>(
        'GetOneTCP',
        getOneTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => TCPConfig.fromBuffer(value),
        (TCPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Empty, TCPList>(
        'GetAllTCP',
        getAllTCP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Empty.fromBuffer(value),
        (TCPList value) => value.writeToBuffer()));
  }

  $async.Future<TCPConfig> createOneTCP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createOneTCP(call, await request);
  }

  $async.Future<Empty> deleteOneTCP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return deleteOneTCP(call, await request);
  }

  $async.Future<TCPConfig> getOneTCP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOneTCP(call, await request);
  }

  $async.Future<TCPList> getAllTCP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllTCP(call, await request);
  }

  $async.Future<TCPConfig> createOneTCP(
      $grpc.ServiceCall call, TCPConfig request);
  $async.Future<Empty> deleteOneTCP($grpc.ServiceCall call, TCPConfig request);
  $async.Future<TCPConfig> getOneTCP($grpc.ServiceCall call, TCPConfig request);
  $async.Future<TCPList> getAllTCP($grpc.ServiceCall call, Empty request);
}

class UDPClient extends $grpc.Client {
  static final _$createOneUDP = $grpc.ClientMethod<UDPConfig, UDPConfig>(
      '/pb.UDP/CreateOneUDP',
      (UDPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => UDPConfig.fromBuffer(value));
  static final _$deleteOneUDP = $grpc.ClientMethod<UDPConfig, Empty>(
      '/pb.UDP/DeleteOneUDP',
      (UDPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneUDP = $grpc.ClientMethod<UDPConfig, UDPConfig>(
      '/pb.UDP/GetOneUDP',
      (UDPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => UDPConfig.fromBuffer(value));
  static final _$getAllUDP = $grpc.ClientMethod<Empty, UDPList>(
      '/pb.UDP/GetAllUDP',
      (Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => UDPList.fromBuffer(value));

  UDPClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<UDPConfig> createOneUDP(UDPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> deleteOneUDP(UDPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<UDPConfig> getOneUDP(UDPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOneUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<UDPList> getAllUDP(Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllUDP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class UDPServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.UDP';

  UDPServiceBase() {
    $addMethod($grpc.ServiceMethod<UDPConfig, UDPConfig>(
        'CreateOneUDP',
        createOneUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => UDPConfig.fromBuffer(value),
        (UDPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<UDPConfig, Empty>(
        'DeleteOneUDP',
        deleteOneUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => UDPConfig.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<UDPConfig, UDPConfig>(
        'GetOneUDP',
        getOneUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => UDPConfig.fromBuffer(value),
        (UDPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Empty, UDPList>(
        'GetAllUDP',
        getAllUDP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Empty.fromBuffer(value),
        (UDPList value) => value.writeToBuffer()));
  }

  $async.Future<UDPConfig> createOneUDP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createOneUDP(call, await request);
  }

  $async.Future<Empty> deleteOneUDP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return deleteOneUDP(call, await request);
  }

  $async.Future<UDPConfig> getOneUDP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOneUDP(call, await request);
  }

  $async.Future<UDPList> getAllUDP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllUDP(call, await request);
  }

  $async.Future<UDPConfig> createOneUDP(
      $grpc.ServiceCall call, UDPConfig request);
  $async.Future<Empty> deleteOneUDP($grpc.ServiceCall call, UDPConfig request);
  $async.Future<UDPConfig> getOneUDP($grpc.ServiceCall call, UDPConfig request);
  $async.Future<UDPList> getAllUDP($grpc.ServiceCall call, Empty request);
}

class HTTPClient extends $grpc.Client {
  static final _$createOneHTTP = $grpc.ClientMethod<HTTPConfig, HTTPConfig>(
      '/pb.HTTP/CreateOneHTTP',
      (HTTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => HTTPConfig.fromBuffer(value));
  static final _$deleteOneHTTP = $grpc.ClientMethod<HTTPConfig, Empty>(
      '/pb.HTTP/DeleteOneHTTP',
      (HTTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneHTTP = $grpc.ClientMethod<HTTPConfig, HTTPConfig>(
      '/pb.HTTP/GetOneHTTP',
      (HTTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => HTTPConfig.fromBuffer(value));
  static final _$getAllHTTP = $grpc.ClientMethod<Empty, HTTPList>(
      '/pb.HTTP/GetAllHTTP',
      (Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => HTTPList.fromBuffer(value));

  HTTPClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

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
}

abstract class HTTPServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.HTTP';

  HTTPServiceBase() {
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

  $async.Future<HTTPConfig> createOneHTTP(
      $grpc.ServiceCall call, HTTPConfig request);
  $async.Future<Empty> deleteOneHTTP(
      $grpc.ServiceCall call, HTTPConfig request);
  $async.Future<HTTPConfig> getOneHTTP(
      $grpc.ServiceCall call, HTTPConfig request);
  $async.Future<HTTPList> getAllHTTP($grpc.ServiceCall call, Empty request);
}

class FTPClient extends $grpc.Client {
  static final _$createOneFTP = $grpc.ClientMethod<FTPConfig, FTPConfig>(
      '/pb.FTP/CreateOneFTP',
      (FTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => FTPConfig.fromBuffer(value));
  static final _$deleteOneFTP = $grpc.ClientMethod<FTPConfig, Empty>(
      '/pb.FTP/DeleteOneFTP',
      (FTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneFTP = $grpc.ClientMethod<FTPConfig, FTPConfig>(
      '/pb.FTP/GetOneFTP',
      (FTPConfig value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => FTPConfig.fromBuffer(value));
  static final _$getAllFTP = $grpc.ClientMethod<Empty, FTPList>(
      '/pb.FTP/GetAllFTP',
      (Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => FTPList.fromBuffer(value));

  FTPClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<FTPConfig> createOneFTP(FTPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOneFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<Empty> deleteOneFTP(FTPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteOneFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<FTPConfig> getOneFTP(FTPConfig request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOneFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<FTPList> getAllFTP(Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAllFTP, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class FTPServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.FTP';

  FTPServiceBase() {
    $addMethod($grpc.ServiceMethod<FTPConfig, FTPConfig>(
        'CreateOneFTP',
        createOneFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => FTPConfig.fromBuffer(value),
        (FTPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<FTPConfig, Empty>(
        'DeleteOneFTP',
        deleteOneFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => FTPConfig.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<FTPConfig, FTPConfig>(
        'GetOneFTP',
        getOneFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => FTPConfig.fromBuffer(value),
        (FTPConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<Empty, FTPList>(
        'GetAllFTP',
        getAllFTP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Empty.fromBuffer(value),
        (FTPList value) => value.writeToBuffer()));
  }

  $async.Future<FTPConfig> createOneFTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createOneFTP(call, await request);
  }

  $async.Future<Empty> deleteOneFTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return deleteOneFTP(call, await request);
  }

  $async.Future<FTPConfig> getOneFTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOneFTP(call, await request);
  }

  $async.Future<FTPList> getAllFTP_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllFTP(call, await request);
  }

  $async.Future<FTPConfig> createOneFTP(
      $grpc.ServiceCall call, FTPConfig request);
  $async.Future<Empty> deleteOneFTP($grpc.ServiceCall call, FTPConfig request);
  $async.Future<FTPConfig> getOneFTP($grpc.ServiceCall call, FTPConfig request);
  $async.Future<FTPList> getAllFTP($grpc.ServiceCall call, Empty request);
}

class SOCKS5Client extends $grpc.Client {
  static final _$createOneSOCKS5 =
      $grpc.ClientMethod<SOCKS5Config, SOCKS5Config>(
          '/pb.SOCKS5/CreateOneSOCKS5',
          (SOCKS5Config value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => SOCKS5Config.fromBuffer(value));
  static final _$deleteOneSOCKS5 = $grpc.ClientMethod<SOCKS5Config, Empty>(
      '/pb.SOCKS5/DeleteOneSOCKS5',
      (SOCKS5Config value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => Empty.fromBuffer(value));
  static final _$getOneSOCKS5 = $grpc.ClientMethod<SOCKS5Config, SOCKS5Config>(
      '/pb.SOCKS5/GetOneSOCKS5',
      (SOCKS5Config value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => SOCKS5Config.fromBuffer(value));
  static final _$getAllSOCKS5 = $grpc.ClientMethod<Empty, SOCKS5List>(
      '/pb.SOCKS5/GetAllSOCKS5',
      (Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => SOCKS5List.fromBuffer(value));

  SOCKS5Client($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

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

  $grpc.ResponseFuture<SOCKS5List> getAllSOCKS5(Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAllSOCKS5, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class SOCKS5ServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.SOCKS5';

  SOCKS5ServiceBase() {
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
    $addMethod($grpc.ServiceMethod<Empty, SOCKS5List>(
        'GetAllSOCKS5',
        getAllSOCKS5_Pre,
        false,
        false,
        ($core.List<$core.int> value) => Empty.fromBuffer(value),
        (SOCKS5List value) => value.writeToBuffer()));
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

  $async.Future<SOCKS5List> getAllSOCKS5_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAllSOCKS5(call, await request);
  }

  $async.Future<SOCKS5Config> createOneSOCKS5(
      $grpc.ServiceCall call, SOCKS5Config request);
  $async.Future<Empty> deleteOneSOCKS5(
      $grpc.ServiceCall call, SOCKS5Config request);
  $async.Future<SOCKS5Config> getOneSOCKS5(
      $grpc.ServiceCall call, SOCKS5Config request);
  $async.Future<SOCKS5List> getAllSOCKS5($grpc.ServiceCall call, Empty request);
}
