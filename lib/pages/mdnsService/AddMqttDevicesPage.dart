import 'package:flutter/material.dart';
import 'package:openiothub/pages/mdnsService/thirdDevice/zipDevicesPage.dart';

class AddMqttDevicesPage extends StatefulWidget {
  const AddMqttDevicesPage({super.key});

  @override
  _AddMqttDevicesPageState createState() => _AddMqttDevicesPageState();
}

class _AddMqttDevicesPageState extends State<AddMqttDevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("添加mqtt设备"),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              //第一个功能项
              title: const Text('添加zip的设备(zDC1,zTC1...)'),
              trailing: const Icon(Icons.arrow_right),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const ZipDevicesPage();
                    },
                  ),
                );
              }),
        ]));
  }
}
