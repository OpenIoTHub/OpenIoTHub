class Config {
// flutter serve web static file
  static String webStaticIp = "127.0.0.1";
  static int webStaticPort = 9000;

  // 修改上面的变量名称
  static String iotManagerGrpcIp = "api.iot-manager.iothub.cloud";
  // static int iotManagerGrpcPort = 8881;
  static int iotManagerGrpcPort = 50051;
  static String iotManagerHttpIp = "api.iot-manager.iothub.cloud";

  // 本机网关的grpc地址
  static String gatewayGrpcIp = "127.0.0.1";
  static int gatewayGrpcPort = 55443;

  // go后台服务本机webserver
  static String webgRpcIp = "127.0.0.1";
  static int webgRpcPort = 2080;
//http的api，目前主要是ssh的websocket
  static int webRestfulPort = 2080;

  static String mdnsBaseTcpService = '_tcp.local.';
  static String mdnsBaseUdpService = '_udp.local.';

  static String mdnsTypeExplorer = '_services._dns-sd._udp';

  static String mdnsIoTDeviceService = '_iotdevice._tcp';
  static String mdnsGatewayService = '_openiothub-gateway._tcp';
}
