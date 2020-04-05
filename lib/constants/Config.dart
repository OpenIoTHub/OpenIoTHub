class Config {
//  serve web static file
  static final String webStaticIp = "127.0.0.1";
  static final int webStaticPort = 9000;

  static final String webgRpcIp = "127.0.0.1";

//  static final String webgRpcIp = "192.168.1.102";
  static final int webgRpcPort = 2080;
  static final int webRestfulPort = 1081;

  static final String mdnsTypeExplorer = '_services._dns-sd._udp';

  static final String mdnsBaseTcpService = '_tcp.local.';
  static final String mdnsBaseUdpService = '_udp.local.';

  static final String mdnsIoTDeviceService = '_iotdevice._tcp';
  static final String mdnsGatewayService = '_openiothub-gateway._tcp';
}
