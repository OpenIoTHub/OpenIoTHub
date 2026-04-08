import 'package:flutter/material.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';

import 'package:openiothub/common_pages/openiothub_common_pages.dart';

class ServerInfoPage extends StatefulWidget {
  const ServerInfoPage({required Key key, required this.serverInfo})
      : super(key: key);

  final ServerInfo serverInfo;

  @override
  State<ServerInfoPage> createState() => ServerInfoPageState();
}

class ServerInfoPageState extends State<ServerInfoPage> {
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
    TextEditingController nameController = TextEditingController.fromValue(
        TextEditingValue(text: widget.serverInfo.name));
    // string ServerHost = 3;
    TextEditingController serverHostController =
        TextEditingController.fromValue(
            TextEditingValue(text: widget.serverInfo.serverHost));
    // string LoginKey = 4;
    TextEditingController loginKeyController =
        TextEditingController.fromValue(
            TextEditingValue(text: widget.serverInfo.loginKey));
    // int32 TcpPort = 5;
    TextEditingController tcpPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.tcpPort}"));
    // int32 KcpPort = 6;
    TextEditingController kcpPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.kcpPort}"));
    // int32 UdpApiPort = 7;
    TextEditingController udpApiPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.udpApiPort}"));
    // int32 KcpApiPort = 8;
    TextEditingController kcpApiPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.kcpApiPort}"));
    // int32 TlsPort = 9;
    TextEditingController tlsPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.tlsPort}"));
    // int32 GrpcPort = 10;
    TextEditingController grpcPortController =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.grpcPort}"));
    // string Description = 11;
    TextEditingController descriptionController =
        TextEditingController.fromValue(
            TextEditingValue(text: widget.serverInfo.description));
    // bool IsPublic = 12;

    final l10n = OpenIoTHubLocalizations.of(context);
    List<Widget> tiles = <Widget>[
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
          onPressed: () async {
            final ctx = context;
            final l10n = OpenIoTHubLocalizations.of(ctx);
            ServerInfo serverInfo = ServerInfo();
            serverInfo.uuid = widget.serverInfo.uuid;
            serverInfo.name = nameController.text;
            serverInfo.serverHost = serverHostController.text;
            serverInfo.loginKey = loginKeyController.text;
            serverInfo.tcpPort = int.parse(tcpPortController.text);
            serverInfo.kcpPort = int.parse(kcpPortController.text);
            serverInfo.udpApiPort = int.parse(udpApiPortController.text);
            serverInfo.kcpApiPort = int.parse(kcpApiPortController.text);
            serverInfo.tlsPort = int.parse(tlsPortController.text);
            serverInfo.grpcPort = int.parse(grpcPortController.text);
            serverInfo.description = descriptionController.text;
            serverInfo.isPublic = _isPublic;
            await ServerManager.updateServer(serverInfo);
            if (!ctx.mounted) return;
            showSuccess(l10n.update_success, ctx);
          },
          child: Text(l10n.confirm_modify)),
    ];
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.server_info), actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              final ctx = context;
              final l10n = OpenIoTHubLocalizations.of(ctx);
              await ServerManager.delServer(widget.serverInfo);
              if (!ctx.mounted) return;
              showSuccess(l10n.common_delete_success, ctx);
              Navigator.of(ctx).pop();
            }),
      ]),
      body: ListView(children: divided),
    );
  }
}
