import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/utils/openiothub_desktop_layout.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

class AddMqttDevicesPage extends StatefulWidget {
  const AddMqttDevicesPage({super.key});

  @override
  State<AddMqttDevicesPage> createState() => AddMqttDevicesPageState();
}

class AddMqttDevicesPageState extends State<AddMqttDevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(OpenIoTHubLocalizations.of(context).add_mqtt_devices),
      ),
      body: _addMqttBody(context),
    );
  }

  Widget _addMqttBody(BuildContext context) {
    final list = ListView(
      children: <Widget>[
        ListTile(
          title: Text(OpenIoTHubLocalizations.of(context).add_zip_devices),
          trailing: const Icon(Icons.arrow_right),
          onTap: () async {
            context.push(AppRoutes.zipDevices);
          },
        ),
      ],
    );
    return openIoTHubDesktopConstrainedBody(
      maxWidth: 560,
      child:
          openIoTHubUseDesktopHomeLayout
              ? Scrollbar(thumbVisibility: true, child: list)
              : list,
    );
  }
}
