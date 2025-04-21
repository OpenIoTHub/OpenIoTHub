import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

import 'package:openiothub/model/custom_theme.dart';

import 'package:openiothub/util/ThemeUtils.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/wifiConfig/airkiss.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/mqttDeviceManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';
import 'package:openiothub_plugin/plugins/mdnsService/mdnsType2ModelMap.dart';

//统一导入全部设备类型
import 'package:openiothub_plugin/plugins/mdnsService/modelsMap.dart';
import 'package:protobuf/protobuf.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub/widgets/BuildGlobalActions.dart';
import 'package:bonsoir/bonsoir.dart';

class MdnsServiceListPage extends StatefulWidget {
  const MdnsServiceListPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  _MdnsServiceListPageState createState() => _MdnsServiceListPageState();
}

class _MdnsServiceListPageState extends State<MdnsServiceListPage> {
  Utf8Decoder u8decodeer = const Utf8Decoder();
  final Map<String, PortService> _IoTDeviceMap = <String, PortService>{};
  late Timer _timerPeriodLocal;
  late Timer _timerPeriodRemote;
  final Map<String, BonsoirDiscovery> _bonsoirActions = {};
  bool initialStart = true;
  bool _scanning = false;
  final List<String> _supportedTypeList =
      MDNS2ModelsMap.getAllmDnsServiceType();

  @override
  void initState() {
    super.initState();
    getIoTDeviceFromLocal();
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      refreshmDNSServicesFromeRemote();
    });
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      refreshmDNSServicesFromeRemote();
    });
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      refreshmDNSServicesFromeRemote();
    });
    _timerPeriodRemote =
        Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      refreshmDNSServicesFromeRemote();
    });
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    print("_IoTDeviceMap:$_IoTDeviceMap");
    final tiles = _IoTDeviceMap.values.map(
      (PortService pair) {
        var listItemContent = ListTile(
          leading: TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: pair.info["name"]![0],
            shape: TDAvatarShape.square,
            backgroundColor: Color.fromRGBO(
              Random().nextInt(156)+50, // 随机生成0到255之间的整数
              Random().nextInt(156)+50, // 随机生成0到255之间的整数
              Random().nextInt(156)+50, // 随机生成0到255之间的整数
              1, // 不透明度，1表示完全不透明
            ),
          ),
          title: Text(pair.info["name"]!, style: Constants.titleTextStyle),
          subtitle: Text(
            pair.info["model"]!,
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
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        return tiles.elementAt(index);
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
    _timerPeriodLocal.cancel();
    _timerPeriodRemote.cancel();
    _IoTDeviceMap.clear();
    stopAllDiscovery();
    super.dispose();
  }

//显示是设备的UI展示或者操作界面
  void _pushDeviceServiceTypes(PortService device) async {
    // 查看设备的UI，1.native，2.web
    // 写成独立的组件，支持刷新
    String? model = device.info["model"];

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
  //刷新设备列表
  Future refreshmDNSServicesFromeRemote() async {
    if (await userSignedIn()) {
      getIoTDeviceFromMqttServer();
    }
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

  void onEventOccurred(BonsoirDiscoveryEvent event) {
    if (event.service == null) {
      return;
    }

    BonsoirService service = event.service!;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      // services.add(service);
      service.resolve(_bonsoirActions[service.type]!.serviceResolver);
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      // services.removeWhere((foundService) => foundService.name == service.name);
      // services.add(service);
      setState(() {
        PortService portService = PortService.create();
        portService.ip = (service as ResolvedBonsoirService).host!.replaceAll(RegExp(r'.local.'), ".local");
        portService.port = service.port;
        portService.isLocal = true;
        service.attributes.forEach((String key, value) {
          portService.info[key] =value;
        });
        print("print _portService:$portService");
        addPortService(portService);
      });
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      // services.removeWhere((foundService) => foundService.name == service.name);
    }
  }


//添加设备
  Future<void> addPortService(PortService portService) async {
    if (!portService.info.containsKey("name") ||
        portService.info["name"] == null ||
        portService.info["name"] == "") {
      return;
    }
    print("addPortService:${portService.info}");
    if (!portService.info.containsKey("id")) {
      return;
    }
    String? id = portService.info["id"];
    if (id == null || id.isEmpty) {
      return;
    }
    String value = "";
    try {
      value = await CnameManager.GetCname(id);
    } catch (e) {
      showToast(e.toString());
    }
    if (value != "") {
      portService.info["name"] = value;
    }
    if (!_IoTDeviceMap.containsKey(id) ||
        (_IoTDeviceMap.containsKey(id) &&
            !_IoTDeviceMap[id]!.isLocal &&
            portService.isLocal)) {
      setState(() {
        _IoTDeviceMap[id] = portService;
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
      PortService portService = PortService();
      //  TODO
      portService.ip = mqttDeviceInfo.mqttInfo.mqttServerHost;
      portService.port = mqttDeviceInfo.mqttInfo.mqttServerPort;
      portService.isLocal = false;
      portService.info["name"] = mqttDeviceInfo.deviceDefaultName != ""
          ? mqttDeviceInfo.deviceDefaultName
          : mqttDeviceInfo.deviceModel;
      portService.info["id"] = mqttDeviceInfo.deviceId;
      portService.info["mac"] = mqttDeviceInfo.deviceId;
      portService.info["model"] = mqttDeviceInfo.deviceModel;
      portService.info["username"] = mqttDeviceInfo.mqttInfo.mqttClientUserName;
      portService.info["password"] =
          mqttDeviceInfo.mqttInfo.mqttClientUserPassword;
      portService.info["client-id"] = mqttDeviceInfo.mqttInfo.mqttClientId;
      portService.info["tls"] = mqttDeviceInfo.mqttInfo.sSLorTLS.toString();
      portService.info["enable_delete"] = true.toString();
      addPortService(portService);
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
              PortService? portService;
              if (MDNS2ModelsMap.modelsMap
                  .containsKey(portConfig.mDNSInfo.info["service"])) {
                portService = MDNS2ModelsMap
                    .modelsMap[portConfig.mDNSInfo.info["service"]]!
                    .deepCopy();
                portService.info.addAll(portConfig.mDNSInfo.info);
                portService.ip = "127.0.0.1";
                portService.port = portConfig.localProt;
                portService.isLocal = false;
                if (portService.info.containsKey("id") &&
                    portService.info["id"] == "" &&
                    portService.info.containsKey("mac") &&
                    portService.info["mac"] != "") {
                  portService.info["id"] = portService.info["mac"]!;
                } else {
                  portService.info["id"] =
                      "${portConfig.device.addr}:${portService.port}@local";
                }
                addPortService(portService);
              } else {
                addPortService(portConfig.mDNSInfo);
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
