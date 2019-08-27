///
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Empty', package: const $pb.PackageName('pb'))
    ..hasRequiredFields = false
  ;

  Empty._() : super();
  factory Empty() => create();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Empty clone() => Empty()..mergeFromMessage(this);
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  static Empty getDefault() => _defaultInstance ??= create()..freeze();
  static Empty _defaultInstance;
}

class MDNSService extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MDNSService', package: const $pb.PackageName('pb'))
    ..aOS(1, 'name')
    ..aOS(2, 'iP')
    ..a<$core.int>(3, 'port', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  MDNSService._() : super();
  factory MDNSService() => create();
  factory MDNSService.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MDNSService.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  MDNSService clone() => MDNSService()..mergeFromMessage(this);
  MDNSService copyWith(void Function(MDNSService) updates) => super.copyWith((message) => updates(message as MDNSService));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MDNSService create() => MDNSService._();
  MDNSService createEmptyInstance() => create();
  static $pb.PbList<MDNSService> createRepeated() => $pb.PbList<MDNSService>();
  static MDNSService getDefault() => _defaultInstance ??= create()..freeze();
  static MDNSService _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) { $_setString(0, v); }
  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.String get iP => $_getS(1, '');
  set iP($core.String v) { $_setString(1, v); }
  $core.bool hasIP() => $_has(1);
  void clearIP() => clearField(2);

  $core.int get port => $_get(2, 0);
  set port($core.int v) { $_setSignedInt32(2, v); }
  $core.bool hasPort() => $_has(2);
  void clearPort() => clearField(3);
}

class Color extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Color', package: const $pb.PackageName('pb'))
    ..a<$core.int>(1, 'r', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'g', $pb.PbFieldType.O3)
    ..a<$core.int>(3, 'b', $pb.PbFieldType.O3)
    ..a<$core.int>(4, 'a', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Color._() : super();
  factory Color() => create();
  factory Color.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Color.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Color clone() => Color()..mergeFromMessage(this);
  Color copyWith(void Function(Color) updates) => super.copyWith((message) => updates(message as Color));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Color create() => Color._();
  Color createEmptyInstance() => create();
  static $pb.PbList<Color> createRepeated() => $pb.PbList<Color>();
  static Color getDefault() => _defaultInstance ??= create()..freeze();
  static Color _defaultInstance;

  $core.int get r => $_get(0, 0);
  set r($core.int v) { $_setSignedInt32(0, v); }
  $core.bool hasR() => $_has(0);
  void clearR() => clearField(1);

  $core.int get g => $_get(1, 0);
  set g($core.int v) { $_setSignedInt32(1, v); }
  $core.bool hasG() => $_has(1);
  void clearG() => clearField(2);

  $core.int get b => $_get(2, 0);
  set b($core.int v) { $_setSignedInt32(2, v); }
  $core.bool hasB() => $_has(2);
  void clearB() => clearField(3);

  $core.int get a => $_get(3, 0);
  set a($core.int v) { $_setSignedInt32(3, v); }
  $core.bool hasA() => $_has(3);
  void clearA() => clearField(4);
}

class GatewayState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GatewayState', package: const $pb.PackageName('pb'))
    ..aOB(1, 'on')
    ..a<Color>(2, 'color', $pb.PbFieldType.OM, Color.getDefault, Color.create)
    ..a<$core.int>(3, 'brightness', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  GatewayState._() : super();
  factory GatewayState() => create();
  factory GatewayState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GatewayState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GatewayState clone() => GatewayState()..mergeFromMessage(this);
  GatewayState copyWith(void Function(GatewayState) updates) => super.copyWith((message) => updates(message as GatewayState));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GatewayState create() => GatewayState._();
  GatewayState createEmptyInstance() => create();
  static $pb.PbList<GatewayState> createRepeated() => $pb.PbList<GatewayState>();
  static GatewayState getDefault() => _defaultInstance ??= create()..freeze();
  static GatewayState _defaultInstance;

  $core.bool get on => $_get(0, false);
  set on($core.bool v) { $_setBool(0, v); }
  $core.bool hasOn() => $_has(0);
  void clearOn() => clearField(1);

  Color get color => $_getN(1);
  set color(Color v) { setField(2, v); }
  $core.bool hasColor() => $_has(1);
  void clearColor() => clearField(2);

  $core.int get brightness => $_get(2, 0);
  set brightness($core.int v) { $_setUnsignedInt32(2, v); }
  $core.bool hasBrightness() => $_has(2);
  void clearBrightness() => clearField(3);
}

class GatewayUpdateMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GatewayUpdateMessage', package: const $pb.PackageName('pb'))
    ..aOS(1, 'iD')
    ..a<GatewayState>(2, 'state', $pb.PbFieldType.OM, GatewayState.getDefault, GatewayState.create)
    ..hasRequiredFields = false
  ;

  GatewayUpdateMessage._() : super();
  factory GatewayUpdateMessage() => create();
  factory GatewayUpdateMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GatewayUpdateMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GatewayUpdateMessage clone() => GatewayUpdateMessage()..mergeFromMessage(this);
  GatewayUpdateMessage copyWith(void Function(GatewayUpdateMessage) updates) => super.copyWith((message) => updates(message as GatewayUpdateMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GatewayUpdateMessage create() => GatewayUpdateMessage._();
  GatewayUpdateMessage createEmptyInstance() => create();
  static $pb.PbList<GatewayUpdateMessage> createRepeated() => $pb.PbList<GatewayUpdateMessage>();
  static GatewayUpdateMessage getDefault() => _defaultInstance ??= create()..freeze();
  static GatewayUpdateMessage _defaultInstance;

  $core.String get iD => $_getS(0, '');
  set iD($core.String v) { $_setString(0, v); }
  $core.bool hasID() => $_has(0);
  void clearID() => clearField(1);

  GatewayState get state => $_getN(1);
  set state(GatewayState v) { setField(2, v); }
  $core.bool hasState() => $_has(1);
  void clearState() => clearField(2);
}

class Device extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Device', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..aOS(2, 'addr')
    ..aOS(3, 'mac')
    ..aOS(4, 'description')
    ..hasRequiredFields = false
  ;

  Device._() : super();
  factory Device() => create();
  factory Device.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Device.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Device clone() => Device()..mergeFromMessage(this);
  Device copyWith(void Function(Device) updates) => super.copyWith((message) => updates(message as Device));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Device create() => Device._();
  Device createEmptyInstance() => create();
  static $pb.PbList<Device> createRepeated() => $pb.PbList<Device>();
  static Device getDefault() => _defaultInstance ??= create()..freeze();
  static Device _defaultInstance;

  $core.String get runId => $_getS(0, '');
  set runId($core.String v) { $_setString(0, v); }
  $core.bool hasRunId() => $_has(0);
  void clearRunId() => clearField(1);

  $core.String get addr => $_getS(1, '');
  set addr($core.String v) { $_setString(1, v); }
  $core.bool hasAddr() => $_has(1);
  void clearAddr() => clearField(2);

  $core.String get mac => $_getS(2, '');
  set mac($core.String v) { $_setString(2, v); }
  $core.bool hasMac() => $_has(2);
  void clearMac() => clearField(3);

  $core.String get description => $_getS(3, '');
  set description($core.String v) { $_setString(3, v); }
  $core.bool hasDescription() => $_has(3);
  void clearDescription() => clearField(4);
}

