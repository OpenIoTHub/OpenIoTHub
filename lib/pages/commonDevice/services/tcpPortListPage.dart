import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/openWithChoice/OpenWithChoice.dart';

class TcpPortListPage extends StatefulWidget {
  TcpPortListPage({required Key key, required this.device}) : super(key: key);

  Device device;

  @override
  _TcpPortListPageState createState() => _TcpPortListPageState();
}

class _TcpPortListPageState extends State<TcpPortListPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  List<PortConfig> _ServiceList = [];

  @override
  void initState() {
    super.initState();
    refreshmTcpList();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
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
        title: Text("TCP端口列表"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                //刷新端口列表
                refreshmTcpList();
              }),
          IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              onPressed: () {
//                添加TCP端口
                _addTCP(widget.device).then((v) {
                  refreshmTcpList();
                });
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  void _pushDetail(PortConfig config) async {
    final List _result = [];
    _result.add("UUID:${config.uuid}");
    _result.add("端口:${config.remotePort}");
    _result.add("映射到端口:${config.localProt}");
    _result.add("描述:${config.description}");
    _result.add("转发连接状态:${config.remotePortStatus ? "在线" : "离线"}");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _result.map(
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
            appBar: AppBar(title: Text('端口详情'), actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    //删除
                    _deleteCurrentTCP(config);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.open_in_browser,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //                TODO 使用某种方式打开此端口，检查这个软件是否已经安装
//                    _launchURL("http://127.0.0.1:${config.localProt}");
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                                title: Text("打开方式："),
                                content: OpenWithChoice(config),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("取消"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("添加"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ]));
                  }),
            ]),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Future refreshmTcpList() async {
    try {
      CommonDeviceApi.getAllTCP(widget.device).then((v) {
        setState(() {
          _ServiceList = v.portConfigs;
        });
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future _addTCP(Device device) async {
    TextEditingController _description_controller =
        TextEditingController.fromValue(TextEditingValue(text: "我的TCP"));
    TextEditingController _remote_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "80"));
    TextEditingController _local_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "0"));
    TextEditingController _domain_controller = TextEditingController.fromValue(
        TextEditingValue(text: "www.example.com"));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("添加端口："),
                content: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _description_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '备注',
                        helperText: '自定义备注',
                      ),
                    ),
                    TextFormField(
                      controller: _remote_port_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '远程机器需要访问的端口号',
                        helperText: '该机器的端口号',
                      ),
                    ),
                    TextFormField(
                      controller: _local_port_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '映射到本手机端口号(随机则填0)',
                        helperText: '本手机1024以上空闲端口号',
                      ),
                    ),
                    TextFormField(
                      controller: _domain_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '网站映射到外网的域名',
                        helperText: '不是网站端口请不要修改;不想映射到服务器请不要修改',
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("添加"),
                    onPressed: () {
                      var tcpConfig = PortConfig();
                      tcpConfig.device = device;
                      tcpConfig.description = _description_controller.text;
                      try {
                        tcpConfig.remotePort =
                            int.parse(_remote_port_controller.text);
                        tcpConfig.localProt =
                            int.parse(_local_port_controller.text);
                      } catch (e) {
                        Fluttertoast.showToast(msg: "检查端口是否为数字$e");
                        return;
                      }
                      tcpConfig.networkProtocol = "tcp";
                      if (_domain_controller.text != "www.example.com") {
                        tcpConfig.domain = _domain_controller.text;
                        tcpConfig.applicationProtocol = "http";
                      } else {
                        tcpConfig.applicationProtocol = "unknown";
                      }
                      CommonDeviceApi.createOneTCP(tcpConfig).then((restlt) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ]));
  }

  Future _deleteCurrentTCP(PortConfig config) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("删除TCP"),
                content: Text("确认删除此TCP？"),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("删除"),
                    onPressed: () {
                      CommonDeviceApi.deleteOneTCP(config).then((result) {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ])).then((v) {
      Navigator.of(context).pop();
    }).then((v) {
      refreshmTcpList();
    });
  }
}
