//RGBALed:https://github.com/iotdevice/phicomm_dc1
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:openiothub_plugin/utils/ip.dart';

import '../../../../models/PortServiceInfo.dart';

class RGBALedPage extends StatefulWidget {
  RGBALedPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.rgbaLed";
  final PortServiceInfo device;

  @override
  _RGBALedPageState createState() => _RGBALedPageState();
}

class _RGBALedPageState extends State<RGBALedPage> {
  static const Color onColor = Colors.green;
  static const Color offColor = Colors.red;

  static const Map<String, int> modes = {
    "Static": 0,
    "Blink": 1,
    "Breath": 2,
    "Color Wipe": 3,
    "Color Wipe Inverse": 4,
    "Color Wipe Reverse": 5,
    "Color Wipe Reverse Inverse": 6,
    "Color Wipe Random": 7,
    "Random Color": 8,
    "Single Dynamic": 9,
    "Multi Dynamic": 10,
    "Rainbow": 11,
    "Rainbow Cycle": 12,
    "Scan": 13,
    "Dual Scan": 14,
    "Fade": 15,
    "Theater Chase": 16,
    "Theater Chase Rainbow": 17,
    "Running Lights": 18,
    "Twinkle": 19,
    "Twinkle Random": 20,
    "Twinkle Fade": 21,
    "Twinkle Fade Random": 22,
    "Sparkle": 23,
    "Flash Sparkle": 24,
    "Hyper Sparkle": 25,
    "Strobe": 26,
    "Strobe Rainbow": 27,
    "Multi Strobe": 28,
    "Blink Rainbow": 29,
    "Chase White": 30,
    "Chase Color": 31,
    "Chase Random": 32,
    "Chase Rainbow": 33,
    "Chase Flash": 34,
    "Chase Flash Random": 35,
    "Chase Rainbow White": 36,
    "Chase Blackout": 37,
    "Chase Blackout Rainbow": 38,
    "Color Sweep Random": 39,
    "Running Color": 40,
    "Running Red Blue": 41,
    "Running Random": 42,
    "Larson Scanner": 43,
    "Comet": 44,
    "Fireworks": 45,
    "Fireworks Random": 46,
    "Merry Christmas": 47,
    "Fire Flicker": 48,
    "Fire Flicker (soft)": 49,
    "Fire Flicker (intense)": 50,
    "Circus Combustus": 51,
    "Halloween": 52,
    "Bicolor Chase": 53,
    "Tricolor Chase": 54,
    "ICU": 55,
    "Custom 0": 56,
    "Custom 1": 57,
    "Custom 2": 58,
    "Custom 3": 59
  };

  int _currentModes = 0;

  bool _requsting = false;

  static const String color = "color";

  Map<String, dynamic> _status = Map.from({
    color: Colors.blue,
  });

  @override
  void initState() {
    super.initState();
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.info!["name"]!),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                // color: Colors.white,
              ),
              onPressed: () {
                _setting();
              }),
          IconButton(
              icon: Icon(
                Icons.file_upload,
                // color: Colors.white,
              ),
              onPressed: () {
                _ota();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.green,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text("${OpenIoTHubPluginLocalizations.of(context).effect}："),
                  DropdownButton<int>(
                    value: _currentModes,
                    onChanged: _setMode,
                    items: _getModesList(),
                  ),
                ])),
            SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _status[color],
                onColorChanged: _changeColorStatus,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(
                      "${OpenIoTHubPluginLocalizations.of(context).switch_bottom}："),
                  Switch(
                    onChanged: (_) {
                      _changeSwitchStatus();
                    },
                    value: _status[color].alpha == 0 ? false : true,
                    activeColor: onColor,
                    inactiveThumbColor: offColor,
                  ),
                ])),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${OpenIoTHubPluginLocalizations.of(context).speed}："),
                  IconButton(
                    icon: Icon(Icons.arrow_drop_up),
                    onPressed: () {
                      _setSpeed("+");
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      _setSpeed("-");
                    },
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  _setting() async {
    // TODO 设备设置
    TextEditingController _name_controller = TextEditingController.fromValue(
        TextEditingValue(text: widget.device.info!["name"]!));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
                    "${OpenIoTHubPluginLocalizations.of(context).setting_name}："),
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _name_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText:
                            OpenIoTHubPluginLocalizations.of(context).name,
                      ),
                    )
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text(OpenIoTHubPluginLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child:
                        Text(OpenIoTHubPluginLocalizations.of(context).modify),
                    onPressed: () async {
                      try {
                        String url =
                            "http://${widget.device.addr}:${widget.device.port}/rename?name=${_name_controller.text}";
                        http
                            .get(Uri.parse(url))
                            .timeout(const Duration(seconds: 2))
                            .then((_) {
                          setState(() {
                            widget.device.info!["name"] = _name_controller.text;
                          });
                        });
                      } catch (e) {
                        print(e.toString());
                        return;
                      }
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  _info() async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  _ota() async {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
                    "${OpenIoTHubPluginLocalizations.of(context).upgrade_firmware}："),
                content: SizedBox.expand(
                    child: UploadOTAPage(
                  url:
                      "http://${widget.device.addr}:${widget.device.port}/update",
                  key: UniqueKey(),
                )),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text(OpenIoTHubPluginLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }

  _changeSwitchStatus() async {
    String url;
    if (_status[color].alpha == 0) {
      url = "http://${widget.device.addr}:${widget.device.port}/set?b=255";
    } else {
      url = "http://${widget.device.addr}:${widget.device.port}/set?b=0";
    }
    try {
      await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/set',
              queryParameters: {"b": _status[color].alpha == 0 ? 255 : 0}))
          .timeout(const Duration(seconds: 2));
      setState(() {
        _status[color] = Color.fromARGB(_status[color].alpha == 0 ? 255 : 0,
            _status[color].red, _status[color].green, _status[color].blue);
        ;
      });
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _changeColorStatus(Color c) async {
    Color tempColor = Color.fromARGB(0, c.red, c.green, c.blue);
    String url =
        "http://${widget.device.addr}:${widget.device.port}/set?c=${tempColor.value.toRadixString(16)}&b=${c.alpha}";
    try {
      if (!_requsting) {
        _requsting = true;
        await http
            .get(Uri(
                scheme: 'http',
                host: widget.device.addr.endsWith(".local")
                    ? await get_ip_by_domain(widget.device.addr)
                    : widget.device.addr,
                port: widget.device.port,
                path: '/set',
                queryParameters: {
                  "c": tempColor.value.toRadixString(16),
                  "b": c.alpha,
                }))
            .timeout(const Duration(seconds: 2));
        setState(() {
          _status[color] = c;
        });
      }
    } catch (e) {
      print(e.toString());
      return;
    }
    setState(() {
      _status[color] = c;
    });
    _requsting = false;
  }

  List<DropdownMenuItem<int>> _getModesList() {
    List<DropdownMenuItem<int>> l = [];
    modes.forEach((String k, int v) {
      l.add(DropdownMenuItem<int>(
        value: v,
        child: Text(k),
      ));
    });
    return l;
  }

  _setMode(int? newValue) async {
    String url =
        "http://${widget.device.addr}:${widget.device.port}/set?m=${newValue.toString()}";
    try {
      await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/set',
              queryParameters: {
                "m": newValue.toString(),
              }))
          .timeout(const Duration(seconds: 2));
      setState(() {
        _currentModes = newValue!;
      });
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _setSpeed(String cmd) async {
    String url =
        "http://${widget.device.addr}:${widget.device.port}/set?s=${cmd}";
    try {
      await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/set',
              queryParameters: {
                "s": cmd,
              }))
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}