class DeviceList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeviceList', package: const $pb.PackageName('pb'))
    ..pc<Device>(1, 'devices', $pb.PbFieldType.PM,Device.create)
    ..hasRequiredFields = false
  ;

  DeviceList._() : super();
  factory DeviceList() => create();
  factory DeviceList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DeviceList clone() => DeviceList()..mergeFromMessage(this);
  DeviceList copyWith(void Function(DeviceList) updates) => super.copyWith((message) => updates(message as DeviceList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceList create() => DeviceList._();
  DeviceList createEmptyInstance() => create();
  static $pb.PbList<DeviceList> createRepeated() => $pb.PbList<DeviceList>();
  static DeviceList getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceList _defaultInstance;

  $core.List<Device> get devices => $_getList(0);
}

class MiioGatewayDevice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MiioGatewayDevice', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..aOS(2, 'addr')
    ..aOS(3, 'key')
    ..a<Color>(4, 'color', $pb.PbFieldType.OM, Color.getDefault, Color.create)
    ..a<$core.int>(5, 'brightness', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  MiioGatewayDevice._() : super();
  factory MiioGatewayDevice() => create();
  factory MiioGatewayDevice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MiioGatewayDevice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  MiioGatewayDevice clone() => MiioGatewayDevice()..mergeFromMessage(this);
  MiioGatewayDevice copyWith(void Function(MiioGatewayDevice) updates) => super.copyWith((message) => updates(message as MiioGatewayDevice));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MiioGatewayDevice create() => MiioGatewayDevice._();
  MiioGatewayDevice createEmptyInstance() => create();
  static $pb.PbList<MiioGatewayDevice> createRepeated() => $pb.PbList<MiioGatewayDevice>();
  static MiioGatewayDevice getDefault() => _defaultInstance ??= create()..freeze();
  static MiioGatewayDevice _defaultInstance;

  $core.String get runId => $_getS(0, '');
  set runId($core.String v) { $_setString(0, v); }
  $core.bool hasRunId() => $_has(0);
  void clearRunId() => clearField(1);

  $core.String get addr => $_getS(1, '');
  set addr($core.String v) { $_setString(1, v); }
  $core.bool hasAddr() => $_has(1);
  void clearAddr() => clearField(2);

  $core.String get key => $_getS(2, '');
  set key($core.String v) { $_setString(2, v); }
  $core.bool hasKey() => $_has(2);
  void clearKey() => clearField(3);

  Color get color => $_getN(3);
  set color(Color v) { setField(4, v); }
  $core.bool hasColor() => $_has(3);
  void clearColor() => clearField(4);

  $core.int get brightness => $_get(4, 0);
  set brightness($core.int v) { $_setUnsignedInt32(4, v); }
  $core.bool hasBrightness() => $_has(4);
  void clearBrightness() => clearField(5);
}

class MiioGatewayDeviceList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MiioGatewayDeviceList', package: const $pb.PackageName('pb'))
    ..pc<MiioGatewayDevice>(1, 'miioGatewayDevices', $pb.PbFieldType.PM,MiioGatewayDevice.create)
    ..hasRequiredFields = false
  ;

  MiioGatewayDeviceList._() : super();
  factory MiioGatewayDeviceList() => create();
  factory MiioGatewayDeviceList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MiioGatewayDeviceList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  MiioGatewayDeviceList clone() => MiioGatewayDeviceList()..mergeFromMessage(this);
  MiioGatewayDeviceList copyWith(void Function(MiioGatewayDeviceList) updates) => super.copyWith((message) => updates(message as MiioGatewayDeviceList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MiioGatewayDeviceList create() => MiioGatewayDeviceList._();
  MiioGatewayDeviceList createEmptyInstance() => create();
  static $pb.PbList<MiioGatewayDeviceList> createRepeated() => $pb.PbList<MiioGatewayDeviceList>();
  static MiioGatewayDeviceList getDefault() => _defaultInstance ??= create()..freeze();
  static MiioGatewayDeviceList _defaultInstance;

  $core.List<MiioGatewayDevice> get miioGatewayDevices => $_getList(0);
}

class MiioGatewaySubDevice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MiioGatewaySubDevice', package: const $pb.PackageName('pb'))
    ..a<MiioGatewayDevice>(1, 'miioGatewayDevice', $pb.PbFieldType.OM, MiioGatewayDevice.getDefault, MiioGatewayDevice.create)
    ..aOS(2, 'iD')
    ..hasRequiredFields = false
  ;

  MiioGatewaySubDevice._() : super();
  factory MiioGatewaySubDevice() => create();
  factory MiioGatewaySubDevice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MiioGatewaySubDevice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  MiioGatewaySubDevice clone() => MiioGatewaySubDevice()..mergeFromMessage(this);
  MiioGatewaySubDevice copyWith(void Function(MiioGatewaySubDevice) updates) => super.copyWith((message) => updates(message as MiioGatewaySubDevice));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MiioGatewaySubDevice create() => MiioGatewaySubDevice._();
  MiioGatewaySubDevice createEmptyInstance() => create();
  static $pb.PbList<MiioGatewaySubDevice> createRepeated() => $pb.PbList<MiioGatewaySubDevice>();
  static MiioGatewaySubDevice getDefault() => _defaultInstance ??= create()..freeze();
  static MiioGatewaySubDevice _defaultInstance;

  MiioGatewayDevice get miioGatewayDevice => $_getN(0);
  set miioGatewayDevice(MiioGatewayDevice v) { setField(1, v); }
  $core.bool hasMiioGatewayDevice() => $_has(0);
  void clearMiioGatewayDevice() => clearField(1);

  $core.String get iD => $_getS(1, '');
  set iD($core.String v) { $_setString(1, v); }
  $core.bool hasID() => $_has(1);
  void clearID() => clearField(2);
}

class SessionConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SessionConfig', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..aOS(2, 'token')
    ..aOS(3, 'description')
    ..aOB(4, 'statusToClient')
    ..aOB(5, 'statusP2PAsClient')
    ..aOB(6, 'statusP2PAsServer')
    ..hasRequiredFields = false
  ;

  SessionConfig._() : super();
  factory SessionConfig() => create();
  factory SessionConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SessionConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SessionConfig clone() => SessionConfig()..mergeFromMessage(this);
  SessionConfig copyWith(void Function(SessionConfig) updates) => super.copyWith((message) => updates(message as SessionConfig));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SessionConfig create() => SessionConfig._();
  SessionConfig createEmptyInstance() => create();
  static $pb.PbList<SessionConfig> createRepeated() => $pb.PbList<SessionConfig>();
  static SessionConfig getDefault() => _defaultInstance ??= create()..freeze();
  static SessionConfig _defaultInstance;

  $core.String get runId => $_getS(0, '');
  set runId($core.String v) { $_setString(0, v); }
  $core.bool hasRunId() => $_has(0);
  void clearRunId() => clearField(1);

  $core.String get token => $_getS(1, '');
  set token($core.String v) { $_setString(1, v); }
  $core.bool hasToken() => $_has(1);
  void clearToken() => clearField(2);

  $core.String get description => $_getS(2, '');
  set description($core.String v) { $_setString(2, v); }
  $core.bool hasDescription() => $_has(2);
  void clearDescription() => clearField(3);

  $core.bool get statusToClient => $_get(3, false);
  set statusToClient($core.bool v) { $_setBool(3, v); }
  $core.bool hasStatusToClient() => $_has(3);
  void clearStatusToClient() => clearField(4);

  $core.bool get statusP2PAsClient => $_get(4, false);
  set statusP2PAsClient($core.bool v) { $_setBool(4, v); }
  $core.bool hasStatusP2PAsClient() => $_has(4);
  void clearStatusP2PAsClient() => clearField(5);

  $core.bool get statusP2PAsServer => $_get(5, false);
  set statusP2PAsServer($core.bool v) { $_setBool(5, v); }
  $core.bool hasStatusP2PAsServer() => $_has(5);
  void clearStatusP2PAsServer() => clearField(6);
}

