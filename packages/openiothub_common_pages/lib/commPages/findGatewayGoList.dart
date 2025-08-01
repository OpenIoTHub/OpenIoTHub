import 'dart:async';
import 'dart:convert';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_common_pages/utils/toast.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/components.dart';
import 'package:openiothub_plugin/utils/portConfig2portService.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

const utf8encoder = Utf8Encoder();

class FindGatewayGoListPage extends StatefulWidget {
  const FindGatewayGoListPage({Key? key}) : super(key: key);

  @override
  State createState() => _FindGatewayGoListPageState();
}

class _FindGatewayGoListPageState extends State<FindGatewayGoListPage> {
  BonsoirDiscovery? action;
  final Map<String, PortService> _ServiceMap = {};

  // final flutterNsd = FlutterNsd();
  bool initialStart = true;
  bool _scanning = false;

  _FindGatewayGoListPageState();

  @override
  void initState() {
    super.initState();
    startDiscovery();
  }

  @override
  void dispose() {
    action!.stop();
    super.dispose();
  }

  Future<void> startDiscovery() async {
    if (_scanning) return;

    setState(() {
      _ServiceMap.clear();
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
    // print("onEventOccurred");
    // print(event.type);
    BonsoirService oneMdnsService = event.service!;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      // services.add(service);
      // print(oneMdnsService);
      oneMdnsService.resolve(action!.serviceResolver);
    } else if (event.type ==
        BonsoirDiscoveryEventType.discoveryServiceResolved) {
      // print(oneMdnsService);
      // services.removeWhere((foundService) => foundService.name == service.name);
      // services.add(service);
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
        if (!_ServiceMap.containsKey(_portService.info["id"])) {
          setState(() {
            _ServiceMap[_portService.info["id"]!] = _portService;
          });
        }
      });
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      // services.removeWhere((foundService) => foundService.name == service.name);
    }
  }

  Future<void> stopDiscovery() async {
    if (!_scanning) return;

    setState(() {
      _ServiceMap.clear();
      _scanning = false;
    });
    action!.stop();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceMap.values.map(
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
            // isOutline: true,
            isLight: true,
            fixedWidth: 100,
          ),
          trailing: Constants.rightArrowIcon,
          onTap: () async {
            if (!(await userSignedIn())) {
              show_failed("Please login before Add Gateway", context);
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
            // 对于mdns含有添加信息的，直接在本页面使用api添加
            if (pair.info.containsKey("run_id") &&
                !pair.info["run_id"]!.isEmpty) {
              // 确认添加
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
                      // 是否自动添加网关主机
                    ]),
                    titleColor: Colors.black,
                    contentColor: Colors.redAccent,
                    // backgroundColor: AppTheme.blockBgColor,
                    leftBtn: TDDialogButtonOptions(
                      title: OpenIoTHubCommonLocalizations.of(context).cancel,
                      // titleColor: AppTheme.color999,
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
            //直接打开内置web浏览器浏览页面
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//              return Text("${pair.iP}:${pair.port}");
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
          // IconButton(
          //     icon: Icon(
          //       Icons.refresh,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       _findClientListBymDNS();
          //     }),
          IconButton(
              icon: Icon(
                Icons.add_circle,
                // color: Colors.white,
              ),
              onPressed: () {
                _addGateway();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                // color: Colors.white,
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

  //已经确认过可以添加，添加到我的账号
  void _addToMyAccount(
      String gatewayId, String? host, name, description) async {
    try {
      // TODO 可以搞一个确认步骤，确认后添加
      // 使用扫描的Gateway ID构建一个GatewayInfo用于服务器添加
      GatewayInfo gatewayInfo = GatewayInfo(
          gatewayUuid: gatewayId,
          // 服务器的UUID变主机地址，或者都可以
          serverUuid: host,
          name: name,
          description: description);
      OperationResponse operationResponse =
          await GatewayManager.AddGateway(gatewayInfo);
      //将网关映射到本机
      if (operationResponse.code == 0) {
        // TODO 从服务器获取连接JWT
        StringValue openIoTHubJwt =
            await GatewayManager.GetOpenIoTHubJwtByGatewayUuid(gatewayId);
        await _addToMySessionList(
            openIoTHubJwt.value, gatewayInfo.name, gatewayInfo.description);
      } else {
        show_failed("Response: ${operationResponse.msg}", context);
      }
      //自动 添加网关主机
      var device = Device();
      device.runId = gatewayId;
      device.uuid = getOneUUID();
      device.name = name;
      device.description = description;
      device.addr = "127.0.0.1";
      await CommonDeviceApi.createOneDevice(device);
      //自动 添加网关界面端口
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
      show_failed("Failed: ${exception}", context);
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
                      // 从服务器自动生成一个网关
                      // TODO 选择服务器
                      GatewayInfo gatewayInfo =
                          await GatewayManager.GenerateOneGatewayWithServerUuid(
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
                      show_success(
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
      show_success(
          OpenIoTHubCommonLocalizations.of(context).add_gateway_success,
          context);
    } catch (exception) {
      show_failed(
          "${OpenIoTHubCommonLocalizations.of(context).login_failed}：${exception}",
          context);
    }
    // TODO 添加网关主机及网关软件的端口
  }

  Future<List<DropdownMenuItem<String>>> _listAvailableServer() async {
    ServerInfoList serverInfoList = await ServerManager.GetAllServer();
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
