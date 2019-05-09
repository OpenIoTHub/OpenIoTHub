///
//  Generated code. Do not modify.
//  source: service.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class SessionConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SessionConfig', package: const $pb.PackageName('pb'))
    ..aOS(1, 'token')
    ..aOS(2, 'description')
    ..hasRequiredFields = false
  ;

  SessionConfig() : super();
  SessionConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SessionConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SessionConfig clone() => SessionConfig()..mergeFromMessage(this);
  SessionConfig copyWith(void Function(SessionConfig) updates) => super.copyWith((message) => updates(message as SessionConfig));
  $pb.BuilderInfo get info_ => _i;
  static SessionConfig create() => SessionConfig();
  SessionConfig createEmptyInstance() => create();
  static $pb.PbList<SessionConfig> createRepeated() => $pb.PbList<SessionConfig>();
  static SessionConfig getDefault() => _defaultInstance ??= create()..freeze();
  static SessionConfig _defaultInstance;

  $core.String get token => $_getS(0, '');
  set token($core.String v) { $_setString(0, v); }
  $core.bool hasToken() => $_has(0);
  void clearToken() => clearField(1);

  $core.String get description => $_getS(1, '');
  set description($core.String v) { $_setString(1, v); }
  $core.bool hasDescription() => $_has(1);
  void clearDescription() => clearField(2);
}

class OneSession extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OneSession', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..hasRequiredFields = false
  ;

  OneSession() : super();
  OneSession.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OneSession.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OneSession clone() => OneSession()..mergeFromMessage(this);
  OneSession copyWith(void Function(OneSession) updates) => super.copyWith((message) => updates(message as OneSession));
  $pb.BuilderInfo get info_ => _i;
  static OneSession create() => OneSession();
  OneSession createEmptyInstance() => create();
  static $pb.PbList<OneSession> createRepeated() => $pb.PbList<OneSession>();
  static OneSession getDefault() => _defaultInstance ??= create()..freeze();
  static OneSession _defaultInstance;

  $core.String get runId => $_getS(0, '');
  set runId($core.String v) { $_setString(0, v); }
  $core.bool hasRunId() => $_has(0);
  void clearRunId() => clearField(1);
}

class TCPConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TCPConfig', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..aOS(2, 'localIP')
    ..a<$core.int>(3, 'localProt', $pb.PbFieldType.O3)
    ..aOS(4, 'remoteIP')
    ..a<$core.int>(5, 'remotePort', $pb.PbFieldType.O3)
    ..aOS(6, 'description')
    ..aOB(7, 'remotePortStatus')
    ..hasRequiredFields = false
  ;

  TCPConfig() : super();
  TCPConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TCPConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TCPConfig clone() => TCPConfig()..mergeFromMessage(this);
  TCPConfig copyWith(void Function(TCPConfig) updates) => super.copyWith((message) => updates(message as TCPConfig));
  $pb.BuilderInfo get info_ => _i;
  static TCPConfig create() => TCPConfig();
  TCPConfig createEmptyInstance() => create();
  static $pb.PbList<TCPConfig> createRepeated() => $pb.PbList<TCPConfig>();
  static TCPConfig getDefault() => _defaultInstance ??= create()..freeze();
  static TCPConfig _defaultInstance;

  $core.String get runId => $_getS(0, '');
  set runId($core.String v) { $_setString(0, v); }
  $core.bool hasRunId() => $_has(0);
  void clearRunId() => clearField(1);

  $core.String get localIP => $_getS(1, '');
  set localIP($core.String v) { $_setString(1, v); }
  $core.bool hasLocalIP() => $_has(1);
  void clearLocalIP() => clearField(2);

  $core.int get localProt => $_get(2, 0);
  set localProt($core.int v) { $_setSignedInt32(2, v); }
  $core.bool hasLocalProt() => $_has(2);
  void clearLocalProt() => clearField(3);

  $core.String get remoteIP => $_getS(3, '');
  set remoteIP($core.String v) { $_setString(3, v); }
  $core.bool hasRemoteIP() => $_has(3);
  void clearRemoteIP() => clearField(4);

  $core.int get remotePort => $_get(4, 0);
  set remotePort($core.int v) { $_setSignedInt32(4, v); }
  $core.bool hasRemotePort() => $_has(4);
  void clearRemotePort() => clearField(5);

  $core.String get description => $_getS(5, '');
  set description($core.String v) { $_setString(5, v); }
  $core.bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  $core.bool get remotePortStatus => $_get(6, false);
  set remotePortStatus($core.bool v) { $_setBool(6, v); }
  $core.bool hasRemotePortStatus() => $_has(6);
  void clearRemotePortStatus() => clearField(7);
}

class UDPConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UDPConfig', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..aOS(2, 'localIP')
    ..a<$core.int>(3, 'localProt', $pb.PbFieldType.O3)
    ..aOS(4, 'remoteIP')
    ..a<$core.int>(5, 'remotePort', $pb.PbFieldType.O3)
    ..aOS(6, 'description')
    ..aOB(7, 'remotePortStatus')
    ..hasRequiredFields = false
  ;

  UDPConfig() : super();
  UDPConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UDPConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UDPConfig clone() => UDPConfig()..mergeFromMessage(this);
  UDPConfig copyWith(void Function(UDPConfig) updates) => super.copyWith((message) => updates(message as UDPConfig));
  $pb.BuilderInfo get info_ => _i;
  static UDPConfig create() => UDPConfig();
  UDPConfig createEmptyInstance() => create();
  static $pb.PbList<UDPConfig> createRepeated() => $pb.PbList<UDPConfig>();
  static UDPConfig getDefault() => _defaultInstance ??= create()..freeze();
  static UDPConfig _defaultInstance;

  $core.String get runId => $_getS(0, '');
  set runId($core.String v) { $_setString(0, v); }
  $core.bool hasRunId() => $_has(0);
  void clearRunId() => clearField(1);

  $core.String get localIP => $_getS(1, '');
  set localIP($core.String v) { $_setString(1, v); }
  $core.bool hasLocalIP() => $_has(1);
  void clearLocalIP() => clearField(2);

  $core.int get localProt => $_get(2, 0);
  set localProt($core.int v) { $_setSignedInt32(2, v); }
  $core.bool hasLocalProt() => $_has(2);
  void clearLocalProt() => clearField(3);

  $core.String get remoteIP => $_getS(3, '');
  set remoteIP($core.String v) { $_setString(3, v); }
  $core.bool hasRemoteIP() => $_has(3);
  void clearRemoteIP() => clearField(4);

  $core.int get remotePort => $_get(4, 0);
  set remotePort($core.int v) { $_setSignedInt32(4, v); }
  $core.bool hasRemotePort() => $_has(4);
  void clearRemotePort() => clearField(5);

  $core.String get description => $_getS(5, '');
  set description($core.String v) { $_setString(5, v); }
  $core.bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  $core.bool get remotePortStatus => $_get(6, false);
  set remotePortStatus($core.bool v) { $_setBool(6, v); }
  $core.bool hasRemotePortStatus() => $_has(6);
  void clearRemotePortStatus() => clearField(7);
}

class HTTPConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HTTPConfig', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..aOS(2, 'domain')
    ..aOS(3, 'remoteIP')
    ..a<$core.int>(4, 'remotePort', $pb.PbFieldType.O3)
    ..aOS(5, 'userName')
    ..aOS(6, 'password')
    ..aOB(7, 'ifHttps')
    ..aOS(8, 'description')
    ..aOB(9, 'remotePortStatus')
    ..hasRequiredFields = false
  ;

  HTTPConfig() : super();
  HTTPConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  HTTPConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  HTTPConfig clone() => HTTPConfig()..mergeFromMessage(this);
  HTTPConfig copyWith(void Function(HTTPConfig) updates) => super.copyWith((message) => updates(message as HTTPConfig));
  $pb.BuilderInfo get info_ => _i;
  static HTTPConfig create() => HTTPConfig();
  HTTPConfig createEmptyInstance() => create();
  static $pb.PbList<HTTPConfig> createRepeated() => $pb.PbList<HTTPConfig>();
  static HTTPConfig getDefault() => _defaultInstance ??= create()..freeze();
  static HTTPConfig _defaultInstance;

  $core.String get runId => $_getS(0, '');
  set runId($core.String v) { $_setString(0, v); }
  $core.bool hasRunId() => $_has(0);
  void clearRunId() => clearField(1);

  $core.String get domain => $_getS(1, '');
  set domain($core.String v) { $_setString(1, v); }
  $core.bool hasDomain() => $_has(1);
  void clearDomain() => clearField(2);

  $core.String get remoteIP => $_getS(2, '');
  set remoteIP($core.String v) { $_setString(2, v); }
  $core.bool hasRemoteIP() => $_has(2);
  void clearRemoteIP() => clearField(3);

  $core.int get remotePort => $_get(3, 0);
  set remotePort($core.int v) { $_setSignedInt32(3, v); }
  $core.bool hasRemotePort() => $_has(3);
  void clearRemotePort() => clearField(4);

  $core.String get userName => $_getS(4, '');
  set userName($core.String v) { $_setString(4, v); }
  $core.bool hasUserName() => $_has(4);
  void clearUserName() => clearField(5);

  $core.String get password => $_getS(5, '');
  set password($core.String v) { $_setString(5, v); }
  $core.bool hasPassword() => $_has(5);
  void clearPassword() => clearField(6);

  $core.bool get ifHttps => $_get(6, false);
  set ifHttps($core.bool v) { $_setBool(6, v); }
  $core.bool hasIfHttps() => $_has(6);
  void clearIfHttps() => clearField(7);

  $core.String get description => $_getS(7, '');
  set description($core.String v) { $_setString(7, v); }
  $core.bool hasDescription() => $_has(7);
  void clearDescription() => clearField(8);

  $core.bool get remotePortStatus => $_get(8, false);
  set remotePortStatus($core.bool v) { $_setBool(8, v); }
  $core.bool hasRemotePortStatus() => $_has(8);
  void clearRemotePortStatus() => clearField(9);
}

class FTPConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FTPConfig', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..aOS(2, 'localIP')
    ..aOS(3, 'iPRewriteSet')
    ..a<$core.int>(4, 'localProt', $pb.PbFieldType.O3)
    ..aOS(5, 'remoteIP')
    ..a<$core.int>(6, 'remotePort', $pb.PbFieldType.O3)
    ..aOS(7, 'description')
    ..aOB(8, 'remotePortStatus')
    ..hasRequiredFields = false
  ;

  FTPConfig() : super();
  FTPConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FTPConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FTPConfig clone() => FTPConfig()..mergeFromMessage(this);
  FTPConfig copyWith(void Function(FTPConfig) updates) => super.copyWith((message) => updates(message as FTPConfig));
  $pb.BuilderInfo get info_ => _i;
  static FTPConfig create() => FTPConfig();
  FTPConfig createEmptyInstance() => create();
  static $pb.PbList<FTPConfig> createRepeated() => $pb.PbList<FTPConfig>();
  static FTPConfig getDefault() => _defaultInstance ??= create()..freeze();
  static FTPConfig _defaultInstance;

  $core.String get runId => $_getS(0, '');
  set runId($core.String v) { $_setString(0, v); }
  $core.bool hasRunId() => $_has(0);
  void clearRunId() => clearField(1);

  $core.String get localIP => $_getS(1, '');
  set localIP($core.String v) { $_setString(1, v); }
  $core.bool hasLocalIP() => $_has(1);
  void clearLocalIP() => clearField(2);

  $core.String get iPRewriteSet => $_getS(2, '');
  set iPRewriteSet($core.String v) { $_setString(2, v); }
  $core.bool hasIPRewriteSet() => $_has(2);
  void clearIPRewriteSet() => clearField(3);

  $core.int get localProt => $_get(3, 0);
  set localProt($core.int v) { $_setSignedInt32(3, v); }
  $core.bool hasLocalProt() => $_has(3);
  void clearLocalProt() => clearField(4);

  $core.String get remoteIP => $_getS(4, '');
  set remoteIP($core.String v) { $_setString(4, v); }
  $core.bool hasRemoteIP() => $_has(4);
  void clearRemoteIP() => clearField(5);

  $core.int get remotePort => $_get(5, 0);
  set remotePort($core.int v) { $_setSignedInt32(5, v); }
  $core.bool hasRemotePort() => $_has(5);
  void clearRemotePort() => clearField(6);

  $core.String get description => $_getS(6, '');
  set description($core.String v) { $_setString(6, v); }
  $core.bool hasDescription() => $_has(6);
  void clearDescription() => clearField(7);

  $core.bool get remotePortStatus => $_get(7, false);
  set remotePortStatus($core.bool v) { $_setBool(7, v); }
  $core.bool hasRemotePortStatus() => $_has(7);
  void clearRemotePortStatus() => clearField(8);
}