class SessionList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SessionList', package: const $pb.PackageName('pb'))
    ..pc<SessionConfig>(1, 'sessionConfigs', $pb.PbFieldType.PM,SessionConfig.create)
    ..hasRequiredFields = false
  ;

  SessionList._() : super();
  factory SessionList() => create();
  factory SessionList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SessionList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SessionList clone() => SessionList()..mergeFromMessage(this);
  SessionList copyWith(void Function(SessionList) updates) => super.copyWith((message) => updates(message as SessionList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SessionList create() => SessionList._();
  SessionList createEmptyInstance() => create();
  static $pb.PbList<SessionList> createRepeated() => $pb.PbList<SessionList>();
  static SessionList getDefault() => _defaultInstance ??= create()..freeze();
  static SessionList _defaultInstance;

  $core.List<SessionConfig> get sessionConfigs => $_getList(0);
}

class PortConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PortConfig', package: const $pb.PackageName('pb'))
    ..a<Device>(1, 'device', $pb.PbFieldType.OM, Device.getDefault, Device.create)
    ..a<$core.int>(2, 'localProt', $pb.PbFieldType.O3)
    ..a<$core.int>(3, 'remotePort', $pb.PbFieldType.O3)
    ..aOS(4, 'description')
    ..aOB(5, 'remotePortStatus')
    ..aOS(6, 'mDNSInfo')
    ..hasRequiredFields = false
  ;

  PortConfig._() : super();
  factory PortConfig() => create();
  factory PortConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PortConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PortConfig clone() => PortConfig()..mergeFromMessage(this);
  PortConfig copyWith(void Function(PortConfig) updates) => super.copyWith((message) => updates(message as PortConfig));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PortConfig create() => PortConfig._();
  PortConfig createEmptyInstance() => create();
  static $pb.PbList<PortConfig> createRepeated() => $pb.PbList<PortConfig>();
  static PortConfig getDefault() => _defaultInstance ??= create()..freeze();
  static PortConfig _defaultInstance;

  Device get device => $_getN(0);
  set device(Device v) { setField(1, v); }
  $core.bool hasDevice() => $_has(0);
  void clearDevice() => clearField(1);

  $core.int get localProt => $_get(1, 0);
  set localProt($core.int v) { $_setSignedInt32(1, v); }
  $core.bool hasLocalProt() => $_has(1);
  void clearLocalProt() => clearField(2);

  $core.int get remotePort => $_get(2, 0);
  set remotePort($core.int v) { $_setSignedInt32(2, v); }
  $core.bool hasRemotePort() => $_has(2);
  void clearRemotePort() => clearField(3);

  $core.String get description => $_getS(3, '');
  set description($core.String v) { $_setString(3, v); }
  $core.bool hasDescription() => $_has(3);
  void clearDescription() => clearField(4);

  $core.bool get remotePortStatus => $_get(4, false);
  set remotePortStatus($core.bool v) { $_setBool(4, v); }
  $core.bool hasRemotePortStatus() => $_has(4);
  void clearRemotePortStatus() => clearField(5);

  $core.String get mDNSInfo => $_getS(5, '');
  set mDNSInfo($core.String v) { $_setString(5, v); }
  $core.bool hasMDNSInfo() => $_has(5);
  void clearMDNSInfo() => clearField(6);
}

