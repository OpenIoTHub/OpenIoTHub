import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';

class UdpPortListPage extends StatefulWidget {
  UdpPortListPage({required Key key, required this.device}) : super(key: key);

  Device device;

  @override
  _UdpPortListPageState createState() => _UdpPortListPageState();
}

class _UdpPortListPageState extends State<UdpPortListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  List<PortConfig> _ServiceList = [];

  @override
  void initState() {
    super.initState();
    refreshmUDPList();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.devices),
              ),
              Expanded(
                  child: Text(
                "${pair.description}(${pair.remotePort})",
                style: Constants.titleTextStyle,
              )),
              Constants.rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            //打开此端口的详情
            _pushDetail(pair);
          },
          child: listItemContent,
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("UDP端口列表"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {
                //刷新端口列表
                refreshmUDPList();
              }),
          IconButton(
              icon: const Icon(
                Icons.add_circle,
                // color: Colors.white,
              ),
              onPressed: () {
//                TODO 添加UDP端口
                _addUDP(widget.device).then((v) {
                  refreshmUDPList();
                });
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  void _pushDetail(PortConfig config) async {
    final List result = [];
    result.add("UUID:${config.uuid}");
    result.add("端口:${config.remotePort}");
    result.add("映射到端口:${config.localProt}");
    result.add("描述:${config.description}");
    result.add("转发连接状态:${config.remotePortStatus ? "在线" : "离线"}");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = result.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: Constants.titleTextStyle,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(title: const Text('端口详情'), actions: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    //TODO 删除
                    _deleteCurrentUDP(config);
                  }),
//                IconButton(
//                  icon: Icon(
//                    Icons.open_in_browser,
//                    color: Colors.white,
//                  ),
//                  onPressed: () {
//    //                TODO 使用某种方式打开此端口
//                    _launchURL("http://127.0.0.1:${config.localProt}");
//                  }),
            ]),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Future refreshmUDPList() async {
    try {
      CommonDeviceApi.getAllUDP(widget.device).then((v) {
        setState(() {
          _ServiceList = v.portConfigs;
        });
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future _addUDP(Device device) async {
    TextEditingController descriptionController =
        TextEditingController.fromValue(const TextEditingValue(text: "我的UDP"));
    TextEditingController remotePortController =
        TextEditingController.fromValue(const TextEditingValue(text: ""));
    TextEditingController localPortController =
        TextEditingController.fromValue(const TextEditingValue(text: ""));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text("添加端口："),
                content: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '备注',
                        helperText: '自定义备注',
                      ),
                    ),
                    TextFormField(
                      controller: remotePortController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '端口号',
                        helperText: '该机器的端口号',
                      ),
                    ),
                    TextFormField(
                      controller: localPortController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '映射到本手机端口号(随机则填0)',
                        helperText: '本手机1024以上空闲端口号',
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("添加"),
                    onPressed: () {
                      var UDPConfig = PortConfig();
                      UDPConfig.device = device;
                      UDPConfig.description = descriptionController.text;
                      try {
                        UDPConfig.remotePort =
                            int.parse(remotePortController.text);
                        UDPConfig.localProt =
                            int.parse(localPortController.text);
                      } catch (e) {
                        showToast("检查端口是否为数字$e");
                        return;
                      }
                      UDPConfig.networkProtocol = "udp";
                      UDPConfig.applicationProtocol = "unknown";
                      CommonDeviceApi.createOneUDP(UDPConfig).then((restlt) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  Future _deleteCurrentUDP(PortConfig config) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text("删除UDP"),
                content: const Text("确认删除此UDP？"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("删除"),
                    onPressed: () {
                      CommonDeviceApi.deleteOneUDP(config).then((result) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ])).then((v) {
      Navigator.of(context).pop();
    }).then((v) {
      refreshmUDPList();
    });
  }
}
