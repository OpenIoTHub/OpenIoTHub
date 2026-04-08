import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openiothub/common_pages/utils/toast.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/utils/openiothub_desktop_layout.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, required this.baseUrl, required this.data});

  final String baseUrl;
  final Map<String, dynamic> data;

  @override
  State<SettingsPage> createState() => CasaZimaOsSettingsPageState();
}

class CasaZimaOsSettingsPageState extends State<SettingsPage> {
  bool usbAutoMount = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> listView = <Widget>[
      // 端口号设置
      // 自动挂载U盘
      ListTile(
        leading: Icon(TDIcons.server, color: Colors.orange),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(OpenIoTHubLocalizations.of(context).nas_usb_auto_mount),
          ],
        ),
        trailing: Switch(
          onChanged: (bool newValue) async {
            final dio = Dio(BaseOptions(
                baseUrl:widget.baseUrl,
                headers: {
                  "Authorization": widget.data["data"]["token"]["access_token"]
                }));
            String reqUri = "/v1/usb/usb-auto-mount";
            try {
              final response = await dio.putUri(Uri.parse(reqUri),
                  data: {"state": newValue ? "on" : "off"});
              if (!context.mounted) return;
              if (response.data["success"] == 200) {
                setState(() {
                  usbAutoMount = newValue;
                });
              }
            } catch (e) {
              if (!context.mounted) return;
              showFailed(e.toString(), context);
            }
          },
          value: usbAutoMount,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
        ),
      ),
      //  重启、关机
      ListTile(
        leading: Icon(TDIcons.server, color: Colors.orange),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(OpenIoTHubLocalizations.of(context).nas_power_control),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.power_settings_new,
            color: Colors.red,
          ),
          onPressed: () async {
            showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext buildContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return TDAlertDialog.vertical(
                    title: OpenIoTHubLocalizations.of(context).nas_power_control,
                    content: "",
                    showCloseButton: true,
                    buttons: [
                      TDDialogButtonOptions(
                          title: OpenIoTHubLocalizations.of(context)
                              .nas_system_restart,
                          action: () async {
                            final dio = Dio(BaseOptions(
                                baseUrl: widget.baseUrl,
                                headers: {
                                  "Authorization": widget.data["data"]["token"]
                                      ["access_token"]
                                }));
                            String reqUri = "/v1/sys/state/restart";
                            try {
                              final response =
                                  await dio.putUri(Uri.parse(reqUri));
                              if (!context.mounted) return;
                              if (response.data["success"] == 200) {
                                showSuccess(
                                  OpenIoTHubLocalizations.of(context).success,
                                  context,
                                );
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              showFailed(e.toString(), context);
                            }
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          theme: TDButtonTheme.danger),
                      TDDialogButtonOptions(
                          title: OpenIoTHubLocalizations.of(context)
                              .nas_system_power_off,
                          titleColor: TDTheme.of(context).brandColor7,
                          action: () async {
                            final dio = Dio(BaseOptions(
                                baseUrl: widget.baseUrl,
                                headers: {
                                  "Authorization": widget.data["data"]["token"]
                                      ["access_token"]
                                }));
                            String reqUri = "/v1/sys/state/off";
                            try {
                              final response =
                                  await dio.putUri(Uri.parse(reqUri));
                              if (!context.mounted) return;
                              if (response.data["success"] == 200) {
                                showSuccess(
                                  OpenIoTHubLocalizations.of(context).success,
                                  context,
                                );
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              showFailed(e.toString(), context);
                            }
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          theme: TDButtonTheme.danger),
                    ]);
              },
            );
          },
        ),
      )
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text(OpenIoTHubLocalizations.of(context).profile_settings),
        ),
        body: openIoTHubDesktopScrollableListBody(
          scrollable: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: listView,
            ),
          ),
        ),
    );
  }
}