class PortList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PortList', package: const $pb.PackageName('pb'))
    ..pc<PortConfig>(1, 'portConfigs', $pb.PbFieldType.PM,PortConfig.create)
    ..hasRequiredFields = false
  ;

  PortList._() : super();
  factory PortList() => create();
  factory PortList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PortList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PortList clone() => PortList()..mergeFromMessage(this);
  PortList copyWith(void Function(PortList) updates) => super.copyWith((message) => updates(message as PortList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PortList create() => PortList._();
  PortList createEmptyInstance() => create();
  static $pb.PbList<PortList> createRepeated() => $pb.PbList<PortList>();
  static PortList getDefault() => _defaultInstance ??= create()..freeze();
  static PortList _defaultInstance;

  $core.List<PortConfig> get portConfigs => $_getList(0);
}

class SOCKS5Config extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SOCKS5Config', package: const $pb.PackageName('pb'))
    ..aOS(1, 'runId')
    ..a<$core.int>(2, 'port', $pb.PbFieldType.O3)
    ..aOS(3, 'password')
    ..aOS(4, 'encType')
    ..aOS(5, 'description')
    ..hasRequiredFields = false
  ;

  SOCKS5Config._() : super();
  factory SOCKS5Config() => create();
  factory SOCKS5Config.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SOCKS5Config.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SOCKS5Config clone() => SOCKS5Config()..mergeFromMessage(this);
  SOCKS5Config copyWith(void Function(SOCKS5Config) updates) => super.copyWith((message) => updates(message as SOCKS5Config));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SOCKS5Config create() => SOCKS5Config._();
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

  $core.String get description => $_getS(4, '');
  set description($core.String v) { $_setString(4, v); }
  $core.bool hasDescription() => $_has(4);
  void clearDescription() => clearField(5);
}

