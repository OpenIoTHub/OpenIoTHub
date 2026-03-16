import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/common_pages/utils/toast.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';

import 'package:openiothub/common_pages/openiothub_common_pages.dart';

class ServerInfoPage extends StatefulWidget {
  ServerInfoPage({required Key key, required this.serverInfo})
      : super(key: key);

  final ServerInfo serverInfo;

  @override
  _ServerInfoPageState createState() => _ServerInfoPageState();
}

class _ServerInfoPageState extends State<ServerInfoPage> {
  bool _isPublic = false;

  @override
  void initState() {
    _isPublic = widget.serverInfo.isPublic;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // string Uuid = 1;
    // TextEditingController _uuid_controller = TextEditingController.fromValue(
    //     TextEditingValue(text: widget.serverInfo.uuid));
    // string Name = 2;
    TextEditingController _nameController = TextEditingController.fromValue(
        TextEditingValue(text: widget.serverInfo.name));
    // string ServerHost = 3;
    TextEditingController _serverHostController =
        TextEditingController.fromValue(
            TextEditingValue(text: widget.serverInfo.serverHost));
    // string LoginKey = 4;
    TextEditingController _loginKeyController =
        TextEditingController.fromValue(
            TextEditingValue(text: widget.serverInfo.loginKey));
    // int32 TcpPort = 5;
    TextEditingController _tcpPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.tcpPort}"));
    // int32 KcpPort = 6;
    TextEditingController _kcpPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.kcpPort}"));
    // int32 UdpApiPort = 7;
    TextEditingController _udpApiPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.udpApiPort}"));
    // int32 KcpApiPort = 8;
    TextEditingController _kcpApiPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.kcpApiPort}"));
    // int32 TlsPort = 9;
    TextEditingController _tlsPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.tlsPort}"));
    // int32 GrpcPort = 10;
    TextEditingController _grpcPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.grpcPort}"));
    // string Description = 11;
    TextEditingController _descriptionController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.description}"));
    // bool IsPublic = 12;

    List<Widget> tiles = <Widget>[
      TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: OpenIoTHubCommonLocalizations.of(context).name,
          helperText: OpenIoTHubCommonLocalizations.of(context).define_server_name,
        ),
      ),
      TextFormField(
        controller: _serverHostController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: OpenIoTHubCommonLocalizations.of(context).define_server_ip_or_domain,
          helperText: OpenIoTHubCommonLocalizations.of(context).define_server_addr,
        ),
      ),
      TextFormField(
        controller: _loginKeyController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'login_key',
          helperText: OpenIoTHubCommonLocalizations.of(context).define_server_key,
        ),
      ),
      TextFormField(
        controller: _tcpPortController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'tcp_port',
          helperText: OpenIoTHubCommonLocalizations.of(context).define_server_tcp_port,
        ),
      ),
      TextFormField(
        controller: _kcpPortController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'kcp_port',
          helperText: OpenIoTHubCommonLocalizations.of(context).define_server_kcp_port,
        ),
      ),
      TextFormField(
        controller: _udpApiPortController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'udp_api_port',
          helperText: OpenIoTHubCommonLocalizations.of(context).port,
        ),
      ),
      TextFormField(
        controller: _kcpApiPortController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'kcp_api_port',
          helperText: OpenIoTHubCommonLocalizations.of(context).port,
        ),
      ),
      TextFormField(
        controller: _tlsPortController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'tls_port',
          helperText: OpenIoTHubCommonLocalizations.of(context).port,
        ),
      ),
      TextFormField(
        controller: _grpcPortController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'grpc_port',
          helperText: OpenIoTHubCommonLocalizations.of(context).port,
        ),
      ),
      TextFormField(
        controller: _descriptionController,
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
              value: _isPublic,
              onChanged: null,
              // TODO 服务器不可公开
              // onChanged: (bool newVal) {
              //   setState(() {
              //     _isPublic = newVal;
              //   });}
          )
        ],
      ),
      TextButton(
          onPressed: () {
            ServerInfo serverInfo = ServerInfo();
            serverInfo.uuid = widget.serverInfo.uuid;
            serverInfo.name = _nameController.text;
            serverInfo.serverHost = _serverHostController.text;
            serverInfo.loginKey = _loginKeyController.text;
            serverInfo.tcpPort = int.parse(_tcpPortController.text);
            serverInfo.kcpPort = int.parse(_kcpPortController.text);
            serverInfo.udpApiPort = int.parse(_udpApiPortController.text);
            serverInfo.kcpApiPort = int.parse(_kcpApiPortController.text);
            serverInfo.tlsPort = int.parse(_tlsPortController.text);
            serverInfo.grpcPort = int.parse(_grpcPortController.text);
            serverInfo.description = _descriptionController.text;
            serverInfo.isPublic = _isPublic;
            ServerManager.updateServer(serverInfo)
                .then((value) => showSuccess(OpenIoTHubCommonLocalizations.of(context).update_success, context));
          },
          child: Text(OpenIoTHubCommonLocalizations.of(context).confirm_modify)),
    ];
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text(OpenIoTHubCommonLocalizations.of(context).server_info), actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              ServerManager.delServer(widget.serverInfo)
                  .then((value) => showSuccess(OpenIoTHubCommonLocalizations.of(context).delete_success, context))
                  .then((value) => Navigator.of(context).pop());
            }),
      ]),
      body: ListView(children: divided),
    );
  }
}
