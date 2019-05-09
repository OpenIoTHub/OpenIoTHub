///
//  Generated code. Do not modify.
//  source: service.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

const TCPConfig$json = const {
  '1': 'TCPConfig',
  '2': const [
    const {'1': 'RunId', '3': 1, '4': 1, '5': 9, '10': 'RunId'},
    const {'1': 'LocalIP', '3': 2, '4': 1, '5': 9, '10': 'LocalIP'},
    const {'1': 'LocalProt', '3': 3, '4': 1, '5': 5, '10': 'LocalProt'},
    const {'1': 'RemoteIP', '3': 4, '4': 1, '5': 9, '10': 'RemoteIP'},
    const {'1': 'RemotePort', '3': 5, '4': 1, '5': 5, '10': 'RemotePort'},
    const {'1': 'Description', '3': 6, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'RemotePortStatus', '3': 7, '4': 1, '5': 8, '10': 'RemotePortStatus'},
  ],
};

const UDPConfig$json = const {
  '1': 'UDPConfig',
  '2': const [
    const {'1': 'RunId', '3': 1, '4': 1, '5': 9, '10': 'RunId'},
    const {'1': 'LocalIP', '3': 2, '4': 1, '5': 9, '10': 'LocalIP'},
    const {'1': 'LocalProt', '3': 3, '4': 1, '5': 5, '10': 'LocalProt'},
    const {'1': 'RemoteIP', '3': 4, '4': 1, '5': 9, '10': 'RemoteIP'},
    const {'1': 'RemotePort', '3': 5, '4': 1, '5': 5, '10': 'RemotePort'},
    const {'1': 'Description', '3': 6, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'RemotePortStatus', '3': 7, '4': 1, '5': 8, '10': 'RemotePortStatus'},
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

const FTPConfig$json = const {
  '1': 'FTPConfig',
  '2': const [
    const {'1': 'RunId', '3': 1, '4': 1, '5': 9, '10': 'RunId'},
    const {'1': 'LocalIP', '3': 2, '4': 1, '5': 9, '10': 'LocalIP'},
    const {'1': 'IPRewriteSet', '3': 3, '4': 1, '5': 9, '10': 'IPRewriteSet'},
    const {'1': 'LocalProt', '3': 4, '4': 1, '5': 5, '10': 'LocalProt'},
    const {'1': 'RemoteIP', '3': 5, '4': 1, '5': 9, '10': 'RemoteIP'},
    const {'1': 'RemotePort', '3': 6, '4': 1, '5': 5, '10': 'RemotePort'},
    const {'1': 'Description', '3': 7, '4': 1, '5': 9, '10': 'Description'},
    const {'1': 'RemotePortStatus', '3': 8, '4': 1, '5': 8, '10': 'RemotePortStatus'},
  ],
};

const SOCKS5Config$json = const {
  '1': 'SOCKS5Config',
  '2': const [
    const {'1': 'RunId', '3': 1, '4': 1, '5': 9, '10': 'RunId'},
    const {'1': 'Port', '3': 2, '4': 1, '5': 5, '10': 'Port'},
    const {'1': 'Password', '3': 3, '4': 1, '5': 9, '10': 'Password'},
    const {'1': 'EncType', '3': 4, '4': 1, '5': 9, '10': 'EncType'},
  ],
};

const OpResult$json = const {
  '1': 'OpResult',
  '2': const [
    const {'1': 'Code', '3': 1, '4': 1, '5': 9, '10': 'Code'},
    const {'1': 'Message', '3': 2, '4': 1, '5': 9, '10': 'Message'},
  ],
};

const TCPList$json = const {
  '1': 'TCPList',
  '2': const [
    const {'1': 'TCPConfigs', '3': 1, '4': 3, '5': 11, '6': '.pb.TCPConfig', '10': 'TCPConfigs'},
  ],
};

const UDPList$json = const {
  '1': 'UDPList',
  '2': const [
    const {'1': 'UDPConfigs', '3': 1, '4': 3, '5': 11, '6': '.pb.UDPConfig', '10': 'UDPConfigs'},
  ],
};

const HTTPList$json = const {
  '1': 'HTTPList',
  '2': const [
    const {'1': 'HTTPConfigs', '3': 1, '4': 3, '5': 11, '6': '.pb.HTTPConfig', '10': 'HTTPConfigs'},
  ],
};

const FTPList$json = const {
  '1': 'FTPList',
  '2': const [
    const {'1': 'FTPConfigs', '3': 1, '4': 3, '5': 11, '6': '.pb.FTPConfig', '10': 'FTPConfigs'},
  ],
};

const SOCKS5List$json = const {
  '1': 'SOCKS5List',
  '2': const [
    const {'1': 'SOCKS5Configs', '3': 1, '4': 3, '5': 11, '6': '.pb.SOCKS5Config', '10': 'SOCKS5Configs'},
  ],
};

const Empty$json = const {
  '1': 'Empty',
};

