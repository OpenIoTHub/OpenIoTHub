import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/util/ThemeUtils.dart';
import 'package:openiothub/widgets/BuildGlobalActions.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/wifiConfig/airkiss.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/mqttDeviceManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/models/PortServiceInfo.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';
import 'package:openiothub_plugin/plugins/mdnsService/mdnsType2ModelMap.dart';
//统一导入全部设备类型
import 'package:openiothub_plugin/plugins/mdnsService/modelsMap.dart';
import 'package:openiothub_plugin/utils/portConfig2portService.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// import '../../widgets/ads/banner_gtads.dart';
import '../../widgets/ads/banner_ylh_test.dart';
import '../../widgets/toast.dart';

class MdnsServiceListPage extends StatefulWidget {
  const MdnsServiceListPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  _MdnsServiceListPageState createState() => _MdnsServiceListPageState();
}

class _MdnsServiceListPageState extends State<MdnsServiceListPage> {
  Utf8Decoder u8decodeer = const Utf8Decoder();
  final Map<String, PortServiceInfo> _IoTDeviceMap = <String, PortServiceInfo>{};
  late Timer _timerPeriodRemote;
  final Map<String, BonsoirDiscovery> _bonsoirActions = {};
  bool initialStart = true;
  final List<String> _supportedTypeList =
      MDNS2ModelsMap.getAllmDnsServiceType();

  @override
  void initState() {
    super.initState();
    getIoTDeviceFromLocal();
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      refreshmDNSServicesFromeRemote();
    });
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      refreshmDNSServicesFromeRemote();
    });
    _timerPeriodRemote =
        Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      refreshmDNSServicesFromeRemote();
    });
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    print("_IoTDeviceMap:$_IoTDeviceMap");
    final tiles = _IoTDeviceMap.values.map(
      (PortServiceInfo pair) {
        var listItemContent = ListTile(
          leading: TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: pair.info!["name"]![0],
            shape: TDAvatarShape.square,
            backgroundColor: Color.fromRGBO(
              Random().nextInt(156) + 50, // 随机生成0到255之间的整数
              Random().nextInt(156) + 50, // 随机生成0到255之间的整数
              Random().nextInt(156) + 50, // 随机生成0到255之间的整数
              1, // 不透明度，1表示完全不透明
            ),
          ),
          title: Text(pair.info!["name"]!, style: Constants.titleTextStyle),
          subtitle: Text(
            "${pair.info!["model"]!}@${pair.isLocal?"local":"remote"}",
            style: Constants.subTitleTextStyle,
          ),
          trailing: Constants.rightArrowIcon,
          contentPadding: const EdgeInsets.fromLTRB(16, 0.0, 16, 0.0),
        );
        return InkWell(
          onTap: () {
            _pushDeviceServiceTypes(pair);
          },
          child: listItemContent,
        );
      },
    );
    final divided = ListView.separated(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      itemCount: tiles.length+1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildYLHBanner();
        }
        return tiles.elementAt(index-1);
      },
      separatorBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 70), // 添加左侧缩进
          child: TDDivider(),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // backgroundColor: Provider.of<CustomTheme>(context).isLightTheme()
        //     ? CustomThemes.light.primaryColor
        //     : CustomThemes.dark.primaryColor,
        centerTitle: true,
        actions: build_actions(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshmDNSServicesFromeRemote();
          return;
        },
        child: tiles.isNotEmpty
            ? divided
            : Container(
                child: Column(children: [
                  ThemeUtils.isDarkMode(context)
                      ? Center(
                          child:
                              Image.asset('assets/images/empty_list_black.png'),
                        )
                      : Center(
                          child: Image.asset('assets/images/empty_list.png'),
                        ),
                  TextButton(
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(
                            const BorderSide(color: Colors.grey, width: 1)),
                        shape: WidgetStateProperty.all(const StadiumBorder()),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return Airkiss(
                                title: OpenIoTHubLocalizations.of(context)
                                    .add_device,
                                key: UniqueKey(),
                              );
                            },
                          ),
                        );
                      },
                      child: Text(OpenIoTHubLocalizations.of(context)
                          .please_add_device_first))
                ]),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _timerPeriodRemote.cancel();
    _IoTDeviceMap.clear();
    stopAllDiscovery();
    super.dispose();
  }

