import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mdns_plugin/mdns_plugin.dart' as mdns_plugin;
import 'dart:convert';
import 'package:modules/api/OpenIoTHub/SessionApi.dart';
import 'package:modules/api/OpenIoTHub/Utils.dart';
import 'package:modules/constants/Config.dart';
import 'package:modules/constants/Constants.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:provider/provider.dart';
import 'package:modules/model/portService.dart';
import 'package:modules/pages/mdnsService/mdnsType2ModelMap.dart';
import 'package:modules/pages/tools/smartConfigTool.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';

//统一导入全部设备类型
import 'package:modules/pages/mdnsService/modelsMap.dart';
import 'package:modules/pages/mdnsService/commWidgets/info.dart';

class MdnsServiceListPage extends StatefulWidget {
  MdnsServiceListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MdnsServiceListPageState createState() => _MdnsServiceListPageState();
}

class _MdnsServiceListPageState extends State<MdnsServiceListPage>
    implements mdns_plugin.MDNSPluginDelegate {
  Utf8Decoder u8decodeer = Utf8Decoder();
  Map<String, PortService> _IoTDeviceMap = Map<String, PortService>();
  Timer _timerPeriod;
  mdns_plugin.MDNSPlugin _mdns;

  @override
  void initState() {
    super.initState();
    _mdns = mdns_plugin.MDNSPlugin(this);
    getAllIoTDevice();
    _timerPeriod = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      getIoTDeviceFromRemote();
    });
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    print("_IoTDeviceMap:$_IoTDeviceMap");
    final tiles = _IoTDeviceMap.values.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(Icons.devices,
              color: Provider.of<CustomTheme>(context).themeValue == "dark"
                  ? CustomThemes.dark.accentColor
                  : CustomThemes.light.accentColor),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(pair.info["name"], style: Constants.titleTextStyle),
            ],
          ),
          trailing: Constants.rightArrowIcon,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // 通过smartconfig添加设备
            return showDialog(
              context: context,
              builder: (_) => SmartConfigTool(
                title: "添加设备",
                needCallBack: true,
              ),
            ).then((v) {
              refreshmDNSServices();
            });
          },
          child: IconButton(
            icon: Icon(Icons.add),
            color: Colors.black,
            onPressed: null,
            iconSize: 40,
          ),
        ),
        body: ListView(children: divided));
  }

  @override
  void dispose() {
    super.dispose();
    if (_timerPeriod != null) {
      _timerPeriod.cancel();
    }
    _mdns.stopDiscovery();
    _IoTDeviceMap.clear();
  }

//显示是设备的UI展示或者操作界面
  void _pushDeviceServiceTypes(PortService device) async {
    // 查看设备的UI，1.native，2.web
    // 写成独立的组件，支持刷新
    String model = device.info["model"].replaceAll("#", ".");

    if (ModelsMap.modelsMap.containsKey(model)) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ModelsMap.modelsMap[model](device);
          },
        ),
      );
    } else {
//      TODO 没有可供显示的界面
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return InfoPage(
              portService: device,
            );
          },
        ),
      );
    }
//    await _IoTDeviceMap.clear();
    getAllIoTDevice();
  }

//获取所有的网络列表
  Future<List<SessionConfig>> getAllSession() async {
    try {
      final response = await SessionApi.getAllSession();
      print('getAllSession received: ${response.sessionConfigs}');
      return response.sessionConfigs;
    } catch (e) {
      List<SessionConfig> list = [];
      print('Caught error: $e');
      return list;
    }
  }

//获取所有的设备列表（本地网络和远程网络）
  Future getAllIoTDevice() async {
    // TODO 从搜索到的mqtt组件中获取设备
    getIoTDeviceFromLocal();
    getIoTDeviceFromRemote();
  }

