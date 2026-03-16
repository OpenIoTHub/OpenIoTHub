import 'dart:async';
import 'dart:convert';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/common_pages/utils/toast.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub/plugin/mdns_service/components.dart';
import 'package:openiothub/plugin/utils/port_config_to_port_service.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

const utf8encoder = Utf8Encoder();

class FindGatewayGoListPage extends StatefulWidget {
  const FindGatewayGoListPage({Key? key}) : super(key: key);

  @override
  State createState() => _FindGatewayGoListPageState();
}

class _FindGatewayGoListPageState extends State<FindGatewayGoListPage> {
  BonsoirDiscovery? action;
  final Map<String, PortService> _serviceMap = {};

  bool initialStart = true;
  bool _scanning = false;

  _FindGatewayGoListPageState();

  @override
  void initState() {
    super.initState();
    userSignedIn().then((signedIn){
      if (!signedIn) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }else{
        startDiscovery();
      }
    });
  }

  @override
  void dispose() {
    if (action != null) {
      action!.stop();
    }
    super.dispose();
  }

  Future<void> startDiscovery() async {
    if (_scanning) return;

    setState(() {
      _serviceMap.clear();
      _scanning = true;
    });

    action = BonsoirDiscovery(type: Config.mdnsGatewayService);
    await action!.ready;
    action!.eventStream?.listen(onEventOccurred);
    await action!.start();
    print("stared");
  }

  void onEventOccurred(BonsoirDiscoveryEvent event) {
    if (event.service == null) {
      return;
    }
    BonsoirService oneMdnsService = event.service!;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      oneMdnsService.resolve(action!.serviceResolver);
    } else if (event.type ==
        BonsoirDiscoveryEventType.discoveryServiceResolved) {
      setState(() {
        PortService _portService = PortService.create();
        _portService.ip = (oneMdnsService as ResolvedBonsoirService)
            .host!
            .replaceAll(RegExp(r'.local.local.'), ".local")
            .replaceAll(RegExp(r'.local.'), ".local");
        print(_portService.ip);
        _portService.port = oneMdnsService.port;
        _portService.isLocal = true;
        _portService.info.addAll({
          "name":
              "${oneMdnsService.name}(${_portService.ip}:${oneMdnsService.port})",
          "model": Gateway.modelName,
          "mac": "mac",
          "id": _portService.ip + ":" + _portService.port.toString(),
          "author": "Farry",
          "email": "newfarry@126.com",
          "home-page": "https://github.com/OpenIoTHub",
          "firmware-respository": "https://github.com/OpenIoTHub/gateway-go",
          "firmware-version": "version",
        });

        oneMdnsService.attributes.forEach((String key, String value) {
          _portService.info[key] = value;
        });
        print("print _portService:$_portService");
        if (!_serviceMap.containsKey(_portService.info["id"])) {
          setState(() {
            _serviceMap[_portService.info["id"]!] = _portService;
          });
        }
      });
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
    }
  }

  Future<void> stopDiscovery() async {
    if (!_scanning) return;

    setState(() {
      _serviceMap.clear();
      _scanning = false;
    });
    action!.stop();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _serviceMap.values.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(TDIcons.earth, color: Colors.green),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('${pair.ip}:${pair.port}', style: Constants.titleTextStyle),
            ],
          ),
          subtitle: TDTag(
            "version:${pair.info["version"] != null ? pair.info["version"] : pair.info["firmware-version"]}",
            theme: TDTagTheme.success,
            isLight: true,
            fixedWidth: 100,
          ),
          trailing: Constants.rightArrowIcon,
          onTap: () async {
            if (!(await userSignedIn())) {
              showFailed("Please login before Add Gateway", context);
              if (!(await userSignedIn())) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
              }
            }
            TextEditingController nameController =
                TextEditingController.fromValue(
                    TextEditingValue(text: "Gateway-${DateTime.now().minute}"));
            TextEditingController descriptionController =
                TextEditingController.fromValue(
                    TextEditingValue(text: "Gateway-${DateTime.now()}"));
            if (pair.info.containsKey("run_id") &&
                !pair.info["run_id"]!.isEmpty) {
              showGeneralDialog(
                context: context,
                pageBuilder: (BuildContext buildContext,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return TDAlertDialog(
                    title: OpenIoTHubCommonLocalizations.of(context)
                        .confirm_add_gateway,
                    contentWidget: Column(children: <Widget>[
                      TDInput(
                        leftLabel:
                            OpenIoTHubCommonLocalizations.of(context).name,
                        leftLabelSpace: 0,
                        hintText: "",
                        backgroundColor: Colors.white,
                        textAlign: TextAlign.left,
                        showBottomDivider: true,
                        controller: nameController,
                        inputType: TextInputType.text,
                        maxLines: 1,
                        needClear: true,
                      ),
                      TDInput(
                        leftLabel: OpenIoTHubCommonLocalizations.of(context)
                            .description,
                        leftLabelSpace: 0,
                        hintText: "",
                        backgroundColor: Colors.white,
                        textAlign: TextAlign.left,
                        showBottomDivider: true,
                        controller: descriptionController,
                        inputType: TextInputType.text,
                        maxLines: 1,
                        needClear: true,
                      )
                    ]),
                    titleColor: Colors.black,
                    contentColor: Colors.redAccent,
                    leftBtn: TDDialogButtonOptions(
                      title: OpenIoTHubCommonLocalizations.of(context).cancel,
                      style: TDButtonStyle(
                        backgroundColor: Colors.grey,
                      ),
                      action: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    rightBtn: TDDialogButtonOptions(
                      title: OpenIoTHubCommonLocalizations.of(context).ok,
                      style: TDButtonStyle(
                        backgroundColor: Colors.blue,
                      ),
                      action: () {
                        Navigator.of(context).pop();
                        _addToMyAccount(
                            pair.info["run_id"]!,
                            pair.info["server_host"],
                            nameController.text,
                            descriptionController.text);
                      },
                    ),
                  );
                },
              );
              return;
            }
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Gateway(
                device: portService2PortServiceInfo(pair),
                key: UniqueKey(),
              );
            }));
          },
        );
        return InkWell(
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
        title: Text(
            OpenIoTHubCommonLocalizations.of(context).find_local_gateway_list),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add_circle,
              ),
              onPressed: () {
                _addGateway();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
              ),
              onPressed: () {
                _gatewayGuide();
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  Future<void> _gatewayGuide() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GatewayGuidePage(
        key: UniqueKey(),
      );
    }));
  }

  void _addToMyAccount(
      String gatewayId, String? host, name, description) async {
    try {
      GatewayInfo gatewayInfo = GatewayInfo(
          gatewayUuid: gatewayId,
          serverUuid: host,
          name: name,
          description: description);
      OperationResponse operationResponse =
          await GatewayManager.addGateway(gatewayInfo);
      if (operationResponse.code == 0) {
        StringValue openIoTHubJwt =
            await GatewayManager.getOpenIoTHubJwtByGatewayUuid(gatewayId);
        await _addToMySessionList(
            openIoTHubJwt.value, gatewayInfo.name, gatewayInfo.description);
      } else {
        showFailed("Response: ${operationResponse.msg}", context);
      }
      var device = Device();
      device.runId = gatewayId;
      device.uuid = getOneUUID();
      device.name = name;
      device.description = description;
      device.addr = "127.0.0.1";
      await CommonDeviceApi.createOneDevice(device);
      var tcpConfig = PortConfig();
      tcpConfig.device = device;
      tcpConfig.name = "$name Gateway";
      tcpConfig.description = "$description Gateway";
      tcpConfig.remotePort = 34323;
      tcpConfig.localProt = 0;
      tcpConfig.networkProtocol = "tcp";
      tcpConfig.applicationProtocol = "http";
      await CommonDeviceApi.createOneTCP(tcpConfig);
    } catch (exception) {
      showFailed("Failed: ${exception}", context);
    }
  }

  Future<void> _addGateway() async {
    List<DropdownMenuItem<String>> l = await _listAvailableServer();
    String? value = l.first.value;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
                title: Text(OpenIoTHubCommonLocalizations.of(context)
                    .manually_create_a_gateway),
                content: SizedBox(
                    width: 250,
                    height: 400,
                    child: ListView(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: [
                          Text(OpenIoTHubCommonLocalizations.of(context)
                              .manually_create_a_gateway_description1),
                          Text(OpenIoTHubCommonLocalizations.of(context)
                              .manually_create_a_gateway_description2),
                          Text(
                            OpenIoTHubCommonLocalizations.of(context)
                                .manually_create_a_gateway_description3,
                            style: TextStyle(
                              color: Colors.amber,
                            ),
                          ),
                          DropdownButton<String>(
                            value: value,
                            onChanged: (String? newVal) {
                              state(() {
                                value = newVal;
                              });
                            },
                            items: l,
                          ),
                        ],
                      ).toList(),
                    )),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text(OpenIoTHubCommonLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(OpenIoTHubCommonLocalizations.of(context).add),
                    onPressed: () async {
                      GatewayInfo gatewayInfo =
                          await GatewayManager.generateOneGatewayWithServerUuid(
                              value!);
                      await _addToMySessionList(gatewayInfo.openIoTHubJwt,
                          gatewayInfo.name, gatewayInfo.description);
                      String uuid = gatewayInfo.gatewayUuid;
                      String gatewayJwt = gatewayInfo.gatewayJwt;
                      String data = '''
gatewayuuid: ${getOneUUID()}
logconfig:
  enablestdout: true
  logfilepath: ""
loginwithtokenmap:
  $uuid: $gatewayJwt
''';
                      Clipboard.setData(ClipboardData(text: data));
                      showSuccess(
                          OpenIoTHubCommonLocalizations.of(context).paste_info,
                          context);
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
        });
  }

  Future _addToMySessionList(String token, name, description) async {
    SessionConfig config = SessionConfig();
    config.token = token;
    config.name = name;
    config.description = description;
    try {
      await SessionApi.createOneSession(config);
      showSuccess(
          OpenIoTHubCommonLocalizations.of(context).add_gateway_success,
          context);
    } catch (exception) {
      showFailed(
          "${OpenIoTHubCommonLocalizations.of(context).login_failed}：${exception}",
          context);
    }
  }

  Future<List<DropdownMenuItem<String>>> _listAvailableServer() async {
    ServerInfoList serverInfoList = await ServerManager.getAllServer();
    List<DropdownMenuItem<String>> l = [];
    serverInfoList.serverInfoList.forEach((ServerInfo v) {
      l.add(DropdownMenuItem<String>(
        value: v.uuid,
        child: Text(
          "${v.name}(${v.serverHost}",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ));
    });
    return l;
  }
}
