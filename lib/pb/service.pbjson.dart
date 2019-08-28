///
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const Empty$json = const {
  '1': 'Empty',
};

const MDNSService$json = const {
  '1': 'MDNSService',
  '2': const [
    const {'1': 'Name', '3': 1, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'IP', '3': 2, '4': 1, '5': 9, '10': 'IP'},
    const {'1': 'Port', '3': 3, '4': 1, '5': 5, '10': 'Port'},
    const {'1': 'MDNSInfo', '3': 4, '4': 1, '5': 9, '10': 'MDNSInfo'},
  ],
};

const Color$json = const {
  '1': 'Color',
  '2': const [
    const {'1': 'R', '3': 1, '4': 1, '5': 5, '10': 'R'},
    const {'1': 'G', '3': 2, '4': 1, '5': 5, '10': 'G'},
    const {'1': 'B', '3': 3, '4': 1, '5': 5, '10': 'B'},
    const {'1': 'A', '3': 4, '4': 1, '5': 5, '10': 'A'},
  ],
};

const GatewayState$json = const {
  '1': 'GatewayState',
  '2': const [
    const {'1': 'On', '3': 1, '4': 1, '5': 8, '10': 'On'},
    const {'1': 'Color', '3': 2, '4': 1, '5': 11, '6': '.pb.Color', '10': 'Color'},
    const {'1': 'Brightness', '3': 3, '4': 1, '5': 13, '10': 'Brightness'},
  ],
};