//刷新设备列表
  Future refreshmDNSServices() async {
    try {
      getAllSession().then((s) {
        s.forEach((SessionConfig sc) {
          SessionApi.refreshmDNSServices(sc);
        });
      }).then((_) async {
        getAllIoTDevice();
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

//从grpc类型添加到设备列表
  Future<void> addPortConfigs(PortConfig portConfig, bool isLocal) async {
    if (portConfig == null) {
      return;
    }
    print("===text1:${portConfig.toString()}");
    Map<String, dynamic> info = Map<String, dynamic>();
    //尝试从mDNS的Text中获取数据
    if (portConfig.mDNSInfo != null && portConfig.mDNSInfo != "") {
      Map<String, dynamic> mDNSInfo = jsonDecode(portConfig.mDNSInfo);
      if (mDNSInfo != null &&
          mDNSInfo.containsKey("text") &&
          mDNSInfo["text"] != null) {
        print("===text2:${mDNSInfo["text"].toString()}");
        List text = mDNSInfo["text"];
        for (int i = 0; i < text.length; i++) {
          List<String> s = text[i].split("=");
          if (s != null && s.length == 2) {
            if (s[1].contains("\\")) {
              info[s[0]] = await UtilApi.convertOctonaryUtf8(s[1]);
            } else {
              info[s[0]] = s[1];
            }
            print("key:${s[0]},value:${info[s[0]]}\n");
          }
        }
      }
    }
    //尝试从http api获取信息，可能会产生覆盖
    // 初始化为代理情况下的ip和port的取值
    String ip = Config.webgRpcIp;
    int port = portConfig.localProt;
    if (isLocal) {
      ip = portConfig.device.addr;
      port = portConfig.remotePort;
    }
    print("===text3:${info}");
//    将一些不符合条件的服务排除在列表之外
    if (!info.containsKey("name") ||
        info["name"] == null ||
        info["name"] == '') {
      return;
    }
    portConfig.description = info["name"];
    PortService portService = PortService(
        portConfig: portConfig,
        info: info,
        isLocal: isLocal,
        ip: ip,
        port: port);
    addPortService(portService);
//    TODO 判断此配置的合法性 verify()
  }

//添加设备
  Future<void> addPortService(PortService portService) async {
//      在没有重复的情况下直接加入列表，有重复则本内外的替代远程的
//    String id = Utf8Codec().decode(portService.info["id"]);
    String id = portService.info["id"];
    if (!_IoTDeviceMap.containsKey(id) ||
        (!_IoTDeviceMap[id].isLocal && portService.isLocal)) {
      setState(() {
        _IoTDeviceMap[id] = portService;
      });
    }
  }

  Future getIoTDeviceFromLocal() async {
    // TODO 从搜索到的mqtt组件中获取设备
    await _mdns.startDiscovery(Config.mdnsIoTDeviceService,
        enableUpdating: true);
    await Future.delayed(Duration(seconds: 1));
//    await _mdns.stopDiscovery();
    await _mdns.startDiscovery(Config.mdnsTypeExplorer, enableUpdating: true);
    await Future.delayed(Duration(seconds: 1));
//    await _mdns.stopDiscovery();
  }

  Future getIoTDeviceFromRemote() async {
    // TODO 从搜索到的mqtt组件中获取设备
    try {
      // 从远程获取设备
      getAllSession().then((List<SessionConfig> sessionConfigList) {
        sessionConfigList.forEach((SessionConfig sessionConfig) {
          SessionApi.getAllTCP(sessionConfig).then((t) {
//            for (int j = 0; j < t.portConfigs.length; j++) {
            t.portConfigs.forEach((PortConfig pc) {
              //  是否是iotdevice
              Map<String, dynamic> mDNSInfo = jsonDecode(pc.mDNSInfo);
//              先判断是不是 _iotdevice._tcp
              if (mDNSInfo['type'] == Config.mdnsIoTDeviceService) {
                // TODO 是否含有/info，将portConfig里面的description换成、info中的name（这个name由设备管理）
                addPortConfigs(pc, false);
              } else if (MDNS2ModelsMap.modelsMap
                      .containsKey(mDNSInfo['type']) &&
                  mDNSInfo['AddrIPv4'] is List &&
                  mDNSInfo['AddrIPv4'].length > 0) {
                // mDNS类型为其他需要兼容的类型，看看是否在mdnsType2ModelMap的key里面，如果在就转为通用组件
                PortService portService = PortService.fromJson(MDNS2ModelsMap.modelsMap[mDNSInfo['type']].toJson());
                portService.ip = Config.webgRpcIp;
                portService.port = pc.localProt;
                portService.info["id"] =
                    "${mDNSInfo['AddrIPv4'][0]}:${mDNSInfo['port']}@${sessionConfig.runId}";
                portService.isLocal = false;
                addPortService(portService);
              }
            });
//            }
          });
        });
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("从远程获取物联网列表失败："),
                  content: Text("失败原因：$e"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  void onDiscoveryStarted() {
    print("Discovery started");
  }

  void onDiscoveryStopped() {
    print("Discovery stopped");
  }

  bool onServiceFound(mdns_plugin.MDNSService service) {
    print("Found: $service");
//  new mdns Type
    if (service.serviceType == Config.mdnsBaseTcpService &&
        MDNS2ModelsMap.modelsMap.containsKey("${service.name}._tcp")) {
      _mdns
          .startDiscovery("${service.name}._tcp", enableUpdating: true)
          .then((value) {
//        Future.delayed(Duration(seconds: 1));
//            .then((value) => _mdns.stopDiscovery());
      });
    }
//
    // Always returns true which begins service resolution
    return true;
  }

  void onServiceResolved(mdns_plugin.MDNSService service) {
    print("Resolved: $service");
    try {
//      UtilApi.getAllmDNSServiceList().then((MDNSServiceList iotDeviceResult) {
//        print("===start:");
//        iotDeviceResult.mDNSServices.forEach((MDNSService m) {
      String serviceType = service.serviceType;
      if (serviceType == null) {
        return;
      }
      print("service.serviceType:${serviceType}");
      print("service.ip:${service.addresses}");
      //TODO 有关IPV6地址的处理问题
      if (serviceType.contains(Config.mdnsIoTDeviceService)) {
        print(serviceType == "${Config.mdnsIoTDeviceService}.");
        PortService portService = PortService();
        if (service.addresses != null && service.addresses.length > 0) {
          portService.ip = service.addresses[0];
        } else {
          portService.ip = service.hostName;
        }
        portService.port = service.port;
        portService.info = Map<String, dynamic>();
        service.txt.forEach((key, value) {
          if (key == null || value == null) {
            return;
          }
          portService.info[key] = Utf8Codec().decode(value);
        });
//            portService.info = service.txt;
        portService.isLocal = true;
        addPortService(portService);
//            TODO 后面带.处理
      } else if (serviceType != null &&
          MDNS2ModelsMap.modelsMap.containsKey(serviceType.endsWith(".")
              ? serviceType.substring(0, serviceType.length - 1)
              : serviceType)) {
        PortService portService = MDNS2ModelsMap.modelsMap[
            serviceType.endsWith(".")
                ? serviceType.substring(0, serviceType.length - 1)
                : serviceType];
        if (portService == null) {
          return;
        }
        if (service.addresses != null && service.addresses.length > 0) {
          portService.ip = service.addresses[0];
        } else {
          portService.ip = service.hostName;
        }
        portService.port = service.port;
        portService.info["id"] = "${portService.ip}:${portService.port}@local";
        portService.isLocal = true;
        addPortService(portService);
      }
//        });
//      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("从本地获取物联网列表失败："),
                  content: Text("失败原因：$e"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  void onServiceUpdated(mdns_plugin.MDNSService service) {
    print("Updated: $service");
  }

  void onServiceRemoved(mdns_plugin.MDNSService service) {
    print("Removed: $service");
  }
}

//              print("mDNSInfo:$mDNSInfo");
//              {
//                "name": "esp-switch-80:7D:3A:72:64:6F",
//                "type": "_iotdevice._tcp",
//                "domain": "local",
//                "hostname": "esp-switch-80:7D:3A:72:64:6F.local.",
//                "port": 80,
//                "text": null,
//                "ttl": 4500,
//                "AddrIPv4": ["192.168.0.3"],
//                "AddrIPv6": null
//              }
