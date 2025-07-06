//PhicommR1Controler:https://github.com/IoTDevice/phicomm-r1-controler
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:openiothub_plugin/utils/ip.dart';
import 'package:openiothub_plugin/utils/toast.dart';

import '../../../../models/PortServiceInfo.dart';

class PhicommR1ControlerPage extends StatefulWidget {
  PhicommR1ControlerPage({required Key key, required this.device})
      : super(key: key);

  static final String modelName = "com.iotserv.devices.phicomm-r1-controler";
  final PortServiceInfo device;

  @override
  _PhicommR1ControlerPageState createState() => _PhicommR1ControlerPageState();
}

class _PhicommR1ControlerPageState extends State<PhicommR1ControlerPage> {
  static const int _up = 24;
  static const int _off = 164;
  static const int _down = 25;
  int _currentKey = 1;
  String _currentPackage = "android";
  List<String> _listPackages = [];
  TextEditingController _cmd_controller =
      TextEditingController.fromValue(TextEditingValue(text: ""));
  TextEditingController _adb_cmd_controller =
      TextEditingController.fromValue(TextEditingValue(text: ""));
  static const Map<int, String> keyevents = {
    1: "按键 Soft Left",
    2: "按键 Soft Right",
    3: "按键 Home",
    4: "返回键",
    5: "拨号键",
    6: "挂机键",
    7: "按键0",
    8: "按键1",
    9: "按键2",
    10: "按键3",
    11: "按键4",
    12: "按键5",
    13: "按键6",
    14: "按键7",
    15: "按键8",
    16: "按键9",
    17: "按键*",
    18: "按键#",
    19: "导航键向上",
    20: "导航键向下",
    21: "导航键向左",
    22: "导航键向右",
    23: "导航键确定键",
    24: "音量增加键",
    25: "音量减小键",
    26: "电源键",
    27: "拍照键",
    28: "按键 Clear",
    29: "按键 A",
    30: "按键 B",
    31: "按键 C",
    32: "按键 D",
    33: "按键 E",
    34: "按键 F",
    35: "按键 G",
    36: "按键 H",
    37: "按键 I",
    38: "按键 J",
    39: "按键 K",
    40: "按键 L",
    41: "按键 M",
    42: "按键 N",
    43: "按键 O",
    44: "按键 P",
    45: "按键 Q",
    46: "按键 R",
    47: "按键 S",
    48: "按键 T",
    49: "按键 U",
    50: "按键 V",
    51: "按键 W",
    52: "按键 X",
    53: "按键 Y",
    54: "按键 Z",
    55: "按键 ,",
    56: "按键 .",
    57: "Alt + Left",
    58: "Alt + Right",
    59: "Shift + Left",
    60: "Shift + Right",
    61: "Tab 键",
    62: "空格键",
    63: "按键 Symbol modifier",
    64: "按键 Explorer special function",
    65: "按键 Envelope special function",
    66: "回车键",
    67: "退格键",
    68: "按键 `",
    69: "按键 -",
    70: "按键 =",
    71: "按键 [",
    72: "按键 ]",
    73: "按键 \\",
    74: "按键 ;",
    75: "按键单引号",
    76: "按键 /",
    77: "按键 @",
    78: "按键 Number modifier",
    79: "按键 Headset Hook",
    80: "拍照 对焦键",
    81: "按键 +",
    82: "菜单键",
    83: "通知键",
    84: "搜索键",
    85: "",
    86: "多媒体键 停止",
    87: "多媒体键 下一首",
    88: "多媒体键 上一首",
    89: "多媒体键 快退",
    90: "多媒体键 快进",
    91: "话筒静音键",
    92: "向上翻页键",
    93: "向下翻页键",
    94: "按键 Picture Symbols modifier",
    95: "按键 Switch Charset modifier",
    96: "游戏手柄按钮 A",
    97: "游戏手柄按钮 B",
    98: "游戏手柄按钮 C",
    99: "游戏手柄按钮 X",
    100: "游戏手柄按钮 Y",
    101: "游戏手柄按钮 Z",
    102: "游戏手柄按钮 L1",
    103: "游戏手柄按钮 R1",
    104: "游戏手柄按钮 L2",
    105: "游戏手柄按钮 R2",
    106: "Left Thumb Button",
    107: "Right Thumb Button",
    108: "游戏手柄按钮 Start",
    109: "游戏手柄按钮 Select",
    110: "游戏手柄按钮 Mode",
    111: "ESC 键",
    112: "删除键",
    113: "Control + Left",
    114: "Control + Right",
    115: "大写锁定键",
    116: "滚动锁定键",
    117: "按键 Left Meta modifier",
    118: "按键 Right Meta modifier",
    119: "按键 Function modifier",
    120: "按键 System Request / Print Screen",
    121: "Break/Pause键",
    122: "光标移动到开始键",
    123: "光标移动到末尾键",
    124: "插入键",
    125: "按键 Forward",
    126: "多媒体键 播放",
    127: "多媒体键 暂停",
    128: "多媒体键 关闭",
    129: "多媒体键 弹出",
    130: "多媒体键 录音",
    131: "按键 F1",
    132: "按键 F2",
    133: "按键 F3",
    134: "按键 F4",
    135: "按键 F5",
    136: "按键 F6",
    137: "按键 F7",
    138: "按键 F8",
    139: "按键 F9",
    140: "按键 F10",
    141: "按键 F11",
    142: "按键 F12",
    143: "小键盘锁",
    144: "小键盘按键0",
    145: "小键盘按键1",
    146: "小键盘按键2",
    147: "小键盘按键3",
    148: "小键盘按键4",
    149: "小键盘按键5",
    150: "小键盘按键6",
    151: "小键盘按键7",
    152: "小键盘按键8",
    153: "小键盘按键9",
    154: "小键盘按键/",
    155: "小键盘按键*",
    156: "小键盘按键-",
    157: "小键盘按键+",
    158: "小键盘按键.",
    159: "小键盘按键,",
    160: "小键盘按键回车",
    161: "小键盘按键=",
    162: "小键盘按键(",
    163: "小键盘按键)",
    164: "扬声器静音键",
    165: "按键 Info",
    166: "按键 Channel up",
    167: "按键 Channel down",
    168: "放大键",
    169: "缩小键",
    170: "按键 TV",
    171: "按键 Window",
    172: "按键 Guide",
    173: "按键 DVR",
    174: "按键 Bookmark",
    175: "按键 Toggle captions",
    176: "按键 Settings",
    177: "按键 TV power",
    178: "按键 TV input",
    179: "按键 Set-top-box power",
    180: "按键 Set-top-box input",
    181: "按键 A/V Receiver power",
    182: "按键 A/V Receiver input",
    183: "按键 Red “programmable",
    184: "按键 Green “programmable",
  };

