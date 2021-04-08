import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mdns_plugin/mdns_plugin.dart' as mdns_plugin;
import 'package:multicast_dns/multicast_dns.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_common_pages/wifiConfig/smartConfigTool.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';
import 'package:openiothub_plugin/plugins/mdnsService/mdnsType2ModelMap.dart';
//统一导入全部设备类型
import 'package:openiothub_plugin/plugins/mdnsService/modelsMap.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final MDnsClient _mdns = MDnsClient(rawDatagramSocketFactory:
      (dynamic host, int port, {bool reuseAddress, bool reusePort, int ttl}) {
    return RawDatagramSocket.bind(host, port,
        reuseAddress: true, reusePort: false, ttl: ttl);
  });
  mdns_plugin.MDNSPlugin _mdnsPlg;
  List<String> _supportedTypeList = MDNS2ModelsMap.getAllmDnsServiceType();

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS || Platform.isAndroid) {
      _mdnsPlg = mdns_plugin.MDNSPlugin(this);
    } else {
      _mdns.start();
    }
    Future.delayed(Duration(milliseconds: 500))
        .then((value) => {refreshmDNSServices()});
    _timerPeriod = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      refreshmDNSServices();
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
          leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  refreshmDNSServices();
                }),
//            TODO 添加设备（类型：mqtt，小米，美的；设备型号：TC1-A1,TC1-A2）
            IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: () {
//                  TODO：手动添加设备
                  Scaffold.of(context).openDrawer();
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
    if (Platform.isIOS || Platform.isAndroid) {
      _mdnsPlg.stopDiscovery();
    } else {
      _mdns.stop();
    }
    _IoTDeviceMap.clear();
  }

