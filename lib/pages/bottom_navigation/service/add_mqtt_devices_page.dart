import 'package:flutter/material.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

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
          title: Text(OpenIoTHubLocalizations.of(context).add_mqtt_devices),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              //第一个功能项
              title: Text(OpenIoTHubLocalizations.of(context).add_zip_devices),
              trailing: const Icon(Icons.arrow_right),
              onTap: () async {
                Navigator.of(context).pushNamed(AppRoutes.zipDevices);
              }),
        ]));
  }
}
