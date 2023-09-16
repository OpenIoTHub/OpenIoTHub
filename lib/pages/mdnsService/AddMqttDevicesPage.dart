import 'package:flutter/material.dart';
import 'package:openiothub/pages/mdnsService/thirdDevice/zipDevicesPage.dart';

class AddMqttDevicesPage extends StatefulWidget {
  @override
  _AddMqttDevicesPageState createState() => _AddMqttDevicesPageState();
}

class _AddMqttDevicesPageState extends State<AddMqttDevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("添加mqtt设备"),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              //第一个功能项
              title: Text('添加zip的设备(zDC1,zTC1...)'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ZipDevicesPage();
                    },
                  ),
                );
              }),
        ]));
  }
}
