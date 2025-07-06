import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/serverInfo.dart';
import 'package:openiothub_common_pages/utils/toast.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';

import 'package:openiothub_common_pages/openiothub_common_pages.dart';

class ServerPages extends StatefulWidget {
  ServerPages({required Key key, required this.title}) : super(key: key);

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
    ServerManager.GetAllMyServers()
        .then((ServerInfoList serverInfoList) => setState(() {
              _availableServerList = serverInfoList.serverInfoList;
            }));
  }

  Future<void> _addMyServer(BuildContext context) async {
    // string Uuid = 1;
    TextEditingController _uuid_controller =
        TextEditingController.fromValue(TextEditingValue(text: getOneUUID()));
    // string Name = 2;
    TextEditingController _name_controller = TextEditingController.fromValue(
        TextEditingValue(text: OpenIoTHubCommonLocalizations.of(context).my_server_description_example));
    // string ServerHost = 3;
    TextEditingController _server_host_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: OpenIoTHubCommonLocalizations.of(context).server_go_addr_example));
    // string LoginKey = 4;
    TextEditingController _login_key_controller =
        TextEditingController.fromValue(TextEditingValue(text: getOneUUID()));
    // int32 TcpPort = 5;
    TextEditingController _tcp_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34320"));
    // int32 KcpPort = 6;
    TextEditingController _kcp_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34320"));
    // int32 UdpApiPort = 7;
    TextEditingController _udp_api_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34321"));
    // int32 KcpApiPort = 8;
    TextEditingController _kcp_api_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34322"));
    // int32 TlsPort = 9;
    TextEditingController _tls_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34321"));
    // int32 GrpcPort = 10;
    TextEditingController _grpc_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34322"));
    // string Description = 11;
    TextEditingController _description_controller =
        TextEditingController.fromValue(TextEditingValue(text: OpenIoTHubCommonLocalizations.of(context).my_server_description));
    // bool IsPublic = 12;
    bool _is_public = false;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return AlertDialog(
                  title: Text(OpenIoTHubCommonLocalizations.of(context).add_self_hosted_server),
                  content: SizedBox.expand(
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          controller: _uuid_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: OpenIoTHubCommonLocalizations.of(context).server_uuid,
                            helperText: OpenIoTHubCommonLocalizations.of(context).as_config_file,
                          ),
                        ),
                        TextFormField(
                          controller: _name_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: OpenIoTHubCommonLocalizations.of(context).name,
                            helperText: OpenIoTHubCommonLocalizations.of(context).define_server_name,
                          ),
                        ),
                        TextFormField(
                          controller: _server_host_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: OpenIoTHubCommonLocalizations.of(context).define_server_ip_or_domain,
                            helperText: OpenIoTHubCommonLocalizations.of(context).define_server_addr,
                          ),
                        ),
                        TextFormField(
                          controller: _login_key_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'login_key',
                            helperText: OpenIoTHubCommonLocalizations.of(context).define_server_key,
                          ),
                        ),
                        TextFormField(
                          controller: _tcp_port_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'tcp_port',
                            helperText: OpenIoTHubCommonLocalizations.of(context).define_server_tcp_port,
                          ),
                        ),
                        TextFormField(
                          controller: _kcp_port_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'kcp_port',
                            helperText: OpenIoTHubCommonLocalizations.of(context).define_server_kcp_port,
                          ),
                        ),
                        TextFormField(
                          controller: _udp_api_port_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'udp_api_port',
                            helperText: OpenIoTHubCommonLocalizations.of(context).port,
                          ),
                        ),
                        TextFormField(
                          controller: _kcp_api_port_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'kcp_api_port',
                            helperText: OpenIoTHubCommonLocalizations.of(context).port,
                          ),
                        ),
                        TextFormField(
                          controller: _tls_port_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'tls_port',
                            helperText: OpenIoTHubCommonLocalizations.of(context).port,
                          ),
                        ),
                        TextFormField(
                          controller: _grpc_port_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'grpc_port',
                            helperText: OpenIoTHubCommonLocalizations.of(context).port,
                          ),
                        ),
                        TextFormField(
                          controller: _description_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: OpenIoTHubCommonLocalizations.of(context).description,
                            helperText: OpenIoTHubCommonLocalizations.of(context).define_description,
                          ),
                        ),
                        Row(
                          children: [
                            Text(OpenIoTHubCommonLocalizations.of(context).for_everyone_to_use),
                            Switch(
                                value: _is_public,
                                onChanged: null,
                                // TODO 服务器不可公开
                                // onChanged: (bool newVal) {
                                //   state(() {
                                //     _is_public = newVal;
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
                      child: Text(OpenIoTHubCommonLocalizations.of(context).cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(OpenIoTHubCommonLocalizations.of(context).add_to_server),
                      onPressed: () {
                        ServerInfo serverInfo = ServerInfo();
                        serverInfo.uuid = _uuid_controller.text;
                        serverInfo.name = _name_controller.text;
                        serverInfo.serverHost = _server_host_controller.text;
                        serverInfo.loginKey = _login_key_controller.text;
                        serverInfo.tcpPort =
                            int.parse(_tcp_port_controller.text);
                        serverInfo.kcpPort =
                            int.parse(_kcp_port_controller.text);
                        serverInfo.udpApiPort =
                            int.parse(_udp_api_port_controller.text);
                        serverInfo.kcpApiPort =
                            int.parse(_kcp_api_port_controller.text);
                        serverInfo.tlsPort =
                            int.parse(_tls_port_controller.text);
                        serverInfo.grpcPort =
                            int.parse(_grpc_port_controller.text);
                        serverInfo.description = _description_controller.text;
                        serverInfo.isPublic = _is_public;
                        ServerManager.AddServer(serverInfo)
                            .then((value) =>
                                show_success("${OpenIoTHubCommonLocalizations.of(context).add_server}(${_name_controller.text})${OpenIoTHubCommonLocalizations.of(context).success}", context))
                            .then((value) => Navigator.of(context).pop())
                            .then((value) => _listMyServers());
                      },
                    )
                  ]);
            },
          );
        });
  }
}
