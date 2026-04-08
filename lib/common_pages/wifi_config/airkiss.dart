import 'dart:async';
import 'dart:io';

import 'package:airkiss_dart/airkiss_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub/common_pages/wifi_config/permission.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class Airkiss extends StatefulWidget {
  const Airkiss({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Airkiss> createState() => AirkissState();
}

class AirkissState extends State<Airkiss> {
  OpenIoTHubLocalizations? localizations;
  final NetworkInfo _networkInfo = NetworkInfo();

  //  New
  final TextEditingController _ssidFilter = TextEditingController();
  final TextEditingController _bssidFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();

  bool _isLoading = false;

  String? _ssid;
  String? _bssid;
  String? _password;
  String? _msg;

  void _ssidListen() {
    if (_ssidFilter.text.isEmpty) {
      _ssid = "";
    } else {
      _ssid = _ssidFilter.text;
    }
  }

  void _bssidListen() {
    if (_bssidFilter.text.isEmpty) {
      _bssid = "";
    } else {
      _bssid = _bssidFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  @override
  void initState() {
    super.initState();
    _ssidFilter.addListener(_ssidListen);
    _bssidFilter.addListener(_bssidListen);
    _passwordFilter.addListener(_passwordListen);
  }

  @override
  void dispose() {
    _ssidFilter.removeListener(_ssidListen);
    _bssidFilter.removeListener(_bssidListen);
    _passwordFilter.removeListener(_passwordListen);
    _ssidFilter.dispose();
    _bssidFilter.dispose();
    _passwordFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    localizations = OpenIoTHubLocalizations.of(context);
    if (_ssidFilter.text.isEmpty) {
      _ssidFilter.text = localizations!.click_to_get_wifi_info;
    }
    _msg = localizations!.input_wifi_password;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child:
            _isLoading
                ? Container(
                  color: Colors.white.withValues(alpha: 0.8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LinearProgressIndicator(
                          value: 0.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.lightBlue,
                          ),
                        ),
                        Container(height: 60.0),
                        Text(
                          "${localizations!.connecting_to_router}：\n\n$_ssid(${localizations!.wifi_bssid_label}:$_bssid)\n\n$_msg",
                        ),
                      ],
                    ),
                  ),
                )
                : openIoTHubDesktopConstrainedBody(
                  maxWidth: 520,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(height: 20),
                        GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(localizations!.device_wifi_config),
                              TextField(
                                controller: _ssidFilter,
                                decoration: InputDecoration(
                                  labelText: localizations!.wifi_ssid,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  // showToast("onTap");
                                  await _reqWiFiInfo();
                                },
                              ),
                              TextField(
                                controller: _bssidFilter,
                                decoration: InputDecoration(
                                  labelText: localizations!.wifi_bssid_label,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  // showToast("onTap");
                                  await _reqWiFiInfo();
                                },
                              ),
                            ],
                          ),
                          onTap: () async {
                            // showToast("onTap");
                            await _reqWiFiInfo();
                          },
                        ),
                        TextField(
                          controller: _passwordFilter,
                          decoration: InputDecoration(
                            labelText: localizations!.input_wifi_password,
                          ),
                          obscureText: true,
                        ),
                        Container(height: 20),
                        ElevatedButton(
                          child: Text(
                            localizations!
                                .start_adding_surrounding_smart_devices,
                          ),
                          onPressed: () async {
                            if (_ssid == null || _password == null) {
                              showFailed(
                                localizations!.wifi_info_cant_be_empty,
                                context,
                              );
                              return;
                            }
                            setState(() {
                              _isLoading = true;
                              _msg =
                                  localizations!.discovering_device_please_wait;
                            });
                            //由于微信AirKiss配网和汉枫SmartLink都是使用本地的UDP端口10000进行监听所以，先进行AirKiss然后进行SmartLink
                            await _configureWiFi();
                          },
                        ),
                        Container(height: 10),
                        Text(_msg!),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Future<void> _reqWiFiInfo() async {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return TDAlertDialog(
          title: OpenIoTHubLocalizations.of(context).location_req_name,
          // Note 说明权限申请的使用目的，包括但不限于申请权限的名称、服务的具体功能、用途
          content: OpenIoTHubLocalizations.of(context).location_req_desc,
          titleColor: Colors.black,
          contentColor: Colors.redAccent,
          // backgroundColor: AppTheme.blockBgColor,
          leftBtn: TDDialogButtonOptions(
            title: OpenIoTHubLocalizations.of(context).cancel,
            // titleColor: AppTheme.color999,
            style: TDButtonStyle(backgroundColor: Colors.grey),
            action: () {
              Navigator.of(context).pop();
            },
          ),
          rightBtn: TDDialogButtonOptions(
            title: OpenIoTHubLocalizations.of(context).ok,
            style: TDButtonStyle(backgroundColor: Colors.blue),
            action: () {
              Navigator.of(context).pop();
              requestPermission().then((ret) {
                _updateConnectionStatus();
              });
            },
          ),
          rightBtnAction: () {
            Navigator.of(context).pop();
            requestPermission().then((ret) {
              _updateConnectionStatus();
            });
          },
        );
      },
    );
  }

  Future<void> _updateConnectionStatus() async {
    if (!mounted) return;
    final l10n = OpenIoTHubLocalizations.of(context);
    String? wifiName, wifiBSSID;

    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Request permissions as recommended by the plugin documentation:
        // https://github.com/fluttercommunity/plus_plugins/tree/main/packages/network_info_plus/network_info_plus
        if (await Permission.locationWhenInUse.request().isGranted) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = l10n.wifi_name_permission_denied;
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException {
      wifiName = l10n.wifi_name_read_failed;
    }

    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Request permissions as recommended by the plugin documentation:
        // https://github.com/fluttercommunity/plus_plugins/tree/main/packages/network_info_plus/network_info_plus
        if (await Permission.locationWhenInUse.request().isGranted) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = l10n.wifi_bssid_permission_denied;
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException {
      wifiBSSID = l10n.wifi_bssid_read_failed;
    }

    if (!mounted) return;
    setState(() {
      _ssidFilter.text = wifiName!.replaceAll("\"", "");
      _bssidFilter.text = wifiBSSID!;

      _msg = localizations!.please_input_2p4g_wifi_password;
    });
    showSuccess(localizations!.wifi_info_filled, context);
  }

  Future<bool> _configureWiFi() async {
    try {
      AirkissOption option = AirkissOption();
      option.timegap = 1000;
      option.trycount = 20;
      AirkissConfig ac = AirkissConfig(option: option);
      AirkissResult v = await ac.config(_ssid!, _password!);
      setState(() {
        _isLoading = false;
        _msg = localizations!.airkiss_device_wifi_config_success;
      });
      if (v.deviceAddress != null) {
        return true;
      }
    } on PlatformException catch (e) {
      if (!mounted) return false;
      final msg = e.message ?? '';
      final output = OpenIoTHubLocalizations.of(
        context,
      ).airkiss_configure_failed(msg);
      setState(() {
        _isLoading = false;
        _msg = output;
      });
    }
    return false;
  }
}
