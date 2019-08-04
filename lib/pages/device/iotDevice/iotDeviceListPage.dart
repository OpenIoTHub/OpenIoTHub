import 'package:flutter/material.dart';
import 'package:nat_explorer/api/CommonDeviceApi.dart';
import 'package:nat_explorer/api/SessionApi.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';
import 'package:android_intent/android_intent.dart';
//统一导入全部设备类型
import 'package:nat_explorer/pages/device/iotDevice/subDeviceType/devices.dart';

class IoTDeviceListPage extends StatefulWidget {
  IoTDeviceListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IoTDeviceListPageState createState() => _IoTDeviceListPageState();
}

class _IoTDeviceListPageState extends State<IoTDeviceListPage> {
  static const double ARROW_ICON_WIDTH = 16.0;
  final titleTextStyle = TextStyle(fontSize: 16.0);
  final rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );
  List<SessionConfig> _SessionList = [];
  List<PortConfig> _IoTDeviceList = [];

  @override
  void initState() {
    super.initState();
    getAllIoTDevice();
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _IoTDeviceList.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.devices),
              Expanded(
                  child: Text(
                    pair.description,
                    style: titleTextStyle,
                  )),
              rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            _pushDeviceServiceTypes(pair);
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
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  refreshmDNSServices();
                }),
          ],
        ),
        body: ListView(children: divided));
  }

  void _pushDeviceServiceTypes(PortConfig device) async {
  // 查看设备的UI，1.native，2.web
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 写成独立的组件，支持刷新
          return Text(device.toString());
        },
      ),
    ).then((result) {
      setState(() {
        getAllIoTDevice();
      });
    });
  }

  Future getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('Greeter client received: ${response.sessionConfigs}');
      return response.sessionConfigs;
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future getAllIoTDevice() async {
    // TODO 从各内网筛选出当前已经映射的mDNS服务中是物联网设备的，注意通过api刷新mDNS服务
    try {
      getAllSession().then((s){
        for(int i=0; i<s.length; i++) {
          SessionApi.getAllTCP(s[i]).then((t) {
            for(int j=0; j<t.portConfigs.length; j++) {
              //  是否是iotdevice
              if (t.portConfigs[j].description.contains("_iotdevice.")){
                // TODO 是否含有/info
                setState(() {
                  _IoTDeviceList.add(t.portConfigs[j]);
                });
              }
            }
          });
        }
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("获取物联网列表失败："),
                  content: Text("失败原因：$e"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  Future refreshmDNSServices() async {
    try {
      getAllSession().then((s){
        for(int i=0; i<s.length; i++) {
          SessionApi.refreshmDNSServices(s[i]);
        }
      }).then((_){
        getAllIoTDevice();
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

  _launchURL(String url) async {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    await intent.launch();
  }
}