const GatewayUpdateMessage$json = const {
  '1': 'GatewayUpdateMessage',
  '2': const [
    const {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    const {'1': 'State', '3': 2, '4': 1, '5': 11, '6': '.pb.GatewayState', '10': 'State'},
  ],
};

const Device$json = const {
  '1': 'Device',
  '2': const [
    const {'1': 'RunId', '3': 1, '4': 1, '5': 9, '10': 'RunId'},
    const {'1': 'Addr', '3': 2, '4': 1, '5': 9, '10': 'Addr'},
    const {'1': 'Mac', '3': 3, '4': 1, '5': 9, '10': 'Mac'},
    const {'1': 'Description', '3': 4, '4': 1, '5': 9, '10': 'Description'},
  ],
};

const DeviceList$json = const {
  '1': 'DeviceList',
  '2': const [
    const {'1': 'Devices', '3': 1, '4': 3, '5': 11, '6': '.pb.Device', '10': 'Devices'},
  ],
};

const MiioGatewayDevice$json = const {
  '1': 'MiioGatewayDevice',
  '2': const [
    const {'1': 'RunId', '3': 1, '4': 1, '5': 9, '10': 'RunId'},
    const {'1': 'Addr', '3': 2, '4': 1, '5': 9, '10': 'Addr'},
    const {'1': 'Key', '3': 3, '4': 1, '5': 9, '10': 'Key'},
    const {'1': 'Color', '3': 4, '4': 1, '5': 11, '6': '.pb.Color', '10': 'Color'},
    const {'1': 'Brightness', '3': 5, '4': 1, '5': 13, '10': 'Brightness'},
  ],
};

const MiioGatewayDeviceList$json = const {
  '1': 'MiioGatewayDeviceList',
  '2': const [
    const {'1': 'MiioGatewayDevices', '3': 1, '4': 3, '5': 11, '6': '.pb.MiioGatewayDevice', '10': 'MiioGatewayDevices'},
  ],
};

const MiioGatewaySubDevice$json = const {
  '1': 'MiioGatewaySubDevice',
  '2': const [
    const {'1': 'MiioGatewayDevice', '3': 1, '4': 1, '5': 11, '6': '.pb.MiioGatewayDevice', '10': 'MiioGatewayDevice'},
    const {'1': 'ID', '3': 2, '4': 1, '5': 9, '10': 'ID'},
  ],
};

const SessionConfig$json = const {
  '1': 'SessionConfig',
  '2': const [
    const {'1': 'RunId', '3': 1, '4': 1, '5': 9, '10': 'RunId'},
    const {'1': 'Token', '3': 2, '4': 1, '5': 9, '10': 'Token'},
    const {'1': 'Description', '3': 3, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'StatusToClient', '3': 4, '4': 1, '5': 8, '10': 'StatusToClient'},
    const {'1': 'StatusP2PAsClient', '3': 5, '4': 1, '5': 8, '10': 'StatusP2PAsClient'},
    const {'1': 'StatusP2PAsServer', '3': 6, '4': 1, '5': 8, '10': 'StatusP2PAsServer'},
  ],
};

const SessionList$json = const {
  '1': 'SessionList',
  '2': const [
    const {'1': 'SessionConfigs', '3': 1, '4': 3, '5': 11, '6': '.pb.SessionConfig', '10': 'SessionConfigs'},
  ],
};

const PortConfig$json = const {
  '1': 'PortConfig',
  '2': const [
    const {'1': 'Device', '3': 1, '4': 1, '5': 11, '6': '.pb.Device', '10': 'Device'},
    const {'1': 'LocalProt', '3': 2, '4': 1, '5': 5, '10': 'LocalProt'},
    const {'1': 'RemotePort', '3': 3, '4': 1, '5': 5, '10': 'RemotePort'},
    const {'1': 'Description', '3': 4, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'RemotePortStatus', '3': 5, '4': 1, '5': 8, '10': 'RemotePortStatus'},
    const {'1': 'MDNSInfo', '3': 6, '4': 1, '5': 9, '10': 'MDNSInfo'},
  ],
};

const PortList$json = const {
  '1': 'PortList',
  '2': const [
    const {'1': 'PortConfigs', '3': 1, '4': 3, '5': 11, '6': '.pb.PortConfig', '10': 'PortConfigs'},
  ],
};

const SOCKS5Config$json = const {
  '1': 'SOCKS5Config',
  '2': const [
    const {'1': 'RunId', '3': 1, '4': 1, '5': 9, '10': 'RunId'},
    const {'1': 'Port', '3': 2, '4': 1, '5': 5, '10': 'Port'},
    const {'1': 'Password', '3': 3, '4': 1, '5': 9, '10': 'Password'},
    const {'1': 'EncType', '3': 4, '4': 1, '5': 9, '10': 'EncType'},
    const {'1': 'Description', '3': 5, '4': 1, '5': 9, '10': 'Description'},
  ],
};

const SOCKS5List$json = const {
  '1': 'SOCKS5List',
  '2': const [
    const {'1': 'SOCKS5Configs', '3': 1, '4': 3, '5': 11, '6': '.pb.SOCKS5Config', '10': 'SOCKS5Configs'},
  ],
};

const HTTPConfig$json = const {
  '1': 'HTTPConfig',
  '2': const [
    const {'1': 'RunId', '3': 1, '4': 1, '5': 9, '10': 'RunId'},
    const {'1': 'Domain', '3': 2, '4': 1, '5': 9, '10': 'Domain'},
    const {'1': 'RemoteIP', '3': 3, '4': 1, '5': 9, '10': 'RemoteIP'},
    const {'1': 'RemotePort', '3': 4, '4': 1, '5': 5, '10': 'RemotePort'},
    const {'1': 'UserName', '3': 5, '4': 1, '5': 9, '10': 'UserName'},
    const {'1': 'Password', '3': 6, '4': 1, '5': 9, '10': 'Password'},
    const {'1': 'IfHttps', '3': 7, '4': 1, '5': 8, '10': 'IfHttps'},
    const {'1': 'Description', '3': 8, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'RemotePortStatus', '3': 9, '4': 1, '5': 8, '10': 'RemotePortStatus'},
  ],
};

const HTTPList$json = const {
  '1': 'HTTPList',
  '2': const [
    const {'1': 'HTTPConfigs', '3': 1, '4': 3, '5': 11, '6': '.pb.HTTPConfig', '10': 'HTTPConfigs'},
  ],
};

const MDNSServiceList$json = const {
  '1': 'MDNSServiceList',
  '2': const [
    const {'1': 'MDNSServices', '3': 1, '4': 3, '5': 11, '6': '.pb.MDNSService', '10': 'MDNSServices'},
  ],
};