class SOCKS5Config extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SOCKS5Config', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..a<$core.int>(2, 'port', $pb.PbFieldType.O3)
    ..aOS(3, 'password')
    ..aOS(4, 'encType')
    ..hasRequiredFields = false
  ;

  SOCKS5Config() : super();
  SOCKS5Config.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SOCKS5Config.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SOCKS5Config clone() => SOCKS5Config()..mergeFromMessage(this);
  SOCKS5Config copyWith(void Function(SOCKS5Config) updates) => super.copyWith((message) => updates(message as SOCKS5Config));
  $pb.BuilderInfo get info_ => _i;
  static SOCKS5Config create() => SOCKS5Config();
  SOCKS5Config createEmptyInstance() => create();
  static $pb.PbList<SOCKS5Config> createRepeated() => $pb.PbList<SOCKS5Config>();
  static SOCKS5Config getDefault() => _defaultInstance ??= create()..freeze();
  static SOCKS5Config _defaultInstance;

  $core.String get runId => $_getS(0, '');
  set runId($core.String v) { $_setString(0, v); }
  $core.bool hasRunId() => $_has(0);
  void clearRunId() => clearField(1);

  $core.int get port => $_get(1, 0);
  set port($core.int v) { $_setSignedInt32(1, v); }
  $core.bool hasPort() => $_has(1);
  void clearPort() => clearField(2);

  $core.String get password => $_getS(2, '');
  set password($core.String v) { $_setString(2, v); }
  $core.bool hasPassword() => $_has(2);
  void clearPassword() => clearField(3);

  $core.String get encType => $_getS(3, '');
  set encType($core.String v) { $_setString(3, v); }
  $core.bool hasEncType() => $_has(3);
  void clearEncType() => clearField(4);
}

class OpResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OpResult', package: const $pb.PackageName('pb'))
    ..aOS(1, 'code')
    ..aOS(2, 'message')
    ..hasRequiredFields = false
  ;

  OpResult() : super();
  OpResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OpResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OpResult clone() => OpResult()..mergeFromMessage(this);
  OpResult copyWith(void Function(OpResult) updates) => super.copyWith((message) => updates(message as OpResult));
  $pb.BuilderInfo get info_ => _i;
  static OpResult create() => OpResult();
  OpResult createEmptyInstance() => create();
  static $pb.PbList<OpResult> createRepeated() => $pb.PbList<OpResult>();
  static OpResult getDefault() => _defaultInstance ??= create()..freeze();
  static OpResult _defaultInstance;

  $core.String get code => $_getS(0, '');
  set code($core.String v) { $_setString(0, v); }
  $core.bool hasCode() => $_has(0);
  void clearCode() => clearField(1);

  $core.String get message => $_getS(1, '');
  set message($core.String v) { $_setString(1, v); }
  $core.bool hasMessage() => $_has(1);
  void clearMessage() => clearField(2);
}

class SessionList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SessionList', package: const $pb.PackageName('pb'))
    ..pc<SessionConfig>(1, 'sessionConfigs', $pb.PbFieldType.PM,SessionConfig.create)
    ..hasRequiredFields = false
  ;

  SessionList() : super();
  SessionList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SessionList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SessionList clone() => SessionList()..mergeFromMessage(this);
  SessionList copyWith(void Function(SessionList) updates) => super.copyWith((message) => updates(message as SessionList));
  $pb.BuilderInfo get info_ => _i;
  static SessionList create() => SessionList();
  SessionList createEmptyInstance() => create();
  static $pb.PbList<SessionList> createRepeated() => $pb.PbList<SessionList>();
  static SessionList getDefault() => _defaultInstance ??= create()..freeze();
  static SessionList _defaultInstance;

  $core.List<SessionConfig> get sessionConfigs => $_getList(0);
}

class TCPList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TCPList', package: const $pb.PackageName('pb'))
    ..pc<TCPConfig>(1, 'tCPConfigs', $pb.PbFieldType.PM,TCPConfig.create)
    ..hasRequiredFields = false
  ;

  TCPList() : super();
  TCPList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TCPList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TCPList clone() => TCPList()..mergeFromMessage(this);
  TCPList copyWith(void Function(TCPList) updates) => super.copyWith((message) => updates(message as TCPList));
  $pb.BuilderInfo get info_ => _i;
  static TCPList create() => TCPList();
  TCPList createEmptyInstance() => create();
  static $pb.PbList<TCPList> createRepeated() => $pb.PbList<TCPList>();
  static TCPList getDefault() => _defaultInstance ??= create()..freeze();
  static TCPList _defaultInstance;

  $core.List<TCPConfig> get tCPConfigs => $_getList(0);
}

