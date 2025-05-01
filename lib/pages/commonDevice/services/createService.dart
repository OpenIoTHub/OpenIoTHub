import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub_api/api/OpenIoTHub/CommonDeviceApi.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

class CreateServiceWidget extends StatefulWidget {
  final Device device;

  CreateServiceWidget({required this.device});

  @override
  _CreateServiceWidgetState createState() => _CreateServiceWidgetState();
}

class _CreateServiceWidgetState extends State<CreateServiceWidget> {
  final _network_protocols = ['tcp', 'udp'];
  final _application_protocols = ['unknown', 'ftp', 'http'];
  String? _selected_network_option;
  String? _selected_application_option;
  // TODO 添加UDP、FTP端口
  TextEditingController nameController =
  TextEditingController.fromValue(TextEditingValue(
      text: ""));
  TextEditingController descriptionController =
  TextEditingController.fromValue(TextEditingValue(
      text: ""));
  TextEditingController remotePortController =
  TextEditingController.fromValue(const TextEditingValue(text: "80"));
  TextEditingController localPortController =
  TextEditingController.fromValue(const TextEditingValue(text: "0"));
  TextEditingController domainController = TextEditingController.fromValue(
      const TextEditingValue(text: "www.example.com"));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_selected_network_option==null||_selected_network_option!.isEmpty) {
      setState(() {
        _selected_network_option = _network_protocols.first;
      });
    }
    if (_selected_application_option==null||_selected_application_option!.isEmpty) {
      setState(() {
        _selected_application_option = _application_protocols.first;
      });
    }
    if (nameController.text.isEmpty) {
      setState(() {
        nameController.text = OpenIoTHubLocalizations.of(context).my_tcp_port;
      });
    }
    if (descriptionController.text.isEmpty) {
      setState(() {
        descriptionController.text = OpenIoTHubLocalizations.of(context).my_tcp_port;
      });
    }
    return AlertDialog(
        title: Text(OpenIoTHubLocalizations.of(context).add_port),
        content: SizedBox.expand(
            child: ListView(
              children: <Widget>[
                // 选择服务类型
                DropdownButton<String>(
                  value: _selected_network_option, // 当前选中的值
                  icon: Icon(Icons.arrow_downward), // 下拉图标，可以自定义
                  iconSize: 18, // 图标大小，可以自定义
                  elevation: 16, // 下拉阴影高度，可以自定义
                  style: TextStyle(color: Colors.blue), // 下拉菜单样式，可以自定义文本样式等
                  underline: Container( // 下拉菜单的下划线，可以自定义样式或去掉下划线
                    height: 2,
                    color: Colors.orange,
                  ),
                  onChanged: (String? newValue) { // 当选项改变时调用此函数
                    setState(() { // 使用setState来更新状态，从而触发界面重新构建
                      _selected_network_option = newValue; // 更新当前选中的值
                    });
                  },
                  items: _network_protocols // 下拉菜单的选项列表
                      .map<DropdownMenuItem<String>>((String value) { // 将字符串列表转换为DropdownMenuItem列表
                    return DropdownMenuItem<String>(
                      value: value, // 选项的值，用于与_selectedOption比较和赋值
                      child: Text(value), // 选项显示的文本内容
                    );
                  }).toList(), // 将map的结果转换为List以便于使用在items属性中
                ),
                DropdownButton<String>(
                  value: _selected_application_option, // 当前选中的值
                  icon: Icon(Icons.arrow_downward), // 下拉图标，可以自定义
                  iconSize: 18, // 图标大小，可以自定义
                  elevation: 16, // 下拉阴影高度，可以自定义
                  style: TextStyle(color: Colors.blue), // 下拉菜单样式，可以自定义文本样式等
                  underline: Container( // 下拉菜单的下划线，可以自定义样式或去掉下划线
                    height: 2,
                    color: Colors.orange,
                  ),
                  onChanged: (String? newValue) { // 当选项改变时调用此函数
                    setState(() { // 使用setState来更新状态，从而触发界面重新构建
                      _selected_application_option = newValue; // 更新当前选中的值
                    });
                  },
                  items: _application_protocols // 下拉菜单的选项列表
                      .map<DropdownMenuItem<String>>((String value) { // 将字符串列表转换为DropdownMenuItem列表
                    return DropdownMenuItem<String>(
                      value: value, // 选项的值，用于与_selectedOption比较和赋值
                      child: Text(value), // 选项显示的文本内容
                    );
                  }).toList(), // 将map的结果转换为List以便于使用在items属性中
                ),
                // name
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText:
                    OpenIoTHubLocalizations.of(context).name,
                    helperText:
                    OpenIoTHubLocalizations.of(context).custom_remarks,
                  ),
                ),
                // description
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText:
                    OpenIoTHubLocalizations.of(context).description,
                    helperText:
                    OpenIoTHubLocalizations.of(context).custom_remarks,
                  ),
                ),
                // remotePort
                TextFormField(
                  controller: remotePortController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: OpenIoTHubLocalizations.of(context)
                        .the_port_number_that_the_remote_machine_needs_to_access,
                    helperText:
                    OpenIoTHubLocalizations.of(context).remote_port,
                  ),
                ),
                // localPort
                TextFormField(
                  controller: localPortController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: OpenIoTHubLocalizations.of(context)
                        .map_to_the_port_number_of_this_mobile_phone,
                    helperText: OpenIoTHubLocalizations.of(context)
                        .this_phone_has_an_idle_port_number_of_1024_or_above,
                  ),
                ),
                // domain
                TextFormField(
                  controller: domainController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: OpenIoTHubLocalizations.of(context).domain,
                    helperText:
                    OpenIoTHubLocalizations.of(context).domain_notes,
                  ),
                ),
              ],
            )),
        actions: <Widget>[
          TextButton(
            child: Text(OpenIoTHubLocalizations.of(context).cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(OpenIoTHubLocalizations.of(context).add),
            onPressed: () {
              var tcpConfig = PortConfig();
              tcpConfig.device = widget.device;
              tcpConfig.name = nameController.text;
              tcpConfig.description = descriptionController.text;
              try {
                tcpConfig.remotePort =
                    int.parse(remotePortController.text);
                tcpConfig.localProt =
                    int.parse(localPortController.text);
              } catch (e) {
                showToast(
                    "${OpenIoTHubLocalizations.of(context).check_if_the_port_is_a_number}:$e");
                return;
              }
              tcpConfig.networkProtocol = _selected_network_option!;
              tcpConfig.applicationProtocol = _selected_application_option!;
              if (domainController.text != "www.example.com"&&!domainController.text.isEmpty) {
                tcpConfig.domain = domainController.text;
                tcpConfig.applicationProtocol = "http";
              } else {
                tcpConfig.applicationProtocol = "unknown";
              }
              switch (tcpConfig.networkProtocol) {
                case "tcp":
                  CommonDeviceApi.createOneTCP(tcpConfig).then((restlt) {
                    Navigator.of(context).pop();
                  });
                  break;
                case "udp":
                  CommonDeviceApi.createOneUDP(tcpConfig).then((restlt) {
                    Navigator.of(context).pop();
                  });
                  break;
              }
            },
          )
        ]);
  }
}
