import 'dart:convert';
import 'dart:io';

import 'package:openiothub_grpc_api/proto/manager/mqttDeviceManager.pb.dart';
import 'package:openiothub/network/logging/network_log.dart';

class ZipLocalDevice {
  String name;
  String ip;
  String mac;
  String type;
  String typeName;

  ZipLocalDevice(this.name, this.ip, this.mac, this.type, this.typeName);

  Future<void> configMqttServer(MqttInfo mqttInfo) async {
    String config =
        '{"mac":"$mac","setting":{"mqtt_uri":"${mqttInfo.mqttServerHost}","mqtt_port":${mqttInfo.mqttServerPort},"mqtt_user":"${mqttInfo.mqttClientUserName}","mqtt_password":"${mqttInfo.mqttClientUserPassword}"}}';
    await send(config);
  }

  Future<void> send(String message) async {
    var destinationAddress = InternetAddress("255.255.255.255");
    RawDatagramSocket socket =
        await RawDatagramSocket.bind(InternetAddress.anyIPv4, 10181);
    socket.broadcastEnabled = true;
    socket.send(message.codeUnits, destinationAddress, 10182);
    await Future.delayed(Duration(seconds: 1));
    socket.send(message.codeUnits, destinationAddress, 10182);
    await Future.delayed(Duration(seconds: 1));
    socket.send(message.codeUnits, destinationAddress, 10182);
    socket.close();
  }

  static ZipLocalDevice fromMap(Map<String, dynamic> device) {
    ZipLocalDevice zipLocalDevice = ZipLocalDevice(
        device["name"].toString(),
        device["ip"].toString(),
        device["mac"].toString(),
        device["type"].toString(),
        device["typeName"].toString());
    return zipLocalDevice;
  }

  @override
  String toString() {
    return '{name: $name, ip: $ip, mac: $mac, type: $type, typeName: $typeName}';
  }
}

Future<List<ZipLocalDevice>> findZipDevicesFromLocal(int timeOut) async {
  var destinationAddress = InternetAddress("255.255.255.255");
  List<ZipLocalDevice> zipLocalDeviceList = [];
  await RawDatagramSocket.bind(InternetAddress.anyIPv4, 10181)
      .then((RawDatagramSocket socket) async {
    netLog('ZipDevice', 'Datagram socket ready to receive');
    netLog('ZipDevice', '${socket.address.address}:${socket.port}');
    socket.broadcastEnabled = true;
    socket.send(
        '{"cmd":"device report"}'.codeUnits, destinationAddress, 10182);
    socket.listen((RawSocketEvent e) {
      Datagram? d = socket.receive();
      if (d == null) {
        return;
      }
      String message = String.fromCharCodes(d.data).trim();
      netLog('ZipDevice',
          'Datagram from ${d.address.address}:${d.port}: $message');
      Map<String, dynamic> device = jsonDecode(message);
      netLog('ZipDevice', '$device');
      //去掉非本格式数据
      if (!device.containsKey("name") ||
          !device.containsKey("ip") ||
          !device.containsKey("mac") ||
          !device.containsKey("type") ||
          !device.containsKey("typeName")) {
        return;
      }
      ZipLocalDevice zipLocalDevice = ZipLocalDevice.fromMap(device);
      //去重
      for (int i = 0; i < zipLocalDeviceList.length; i++) {
        if (zipLocalDeviceList[i].mac == zipLocalDevice.mac) {
          return;
        }
      }
      zipLocalDeviceList.add(zipLocalDevice);
    });
    socket.send(
        '{"cmd":"device report"}'.codeUnits, destinationAddress, 10182);
    await Future.delayed(Duration(seconds: timeOut))
        .then((value) => socket.close());
    netLog('ZipDevice', 'findZipDevicesFromLocal: ${zipLocalDeviceList.length}');
  });
  return zipLocalDeviceList;
}

// main() async {
//   List<ZipLocalDevice> zipLocalDeviceList = await findZipDevicesFromLocal(3);
//   print(zipLocalDeviceList.length);
//   if (zipLocalDeviceList != null) {
//     await zipLocalDeviceList.forEach((ZipLocalDevice zipLocalDevice) {
//       print("main:$zipLocalDevice");
//       // zipLocalDevice.send('{"mac":"${zipLocalDevice.mac}","setting":{"name":"${zipLocalDevice.mac}"}}');
//       // zipLocalDevice.send('{"mac":"${zipLocalDevice.mac}","setting":{"mqtt_uri":null}}');
//       MqttInfo mqttInfo = MqttInfo();
//       mqttInfo.mqttServerHost="192.168.123.118";
//       mqttInfo.mqttServerPort=1883;
//       zipLocalDevice.configMqttServer(mqttInfo);
//     });
//   }
//   await Future.delayed(Duration(seconds: 1));
// }
