import 'dart:async';
import 'dart:convert';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub/plugin/mdns_service/shared/components.dart';
import 'package:openiothub/plugin/registry/plugin_navigation.dart';
import 'package:openiothub/utils/plugin/port_config_to_port_service.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

const utf8encoder = Utf8Encoder();

class FindGatewayGoListPage extends StatefulWidget {
  const FindGatewayGoListPage({super.key});

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
    _checkSignedInAndStart();
  }

  Future<void> _checkSignedInAndStart() async {
    final nav = Navigator.of(context);
    final signedIn = await userSignedIn();
    if (!mounted) return;
    if (!signedIn) {
      nav.pop();
      nav.push(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }
    await startDiscovery();
  }

  @override
  void dispose() {
    if (action != null) {
      unawaited(action!.stop());
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
    if (!mounted) return;
    action!.eventStream?.listen(onEventOccurred);
    await action!.start();
    if (!mounted) return;
    debugPrint('gateway mdns discovery started');
  }

  void onEventOccurred(BonsoirDiscoveryEvent event) {
    if (event.service == null) {
      return;
    }
    final discovery = action;
    if (discovery == null || !mounted) {
      return;
    }
    BonsoirService oneMdnsService = event.service!;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      oneMdnsService.resolve(discovery.serviceResolver);
    } else if (event.type ==
        BonsoirDiscoveryEventType.discoveryServiceResolved) {
      if (!mounted || action == null) return;
      setState(() {
        final portService = PortService.create();
        portService.ip = (oneMdnsService as ResolvedBonsoirService)
            .host!
            .replaceAll(RegExp(r'.local.local.'), ".local")
            .replaceAll(RegExp(r'.local.'), ".local");
        debugPrint(portService.ip);
        portService.port = oneMdnsService.port;
        portService.isLocal = true;
        portService.info.addAll({
          "name":
              "${oneMdnsService.name}(${portService.ip}:${oneMdnsService.port})",
          "model": Gateway.modelName,
          "mac": "mac",
          "id": "${portService.ip}:${portService.port}",
          "author": "Farry",
          "email": "newfarry@126.com",
          "home-page": "https://github.com/OpenIoTHub",
          "firmware-respository": "https://github.com/OpenIoTHub/gateway-go",
          "firmware-version": "version",
        });

        for (final MapEntry<String, String> e
            in oneMdnsService.attributes.entries) {
          portService.info[e.key] = e.value;
        }
        debugPrint('_portService: $portService');
        if (!_serviceMap.containsKey(portService.info["id"])) {
          _serviceMap[portService.info["id"]!] = portService;
        }
      });
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
    }
  }

  Future<void> stopDiscovery() async {
    if (!_scanning) return;

    final act = action;
    setState(() {
      _serviceMap.clear();
      _scanning = false;
    });
    if (act != null) {
      await act.stop();
    }
  }

  /// 停止当前 Bonsoir 扫描后重新发现（例如从网关插件页返回后刷新列表）。
  Future<void> restartDiscovery() async {
    await stopDiscovery();
    if (!mounted) return;
    await startDiscovery();
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
            "version:${pair.info["version"] ?? pair.info["firmware-version"]}",
            theme: TDTagTheme.success,
            isLight: true,
            fixedWidth: 100,
          ),
          trailing: Constants.rightArrowIcon,
          onTap: () async {
            final ctx = context;
            if (!(await userSignedIn())) {
              if (!ctx.mounted) return;
              showFailed(
                OpenIoTHubLocalizations.of(ctx).please_login_before_add_gateway,
                ctx,
              );
              if (!(await userSignedIn())) {
                if (!ctx.mounted) return;
                Navigator.of(ctx)
                    .push(MaterialPageRoute(builder: (context) => const LoginPage()));
              }
            }
            if (!ctx.mounted) return;
            final nameController =
                TextEditingController.fromValue(
                    TextEditingValue(text: "Gateway-${DateTime.now().minute}"));
            final descriptionController =
                TextEditingController.fromValue(
                    TextEditingValue(text: "Gateway-${DateTime.now()}"));
            if (pair.info.containsKey("run_id") &&
                pair.info["run_id"]!.isNotEmpty) {
              showGeneralDialog(
                context: ctx,
                pageBuilder: (BuildContext buildContext,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return TDAlertDialog(
                    title: OpenIoTHubLocalizations.of(context)
                        .confirm_add_gateway,
                    contentWidget: Column(children: <Widget>[
                      TDInput(
                        leftLabel:
                            OpenIoTHubLocalizations.of(context).name,
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
                        leftLabel: OpenIoTHubLocalizations.of(context)
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
                      title: OpenIoTHubLocalizations.of(context).cancel,
                      style: TDButtonStyle(
                        backgroundColor: Colors.grey,
                      ),
                      action: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    rightBtn: TDDialogButtonOptions(
                      title: OpenIoTHubLocalizations.of(context).ok,
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
            if (!ctx.mounted) return;
            final gatewayDevice = portService2PortServiceInfo(pair);
            await ctx.pushPluginPage(Gateway.modelName, gatewayDevice);
            if (!ctx.mounted) return;
            await restartDiscovery();
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
            OpenIoTHubLocalizations.of(context).find_local_gateway_list),
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
      body: openIoTHubDesktopScrollableListBody(
        scrollable: ListView(children: divided),
      ),
    );
  }

  Future<void> _gatewayGuide() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GatewayGuidePage(
        key: UniqueKey(),
      );
    }));
  }

  Future<void> _addToMyAccount(
      String gatewayId, String? host, name, description) async {
    try {
      GatewayInfo gatewayInfo = GatewayInfo(
          gatewayUuid: gatewayId,
          serverUuid: host,
          name: name,
          description: description);
      OperationResponse operationResponse =
          await GatewayManager.addGateway(gatewayInfo);
      if (!mounted) return;
      if (operationResponse.code == 0) {
        StringValue openIoTHubJwt =
            await GatewayManager.getOpenIoTHubJwtByGatewayUuid(gatewayId);
        if (!mounted) return;
        await _addToMySessionList(
            openIoTHubJwt.value, gatewayInfo.name, gatewayInfo.description);
      } else {
        if (!mounted) return;
        showFailed(
          '${OpenIoTHubLocalizations.of(context).add_gateway_failed}: ${operationResponse.msg}',
          context,
        );
      }
      if (!mounted) return;
      var device = Device();
      device.runId = gatewayId;
      device.uuid = getOneUUID();
      device.name = name;
      device.description = description;
      device.addr = "127.0.0.1";
      await CommonDeviceApi.createOneDevice(device);
      if (!mounted) return;
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
      if (!mounted) return;
      showFailed(
        '${OpenIoTHubLocalizations.of(context).add_gateway_failed}: $exception',
        context,
      );
    }
  }

  Future<void> _addGateway() async {
    List<DropdownMenuItem<String>> l = await _listAvailableServer();
    if (!mounted) return;
    String? value = l.first.value;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context)
                    .manually_create_a_gateway),
                content: SizedBox(
                    width: 250,
                    height: 400,
                    child: ListView(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: [
                          Text(OpenIoTHubLocalizations.of(context)
                              .manually_create_a_gateway_description1),
                          Text(OpenIoTHubLocalizations.of(context)
                              .manually_create_a_gateway_description2),
                          Text(
                            OpenIoTHubLocalizations.of(context)
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
                        Text(OpenIoTHubLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).add),
                    onPressed: () async {
                      final dialogCtx = context;
                      GatewayInfo gatewayInfo =
                          await GatewayManager.generateOneGatewayWithServerUuid(
                              value!);
                      await _addToMySessionList(gatewayInfo.openIoTHubJwt,
                          gatewayInfo.name, gatewayInfo.description);
                      if (!dialogCtx.mounted) return;
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
                          OpenIoTHubLocalizations.of(dialogCtx).paste_info,
                          dialogCtx);
                      Navigator.of(dialogCtx).pop();
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
      if (!mounted) return;
      showSuccess(
          OpenIoTHubLocalizations.of(context).common_add_gateway_success,
          context);
    } catch (exception) {
      if (!mounted) return;
      showFailed(
          "${OpenIoTHubLocalizations.of(context).common_login_failed}：$exception",
          context);
    }
  }

  Future<List<DropdownMenuItem<String>>> _listAvailableServer() async {
    ServerInfoList serverInfoList = await ServerManager.getAllServer();
    List<DropdownMenuItem<String>> l = [];
    for (final ServerInfo v in serverInfoList.serverInfoList) {
      l.add(DropdownMenuItem<String>(
        value: v.uuid,
        child: Text(
          "${v.name}(${v.serverHost})",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ));
    }
    return l;
  }
}