class SOCKS5List extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SOCKS5List', package: const $pb.PackageName('pb'))
    ..pc<SOCKS5Config>(1, 'sOCKS5Configs', $pb.PbFieldType.PM,SOCKS5Config.create)
    ..hasRequiredFields = false
  ;

  SOCKS5List._() : super();
  factory SOCKS5List() => create();
  factory SOCKS5List.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SOCKS5List.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SOCKS5List clone() => SOCKS5List()..mergeFromMessage(this);
  SOCKS5List copyWith(void Function(SOCKS5List) updates) => super.copyWith((message) => updates(message as SOCKS5List));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SOCKS5List create() => SOCKS5List._();
  SOCKS5List createEmptyInstance() => create();
  static $pb.PbList<SOCKS5List> createRepeated() => $pb.PbList<SOCKS5List>();
  static SOCKS5List getDefault() => _defaultInstance ??= create()..freeze();
  static SOCKS5List _defaultInstance;

  $core.List<SOCKS5Config> get sOCKS5Configs => $_getList(0);
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

  HTTPConfig._() : super();
  factory HTTPConfig() => create();
  factory HTTPConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HTTPConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  HTTPConfig clone() => HTTPConfig()..mergeFromMessage(this);
  HTTPConfig copyWith(void Function(HTTPConfig) updates) => super.copyWith((message) => updates(message as HTTPConfig));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HTTPConfig create() => HTTPConfig._();
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

class HTTPList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HTTPList', package: const $pb.PackageName('pb'))
    ..pc<HTTPConfig>(1, 'hTTPConfigs', $pb.PbFieldType.PM,HTTPConfig.create)
    ..hasRequiredFields = false
  ;

  HTTPList._() : super();
  factory HTTPList() => create();
  factory HTTPList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HTTPList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  HTTPList clone() => HTTPList()..mergeFromMessage(this);
  HTTPList copyWith(void Function(HTTPList) updates) => super.copyWith((message) => updates(message as HTTPList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HTTPList create() => HTTPList._();
  HTTPList createEmptyInstance() => create();
  static $pb.PbList<HTTPList> createRepeated() => $pb.PbList<HTTPList>();
  static HTTPList getDefault() => _defaultInstance ??= create()..freeze();
  static HTTPList _defaultInstance;

  $core.List<HTTPConfig> get hTTPConfigs => $_getList(0);
}

class MDNSServiceList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MDNSServiceList', package: const $pb.PackageName('pb'))
    ..pc<MDNSService>(1, 'mDNSServices', $pb.PbFieldType.PM,MDNSService.create)
    ..hasRequiredFields = false
  ;

  MDNSServiceList._() : super();
  factory MDNSServiceList() => create();
  factory MDNSServiceList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MDNSServiceList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  MDNSServiceList clone() => MDNSServiceList()..mergeFromMessage(this);
  MDNSServiceList copyWith(void Function(MDNSServiceList) updates) => super.copyWith((message) => updates(message as MDNSServiceList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MDNSServiceList create() => MDNSServiceList._();
  MDNSServiceList createEmptyInstance() => create();
  static $pb.PbList<MDNSServiceList> createRepeated() => $pb.PbList<MDNSServiceList>();
  static MDNSServiceList getDefault() => _defaultInstance ??= create()..freeze();
  static MDNSServiceList _defaultInstance;

  $core.List<MDNSService> get mDNSServices => $_getList(0);
}