  @override
  void initState() {
    super.initState();
    _getInstalledPackages();
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
                Icons.info,
                color: Colors.green,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("adb操作(kill/start/reconnect):"),
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  color: Colors.red,
                  onPressed: () {
                    _doAdbCmd("kill-server");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  color: Colors.green,
                  onPressed: () {
                    _doAdbCmd("start-server");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.autorenew),
                  color: Colors.greenAccent,
                  onPressed: () {
                    _doAdbCmd("reconnect offline");
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("关机/重启:"),
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  color: Colors.red,
                  onPressed: () {
                    _doCmd("shutdown");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.autorenew),
                  color: Colors.yellow,
                  onPressed: () {
                    _doCmd("reboot");
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("音量控制:"),
                IconButton(
                  icon: Icon(Icons.volume_down),
                  color: Colors.cyan,
                  onPressed: () {
                    _Keyevent(_down);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.volume_off),
                  color: Colors.red,
                  onPressed: () {
                    _Keyevent(_off);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  color: Colors.orange,
                  onPressed: () {
                    _Keyevent(_up);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text("媒体播放控制:")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 86: "多媒体键 停止",
                TextButton(
                  child: Text("停止"),
                  onPressed: () {
                    _Keyevent(86);
                  },
                ),
                // 87: "多媒体键 下一首",
                TextButton(
                  child: Text("下一首"),
                  onPressed: () {
                    _Keyevent(87);
                  },
                ),
                // 88: "多媒体键 上一首",
                TextButton(
                  child: Text("上一首"),
                  onPressed: () {
                    _Keyevent(88);
                  },
                ),
                // 89: "多媒体键 快退",
                TextButton(
                  child: Text("快退"),
                  onPressed: () {
                    _Keyevent(89);
                  },
                ),
                // 90: "多媒体键 快进",
                TextButton(
                  child: Text("快进"),
                  onPressed: () {
                    _Keyevent(90);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 126: "多媒体键 播放",
                TextButton(
                  child: Text("播放"),
                  onPressed: () {
                    _Keyevent(126);
                  },
                ),
                // 127: "多媒体键 暂停",
                TextButton(
                  child: Text("暂停"),
                  onPressed: () {
                    _Keyevent(127);
                  },
                ),
                // 128: "多媒体键 关闭",
                TextButton(
                  child: Text("关闭"),
                  onPressed: () {
                    _Keyevent(128);
                  },
                ),
                // 129: "多媒体键 弹出",
                TextButton(
                  child: Text("弹出"),
                  onPressed: () {
                    _Keyevent(129);
                  },
                ),
                // 130: "多媒体键 录音",
                TextButton(
                  child: Text("录音"),
                  onPressed: () {
                    _Keyevent(130);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text("查看屏幕截图"),
                  onPressed: () {
                    _showImage();
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _cmd_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '请输入需要在安卓上执行的命令',
                    helperText: 'shell cmd',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text("开始执行上述命令到安卓"),
                  onPressed: () {
                    _doCmd(_cmd_controller.text);
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _adb_cmd_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '请输入需要执行adb命令的参数，如:kill-server',
                    helperText: 'adb cmd args',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text("开始执行上述adb命令"),
                  onPressed: () {
                    _doAdbCmd(_adb_cmd_controller.text);
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("输入按键:"),
                DropdownButton<int>(
                  value: _currentKey,
                  onChanged: _Keyevent,
                  items: _getModesList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text("安装apk程序"),
                  onPressed: () {
                    _installApk();
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("选择需要卸载的软件:"),
                DropdownButton<String>(
                  value: _currentPackage,
                  onChanged: _removePackage,
                  items: _getPackagesList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      _getInstalledPackages();
                    },
                    child: Text("刷新软件包列表")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      _doCmd("settings put global bluetooth_on 1");
                      _doCmd("svc bluetooth enable");
                    },
                    child: Text("打开蓝牙")),
                TextButton(
                    onPressed: () {
                      _doCmd("settings put global bluetooth_on 0");
                      _doCmd("svc bluetooth disable");
                    },
                    child: Text("关闭蓝牙")),
                TextButton(
                    onPressed: () {
                      _getBluetoothStatus();
                    },
                    child: Text("获取蓝牙状态")),
              ],
            ),
            //TODO  原厂配网和非原厂配网
          ])),
    );
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

  _Keyevent(int? key) async {
    setState(() {
      _currentKey = key!;
    });
    String url =
        "http://${widget.device.addr}:${widget.device.port}/input-keyevent?key=$key";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/input-keyevent',
              queryParameters: {"key": key}))
          .timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _removePackage(String? package) async {
    setState(() {
      _currentPackage = package!;
    });
    String url =
        "http://${widget.device.addr}:${widget.device.port}/do-cmd?cmd=/system/bin/pm uninstall $package";
    http.Response response;
    try {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("确认卸载软件包:"),
                  content: SizedBox.expand(
                    child: Text("请确认"),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("确认"),
                      onPressed: () async {
                        response = await http
                            .get(Uri(
                                scheme: 'http',
                                host: widget.device.addr.endsWith(".local")
                                    ? await get_ip_by_domain(widget.device.addr)
                                    : widget.device.addr,
                                port: widget.device.port,
                                path: '/do-cmd',
                                queryParameters: {
                                  "cmd": "/system/bin/pm uninstall $package"
                                }))
                            .timeout(const Duration(seconds: 2));
                        print(response.body);
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    } catch (e) {
      print(e.toString());
      return;
    }
    _getInstalledPackages();
  }

  _showImage() async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            String _screenUrl =
                "http://${widget.device.addr}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}";
            return AlertDialog(
                title: Text("屏幕截图:"),
                content: SizedBox.expand(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Image.network(
                            _screenUrl,
                            width: 360,
                            height: 240,
                          ),
                          onTapDown: (TapDownDetails details) {
                            show_success(
                                "onTapDown:${details.globalPosition},${details.localPosition},${details.kind}", context);
                          },
                          onVerticalDragStart: (DragStartDetails details) {
                            show_success("onVerticalDragStart:$details", context);
                          },
                          onVerticalDragEnd: (DragEndDetails details) {
                            show_success("onVerticalDragEnd:$details", context);
                          },
                          onHorizontalDragStart: (DragStartDetails details) {
                            show_success("onHorizontalDragStart:$details", context);
                          },
                          onHorizontalDragEnd: (DragEndDetails details) {
                            show_success("onHorizontalDragEnd:$details", context);
                          },
                        ),
                        // 19: "导航键向上",
                        // 20: "导航键向下",
                        // 21: "导航键向左",
                        // 22: "导航键向右",
                        // 23: "导航键确定键",
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_drop_up),
                                onPressed: () {
                                  _Keyevent(19);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    state(() {
                                      _screenUrl =
                                          "http://${widget.device.addr}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}";
                                    });
                                  });
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_left),
                                onPressed: () {
                                  _Keyevent(21);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    state(() {
                                      _screenUrl =
                                          "http://${widget.device.addr}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}";
                                    });
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.adjust),
                                onPressed: () {
                                  _Keyevent(23);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    state(() {
                                      _screenUrl =
                                          "http://${widget.device.addr}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}";
                                    });
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.arrow_right),
                                onPressed: () {
                                  _Keyevent(22);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    state(() {
                                      _screenUrl =
                                          "http://${widget.device.addr}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}";
                                    });
                                  });
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  _Keyevent(20);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    state(() {
                                      _screenUrl =
                                          "http://${widget.device.addr}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}";
                                    });
                                  });
                                }),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            TextButton(
                                child: Text("返回"),
                                onPressed: () {
                                  _Keyevent(4);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    state(() {
                                      _screenUrl =
                                          "http://${widget.device.addr}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}";
                                    });
                                  });
                                }),
                            TextButton(
                                child: Text("桌面"),
                                onPressed: () {
                                  _Keyevent(3);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    state(() {
                                      _screenUrl =
                                          "http://${widget.device.addr}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}";
                                    });
                                  });
                                }),
                            TextButton(
                                child: Text("刷新显示屏"),
                                onPressed: () {
                                  state(() {
                                    _screenUrl =
                                        "http://${widget.device.addr}:${widget.device.port}/get-image?time=${DateTime.now().millisecondsSinceEpoch}";
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("确认"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
        });
  }

  _doCmd(String cmd) async {
    String url =
        "http://${widget.device.addr}:${widget.device.port}/do-cmd?cmd=$cmd";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/do-cmd',
              queryParameters: {"cmd": cmd}))
          .timeout(const Duration(seconds: 2));
      show_success(response.body, context);
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _doAdbCmd(String cmd) async {
    String url =
        "http://${widget.device.addr}:${widget.device.port}/do-adb-cmd?cmd=$cmd";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/do-adb-cmd',
              queryParameters: {"cmd": cmd}))
          .timeout(const Duration(seconds: 2));
      show_success(response.body, context);
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _getBluetoothStatus() async {
    String url =
        "http://${widget.device.addr}:${widget.device.port}/do-cmd?cmd=settings get global bluetooth_on";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/do-cmd',
              queryParameters: {"cmd": "settings get global bluetooth_on"}))
          .timeout(const Duration(seconds: 2));
      show_success(response.body, context);
      Map<String, dynamic> body = jsonDecode(response.body);
      show_success(body['result'].toString(), context);
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _getInstalledPackages() async {
    String url =
        "http://${widget.device.addr}:${widget.device.port}/list-packages";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/list-packages'))
          .timeout(const Duration(seconds: 7));
      // Fluttertoast.showToast(msg: response.body);
      Map<String, dynamic> body = jsonDecode(response.body);
      setState(() {
        _listPackages = List<String>.from(body['result']);
      });
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  _installApk() async {
    var dio = Dio();
    FilePickerResult? path = await FilePicker.platform.pickFiles(
        // allowedExtensions: ['apk'],
        );

    if (path == null) {
      show_failed("User canceled the picker", context);
      return;
    }
    show_success(path.files.single.path!, context);
    String url = "http://${widget.device.addr}:${widget.device.port}/install-apk";
    Response response;
    try {
      //安装apk
      FormData formData = FormData.fromMap({
        "android.apk": await MultipartFile.fromFile(path.files.single.path!,
            filename: "android.apk"),
      });
      response = await dio.post(url, data: formData);
      show_success(response.toString(), context);
    } catch (e) {
      print(e.toString());
      return;
    }
    _getInstalledPackages();
  }

  List<DropdownMenuItem<int>> _getModesList() {
    List<DropdownMenuItem<int>> l = [];
    keyevents.forEach((int k, String v) {
      l.add(DropdownMenuItem<int>(
        value: k,
        child: Text(v),
      ));
    });
    return l;
  }

  List<DropdownMenuItem<String>> _getPackagesList() {
    List<DropdownMenuItem<String>> l = [];
    _listPackages.forEach((String v) {
      l.add(DropdownMenuItem<String>(
        value: v,
        child: Text(v),
      ));
    });
    return l;
  }
}