//显示是设备的UI展示或者操作界面
  void _pushDeviceServiceTypes(PortService device) async {
    // 查看设备的UI，1.native，2.web
    // 写成独立的组件，支持刷新
    String model = device.info["model"];

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
    getIoTDeviceFromRemote();
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

//刷新设备列表
  Future refreshmDNSServices() async {
    getIoTDeviceFromLocal();
    try {
      getAllSession().then((s) {
        s.forEach((SessionConfig sc) {
          SessionApi.refreshmDNSServices(sc);
        });
      }).then((_) async {
        getIoTDeviceFromRemote();
      });
    } catch (e) {
      print('Caught error: $e');
    }
  }

//添加设备
  Future<void> addPortService(PortService portService) async {
    if (!portService.isLocal) {
      portService.ip = "127.0.0.1";
    }
    if (!portService.info.containsKey("name") ||
        portService.info["name"] == null ||
        portService.info["name"].isEmpty) {
      return;
    }
    print("addPortService:${portService.info}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = portService.info["id"];
    Map<String, dynamic> device_cname_map = Map<String, String>();
    if (prefs.containsKey(Constants.DEVICE_CNAME_KEY)) {
      String device_cname = await prefs.getString(Constants.DEVICE_CNAME_KEY);
      device_cname_map = jsonDecode(device_cname);
      if (device_cname_map.containsKey(id)) {
        portService.info["name"] = device_cname_map[id].toString();
      }
    }
    if (!_IoTDeviceMap.containsKey(id) ||
        (_IoTDeviceMap.containsKey(id) &&
            !_IoTDeviceMap[id].isLocal &&
            portService.isLocal)) {
      setState(() {
        _IoTDeviceMap[id] = portService;
      });
    }
  }

  Future getIoTDeviceFromLocal() async {
    //优先iotdevice
    for (int i = 0; i < _supportedTypeList.length; i++) {
      if (Platform.isIOS || Platform.isAndroid) {
        // TODO 从搜索到的mqtt组件中获取设备
        print("getIoTDeviceFromLocal:${_supportedTypeList[i]}");
        if (_mdnsPlg != null) {
        // await _mdnsPlg.stopDiscovery();
        }
        await Future.delayed(Duration(milliseconds: 500));
        await _mdnsPlg.startDiscovery(_supportedTypeList[i],
            enableUpdating: true);
        await Future.delayed(Duration(seconds: 1),);
      } else {
        await getIoTDeviceFromLocalByType(_supportedTypeList[i]);
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }

  Future getIoTDeviceFromLocalByType(String serviceType) async {
    await for (PtrResourceRecord ptr in _mdns.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(serviceType + ".local"),
        timeout: Duration(seconds: 1))) {
      await for (SrvResourceRecord srv in _mdns.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName))) {
        print("SrvResourceRecord:$srv");
        //兼容的类型
        PortService _portService;
        if (MDNS2ModelsMap.modelsMap.containsKey(serviceType)) {
          _portService = MDNS2ModelsMap.modelsMap[serviceType].clone();
        }
        await _mdns
            .lookup<TxtResourceRecord>(ResourceRecordQuery.text(ptr.domainName))
            .forEach((TxtResourceRecord text) {
          List<String> _txts = text.text.split("\n");
          print("_txts.length:${_txts.length}");
          print("_txts:$_txts");
          //非异步
          for (int i = 0; i < _txts.length; i++) {
            List<String> _kv = _txts[i].split("=");
            print("_kv:");
            print(_kv);
            _portService.info[_kv.first] = _kv.last;
          }
        });
        await for (IPAddressResourceRecord ip
            in _mdns.lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv4(srv.target))) {
          print(ip);
          print('Service instance found at '
              '${srv.target}:${srv.port} with ${ip.address}.');
          _portService.ip = ip.address.address;
          _portService.port = srv.port;
          _portService.isLocal = true;
          break;
        }
        if (_portService.info.containsKey("id") &&
            _portService.info["id"] == "" &&
            _portService.info.containsKey("mac") &&
            _portService.info["mac"] != "") {
          _portService.info["id"] = _portService.info["mac"];
        } else {
          _portService.info["id"] =
              "${_portService.ip}:${_portService.port}@local";
        }
        print("_portService:");
        print(_portService);
        addPortService(_portService);
      }
    }
  }

  Future getIoTDeviceFromRemote() async {
    // TODO 从搜索到的mqtt组件中获取设备
    try {
      // 从远程获取设备
      getAllSession().then((List<SessionConfig> sessionConfigList) {
        sessionConfigList.forEach((SessionConfig sessionConfig) {
          SessionApi.getAllTCP(sessionConfig).then((t) {
            t.portConfigs.forEach((portConfig) {
              addPortService(portConfig.mDNSInfo);
            });
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
                    TextButton(
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
//  mdns Type
//     if (service.serviceType == Config.mdnsBaseTcpService &&
//         _supportedTypeList.contains("${service.name}._tcp")) {
//       _mdnsPlg
//           .startDiscovery("${service.name}._tcp", enableUpdating: true);
//     }
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
        PortService portService = MDNS2ModelsMap.basePortService.clone();
        if (service.addresses != null && service.addresses.length > 0) {
          portService.ip = service.addresses[0].contains(":")
              ? "[${service.addresses[0]}]"
              : service.addresses[0];
        } else {
          portService.ip = service.hostName;
        }
        portService.port = service.port;
        for (int i = 0; i < service.txt.keys.toList().length; i++) {
          if (service.txt.keys.toList()[i] == null ||
              service.txt[service.txt.keys.toList()[i]] == null) {
            return;
          }
          portService.info[service.txt.keys.toList()[i]] =
              Utf8Codec().decode(service.txt[service.txt.keys.toList()[i]]);
        }
        // service.txt.forEach((key, value) {
        //   if (key == null || value == null) {
        //     return;
        //   }
        //   portService.info[key] = Utf8Codec().decode(value);
        // });
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
                    : serviceType]
            .clone();
        if (portService == null) {
          return;
        }
        //TODO 选取一个同网段的ip
        if (service.addresses != null && service.addresses.length == 1) {
          portService.ip = service.addresses[0];
        } else {
          portService.ip = service.hostName;
        }
        portService.port = service.port;
        if (service.txt.containsKey("id") && service.txt["id"] != "") {
          portService.info["id"] = Utf8Codec().decode(service.txt["id"]);
        } else if (service.txt.containsKey("id") &&
            service.txt["id"] == "" &&
            service.txt.containsKey("mac") &&
            service.txt["mac"] != "") {
          portService.info["id"] = Utf8Codec().decode(service.txt["mac"]);
        } else {
          portService.info["id"] =
              "${portService.ip}:${portService.port}@local";
        }
        portService.isLocal = true;
        print("add local portService:${portService.toString()}");
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
                    TextButton(
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