class UDPList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UDPList', package: const $pb.PackageName('pb'))
    ..pc<UDPConfig>(1, 'uDPConfigs', $pb.PbFieldType.PM,UDPConfig.create)
    ..hasRequiredFields = false
  ;

  UDPList() : super();
  UDPList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UDPList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UDPList clone() => UDPList()..mergeFromMessage(this);
  UDPList copyWith(void Function(UDPList) updates) => super.copyWith((message) => updates(message as UDPList));
  $pb.BuilderInfo get info_ => _i;
  static UDPList create() => UDPList();
  UDPList createEmptyInstance() => create();
  static $pb.PbList<UDPList> createRepeated() => $pb.PbList<UDPList>();
  static UDPList getDefault() => _defaultInstance ??= create()..freeze();
  static UDPList _defaultInstance;

  $core.List<UDPConfig> get uDPConfigs => $_getList(0);
}

class HTTPList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HTTPList', package: const $pb.PackageName('pb'))
    ..pc<HTTPConfig>(1, 'hTTPConfigs', $pb.PbFieldType.PM,HTTPConfig.create)
    ..hasRequiredFields = false
  ;

  HTTPList() : super();
  HTTPList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  HTTPList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  HTTPList clone() => HTTPList()..mergeFromMessage(this);
  HTTPList copyWith(void Function(HTTPList) updates) => super.copyWith((message) => updates(message as HTTPList));
  $pb.BuilderInfo get info_ => _i;
  static HTTPList create() => HTTPList();
  HTTPList createEmptyInstance() => create();
  static $pb.PbList<HTTPList> createRepeated() => $pb.PbList<HTTPList>();
  static HTTPList getDefault() => _defaultInstance ??= create()..freeze();
  static HTTPList _defaultInstance;

  $core.List<HTTPConfig> get hTTPConfigs => $_getList(0);
}

class FTPList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FTPList', package: const $pb.PackageName('pb'))
    ..pc<FTPConfig>(1, 'fTPConfigs', $pb.PbFieldType.PM,FTPConfig.create)
    ..hasRequiredFields = false
  ;

  FTPList() : super();
  FTPList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FTPList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FTPList clone() => FTPList()..mergeFromMessage(this);
  FTPList copyWith(void Function(FTPList) updates) => super.copyWith((message) => updates(message as FTPList));
  $pb.BuilderInfo get info_ => _i;
  static FTPList create() => FTPList();
  FTPList createEmptyInstance() => create();
  static $pb.PbList<FTPList> createRepeated() => $pb.PbList<FTPList>();
  static FTPList getDefault() => _defaultInstance ??= create()..freeze();
  static FTPList _defaultInstance;

  $core.List<FTPConfig> get fTPConfigs => $_getList(0);
}

class SOCKS5List extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SOCKS5List', package: const $pb.PackageName('pb'))
    ..pc<SOCKS5Config>(1, 'sOCKS5Configs', $pb.PbFieldType.PM,SOCKS5Config.create)
    ..hasRequiredFields = false
  ;

  SOCKS5List() : super();
  SOCKS5List.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SOCKS5List.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SOCKS5List clone() => SOCKS5List()..mergeFromMessage(this);
  SOCKS5List copyWith(void Function(SOCKS5List) updates) => super.copyWith((message) => updates(message as SOCKS5List));
  $pb.BuilderInfo get info_ => _i;
  static SOCKS5List create() => SOCKS5List();
  SOCKS5List createEmptyInstance() => create();
  static $pb.PbList<SOCKS5List> createRepeated() => $pb.PbList<SOCKS5List>();
  static SOCKS5List getDefault() => _defaultInstance ??= create()..freeze();
  static SOCKS5List _defaultInstance;

  $core.List<SOCKS5Config> get sOCKS5Configs => $_getList(0);
}

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Empty', package: const $pb.PackageName('pb'))
    ..hasRequiredFields = false
  ;

  Empty() : super();
  Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Empty clone() => Empty()..mergeFromMessage(this);
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty));
  $pb.BuilderInfo get info_ => _i;
  static Empty create() => Empty();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  static Empty getDefault() => _defaultInstance ??= create()..freeze();
  static Empty _defaultInstance;
}