//显示是设备的UI展示或者操作界面
  void _pushDeviceServiceTypes(PortServiceInfo device) async {
    // 查看设备的UI，1.native，2.web
    // 写成独立的组件，支持刷新
    String? model = device.info!["model"];

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
              key: UniqueKey(),
            );
          },
        ),
      );
    }
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
  //刷新设备列表
  Future refreshmDNSServicesFromeRemote() async {
    if (await userSignedIn()) {
      getIoTDeviceFromMqttServer();
      try {
        getAllSession().then((s) {
          for (var sc in s) {
            SessionApi.refreshmDNSServices(sc);
          }
        }).then((_) async {
          getIoTDeviceFromRemote();
        });
      } catch (e) {
        print('Caught error: $e');
      }
    }
  }

  void onEventOccurred(BonsoirDiscoveryEvent event) {
    if (event.service == null) {
      return;
    }

    BonsoirService service = event.service!;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      // services.add(service);
      if (_bonsoirActions.containsKey(service.type)) {
        service.resolve(_bonsoirActions[service.type]!.serviceResolver);
      }else{
        print("_bonsoirActions 不存在 ${service.type} 服务");
      }

    } else if (event.type ==
        BonsoirDiscoveryEventType.discoveryServiceResolved) {
      // services.removeWhere((foundService) => foundService.name == service.name);
      // services.add(service);
      setState(() {
        if (MDNS2ModelsMap.modelsMap.containsKey(service.type)) {
          PortServiceInfo portServiceInfo =
              MDNS2ModelsMap.modelsMap[service.type]!.copyWith();
          portServiceInfo.info!.addAll(service.attributes);
          portServiceInfo.addr = (service as ResolvedBonsoirService)
              .host!
              .replaceAll(RegExp(r'.local.local.'), ".local")
              .replaceAll(RegExp(r'.local.'), ".local");
          portServiceInfo.port = service.port;
          portServiceInfo.isLocal = true;
          if (portServiceInfo.info!.containsKey("id") &&
              portServiceInfo.info!["id"] != "" ) {
            // 有id
          } else if(portServiceInfo.info!.containsKey("mac") &&
              portServiceInfo.info!["mac"] != "") {
            portServiceInfo.info!["id"] = portServiceInfo.info!["mac"]!;
          } else {
            portServiceInfo.info!["id"] =
                "${portServiceInfo.addr}:${portServiceInfo.port}@local";
          }
          addPortServiceInfo(portServiceInfo);
        } else {
          PortServiceInfo portServiceInfo = PortServiceInfo("", 80, true);
          portServiceInfo.addr = (service as ResolvedBonsoirService)
              .host!
              .replaceAll(RegExp(r'.local.local.'), ".local")
              .replaceAll(RegExp(r'.local.'), ".local");
          portServiceInfo.port = service.port;
          portServiceInfo.isLocal = true;
          portServiceInfo.info = Map();
          service.attributes.forEach((String key, value) {
            portServiceInfo.info![key] = value;
          });
          print("print _portServiceInfo:$portServiceInfo");
          addPortServiceInfo(portServiceInfo);
        }
      });
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      // services.removeWhere((foundService) => foundService.name == service.name);
    }
  }

