import 'package:flutter/material.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/common_pages/server_info.dart';
import 'package:openiothub/core/constants.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';

import 'package:openiothub/common_pages/openiothub_common_pages.dart';

class ServerPages extends StatefulWidget {
  const ServerPages({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  createState() => ServerPagesState();
}

class ServerPagesState extends State<ServerPages> {
  List<ServerInfo> _availableServerList = [];

  @override
  void initState() {
    super.initState();
    _listMyServers();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _availableServerList.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.send_rounded),
              ),
              Expanded(
                  child: Text(
                "${pair.name}(${pair.serverHost})",
                style: Constants.titleTextStyle,
              )),
              Constants.rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ServerInfoPage(
                serverInfo: pair,
                key: UniqueKey(),
              );
            })).then((value) => _listMyServers());
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
                  // color: Colors.white,
                ),
                onPressed: () {
                  //刷新端口列表
                  _listMyServers();
                }),
            IconButton(
                icon: Icon(
                  Icons.add_circle,
                  // color: Colors.white,
                ),
                onPressed: () {
                  //刷新端口列表
                  _addMyServer(context);
                }),
          ],
        ),
        body: ListView(
          children: divided,
        ));
  }

  void _listMyServers() {
    ServerManager.getAllMyServers()
        .then((ServerInfoList serverInfoList) => setState(() {
              _availableServerList = serverInfoList.serverInfoList;
            }));
  }

  Future<void> _addMyServer(BuildContext context) async {
    // string Uuid = 1;
    TextEditingController uuidController =
        TextEditingController.fromValue(TextEditingValue(text: getOneUUID()));
    // string Name = 2;
    TextEditingController nameController = TextEditingController.fromValue(
        TextEditingValue(text: OpenIoTHubLocalizations.of(context).my_server_description_example));
    // string ServerHost = 3;
    TextEditingController serverHostController =
        TextEditingController.fromValue(
            TextEditingValue(text: OpenIoTHubLocalizations.of(context).server_go_addr_example));
    // string LoginKey = 4;
    TextEditingController loginKeyController =
        TextEditingController.fromValue(TextEditingValue(text: getOneUUID()));
    // int32 TcpPort = 5;
    TextEditingController tcpPortController =
        TextEditingController.fromValue(TextEditingValue(text: "34320"));
    // int32 KcpPort = 6;
    TextEditingController kcpPortController =
        TextEditingController.fromValue(TextEditingValue(text: "34320"));
    // int32 UdpApiPort = 7;
    TextEditingController udpApiPortController =
        TextEditingController.fromValue(TextEditingValue(text: "34321"));
    // int32 KcpApiPort = 8;
    TextEditingController kcpApiPortController =
        TextEditingController.fromValue(TextEditingValue(text: "34322"));
    // int32 TlsPort = 9;
    TextEditingController tlsPortController =
        TextEditingController.fromValue(TextEditingValue(text: "34321"));
    // int32 GrpcPort = 10;
    TextEditingController grpcPortController =
        TextEditingController.fromValue(TextEditingValue(text: "34322"));
    // string Description = 11;
    TextEditingController descriptionController =
        TextEditingController.fromValue(TextEditingValue(text: OpenIoTHubLocalizations.of(context).my_server_description));
    // bool IsPublic = 12;
    bool isPublic = false;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              final l10n = OpenIoTHubLocalizations.of(context);
              return AlertDialog(
                  title: Text(l10n.add_self_hosted_server),
                  content: SizedBox.expand(
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          controller: uuidController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.server_uuid,
                            helperText: l10n.as_config_file,
                          ),
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.name,
                            helperText: l10n.define_server_name,
                          ),
                        ),
                        TextFormField(
                          controller: serverHostController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.define_server_ip_or_domain,
                            helperText: l10n.define_server_addr,
                          ),
                        ),
                        TextFormField(
                          controller: loginKeyController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.server_field_login_key,
                            helperText: l10n.define_server_key,
                          ),
                        ),
                        TextFormField(
                          controller: tcpPortController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.server_field_tcp_port,
                            helperText: l10n.define_server_tcp_port,
                          ),
                        ),
                        TextFormField(
                          controller: kcpPortController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.server_field_kcp_port,
                            helperText: l10n.define_server_kcp_port,
                          ),
                        ),
                        TextFormField(
                          controller: udpApiPortController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.server_field_udp_api_port,
                            helperText: l10n.port,
                          ),
                        ),
                        TextFormField(
                          controller: kcpApiPortController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.server_field_kcp_api_port,
                            helperText: l10n.port,
                          ),
                        ),
                        TextFormField(
                          controller: tlsPortController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.server_field_tls_port,
                            helperText: l10n.port,
                          ),
                        ),
                        TextFormField(
                          controller: grpcPortController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.server_field_grpc_port,
                            helperText: l10n.port,
                          ),
                        ),
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: l10n.description,
                            helperText: l10n.define_description,
                          ),
                        ),
                        Row(
                          children: [
                            Text(l10n.for_everyone_to_use),
                            Switch(
                                value: isPublic,
                                onChanged: null,
                                // TODO 服务器不可公开
                                // onChanged: (bool newVal) {
                                //   state(() {
                                //     isPublic = newVal;
                                //   });
                                // }
                                )
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(l10n.cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(l10n.add_to_server),
                      onPressed: () async {
                        final ctx = context;
                        final l10n = OpenIoTHubLocalizations.of(ctx);
                        final addedName = nameController.text;
                        ServerInfo serverInfo = ServerInfo();
                        serverInfo.uuid = uuidController.text;
                        serverInfo.name = nameController.text;
                        serverInfo.serverHost = serverHostController.text;
                        serverInfo.loginKey = loginKeyController.text;
                        serverInfo.tcpPort =
                            int.parse(tcpPortController.text);
                        serverInfo.kcpPort =
                            int.parse(kcpPortController.text);
                        serverInfo.udpApiPort =
                            int.parse(udpApiPortController.text);
                        serverInfo.kcpApiPort =
                            int.parse(kcpApiPortController.text);
                        serverInfo.tlsPort =
                            int.parse(tlsPortController.text);
                        serverInfo.grpcPort =
                            int.parse(grpcPortController.text);
                        serverInfo.description = descriptionController.text;
                        serverInfo.isPublic = isPublic;
                        await ServerManager.addServer(serverInfo);
                        if (!ctx.mounted) return;
                        showSuccess("${l10n.add_server}($addedName)${l10n.success}", ctx);
                        Navigator.of(ctx).pop();
                        _listMyServers();
                      },
                    )
                  ]);
            },
          );
        });
  }
}
