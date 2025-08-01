import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_plugin/utils/toast.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, required this.baseUrl, required this.data});

  final String baseUrl;
  final Map<String, dynamic> data;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool usb_auto_mount = true;

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
            Text("USB auto mount"),
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
              if (response.data["success"] == 200) {
                setState(() {
                  usb_auto_mount = newValue;
                });
              }
            } catch (e) {
              show_failed(e.toString(), context);
            }
          },
          value: usb_auto_mount,
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
            Text("Power Control"),
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
                    title: "Power Control",
                    content: "",
                    showCloseButton: true,
                    buttons: [
                      TDDialogButtonOptions(
                          title: 'Restart',
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
                              if (response.data["success"] == 200) {
                                show_success("success!", context);
                              }
                            } catch (e) {
                              show_failed(e.toString(), context);
                            }
                            Navigator.pop(context);
                          },
                          theme: TDButtonTheme.danger),
                      TDDialogButtonOptions(
                          title: 'PowerOff',
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
                              if (response.data["success"] == 200) {
                                show_success("success!", context);
                              }
                            } catch (e) {
                              show_failed(e.toString(), context);
                            }
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
          title: Text("Settings"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: listView,
            ),
          ),
        ));
  }
}