//添加设备
  Future<void> addPortServiceInfo(PortServiceInfo portServiceInfo) async {
    if (portServiceInfo.info == null || !portServiceInfo.info!.containsKey("name") ||
        portServiceInfo.info!["name"] == null ||
        portServiceInfo.info!["name"] == "") {
      return;
    }
    print("addPortServiceInfo:${portServiceInfo.info!}");
    if (!portServiceInfo.info!.containsKey("id")) {
      return;
    }
    String? id = portServiceInfo.info!["id"];
    if (id == null || id.isEmpty) {
      return;
    }
    String value = "";
    try {
      if (await userSignedIn()) {
        value = await CnameManager.GetCname(id);
      }
    } catch (e) {
      show_failed(e.toString(), context);
    }
    if (value != "") {
      portServiceInfo.info!["name"] = value;
    }
    if (!_IoTDeviceMap.containsKey(id) ||
        (_IoTDeviceMap.containsKey(id) &&
            !_IoTDeviceMap[id]!.isLocal &&
            portServiceInfo.isLocal)) {
      setState(() {
        _IoTDeviceMap[id] = portServiceInfo;
      });
    }
  }

  Future getIoTDeviceFromLocal() async {
    // if  (_scanning) {
    //   return;
    // }
    //优先iotdevice
    for (int i = 0; i < _supportedTypeList.length; i++) {
      String _type = _supportedTypeList[i];
      BonsoirDiscovery action = BonsoirDiscovery(type: _type);
      await action.ready;
      _bonsoirActions[_type] = action;
      action.eventStream?.listen(onEventOccurred);
      await action.start();
      print("===start $_type");
      Future.delayed(const Duration(milliseconds: 500));
    }
    // _scanning = true;
  }

  Future<void> stopAllDiscovery() async {
    for (BonsoirActionHandler action in _bonsoirActions.values) {
      action.stop();
    }
    _bonsoirActions.clear();
  }

  Future<void> stopDiscovery(String _type) async {
    await _bonsoirActions[_type]?.stop();
    _bonsoirActions.remove(_type);
  }

  Future getIoTDeviceFromMqttServer() async {
    MqttDeviceInfoList mqttDeviceInfoList =
        await MqttDeviceManager.GetAllMqttDevice();
    for (var mqttDeviceInfo in mqttDeviceInfoList.mqttDeviceInfoList) {
      PortServiceInfo portServiceInfo = PortServiceInfo("", 80, false);
      //  TODO
      portServiceInfo.addr = mqttDeviceInfo.mqttInfo.mqttServerHost;
      portServiceInfo.port = mqttDeviceInfo.mqttInfo.mqttServerPort;
      portServiceInfo.isLocal = false;
      if (portServiceInfo.info != null) {
        portServiceInfo.info!["name"] = mqttDeviceInfo.deviceDefaultName != ""
            ? mqttDeviceInfo.deviceDefaultName
            : mqttDeviceInfo.deviceModel;
        portServiceInfo.info!["id"] = mqttDeviceInfo.deviceId;
        portServiceInfo.info!["mac"] = mqttDeviceInfo.deviceId;
        portServiceInfo.info!["model"] = mqttDeviceInfo.deviceModel;
        portServiceInfo.info!["username"] = mqttDeviceInfo.mqttInfo.mqttClientUserName;
        portServiceInfo.info!["password"] =
            mqttDeviceInfo.mqttInfo.mqttClientUserPassword;
        portServiceInfo.info!["client-id"] = mqttDeviceInfo.mqttInfo.mqttClientId;
        portServiceInfo.info!["tls"] = mqttDeviceInfo.mqttInfo.sSLorTLS.toString();
        portServiceInfo.info!["enable_delete"] = true.toString();
      }
      addPortServiceInfo(portServiceInfo);
    }
  }

  Future getIoTDeviceFromRemote() async {
    // TODO 从搜索到的mqtt组件中获取设备
    try {
      // 从远程获取设备
      getAllSession().then((List<SessionConfig> sessionConfigList) {
        for (var sessionConfig in sessionConfigList) {
          SessionApi.getAllTCP(sessionConfig).then((t) {
            for (var portConfig in t.portConfigs) {
              PortServiceInfo? portServiceInfo;
              if (MDNS2ModelsMap.modelsMap
                  .containsKey(portConfig.mDNSInfo.info["service"])) {
                portServiceInfo = MDNS2ModelsMap
                    .modelsMap[portConfig.mDNSInfo.info["service"]]!
                    .copyWith();
                portServiceInfo.info!.addAll(portConfig.mDNSInfo.info);
                portServiceInfo.addr = "127.0.0.1";
                portServiceInfo.port = portConfig.localProt;
                portServiceInfo.isLocal = false;
                if (portServiceInfo.info!.containsKey("id") &&
                    portServiceInfo.info!["id"] != "") {
                  // 有id
                }else if(portServiceInfo.info!.containsKey("mac") &&
                    portServiceInfo.info!["mac"] != ""){
                  portServiceInfo.info!["id"] = portServiceInfo.info!["mac"]!;
                } else {
                  portServiceInfo.info!["id"] =
                      "${portConfig.device.addr}:${portConfig.remotePort}@${sessionConfig.runId}";
                }
                // 添加远程主机的真实地址，用于类似于casaos登录后的再次动态创建映射
                addPortServiceInfo(portServiceInfo);
              } else {
                addPortServiceInfo(portService2PortServiceInfo(portConfig.mDNSInfo));
              }
            }
          });
        }
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text(OpenIoTHubLocalizations.of(context)
                      .failed_to_obtain_the_iot_list_remotely),
                  content: SizedBox.expand(
                      child: Text(
                          "${OpenIoTHubLocalizations.of(context).failure_reason}：$e")),
                  actions: <Widget>[
                    TextButton(
                      child: Text(OpenIoTHubLocalizations.of(context).confirm),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }
}

//            TODO 添加设备（类型：mqtt，小米，美的；设备型号：TC1-A1,TC1-A2）
//           IconButton(
//               icon: Icon(
//                 Icons.add_circle,
//                 color: Colors.white,
//               ),
//               onPressed: () {
// //                  TODO：手动添加MQTT设备
// //                   Scaffold.of(context).openDrawer();
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return AddMqttDevicesPage();
//                     },
//                   ),
//                 );
//               }),

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
