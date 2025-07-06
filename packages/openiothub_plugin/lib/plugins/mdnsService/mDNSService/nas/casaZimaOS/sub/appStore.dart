import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class AppStorePage extends StatefulWidget {
  const AppStorePage(
      {super.key, required this.baseUrl, required this.data});

  final String baseUrl;
  final Map<String, dynamic> data;

  @override
  State<AppStorePage> createState() => _AppStorePageState();
}

class _AppStorePageState extends State<AppStorePage> {
  late List<ListTile> _listTiles = <ListTile>[];

  @override
  void initState() {
    _initListTiles();
    // 通过websocket获取安装进度
    // https://pub.dev/packages/web_socket_channel
    // ws://192.168.124.33/v2/message_bus/socket.io/?EIO=3&transport=websocket
    // 42["casaos:system:utilization",{"ID":0,"SourceID":"casaos","Name":"casaos:system:utilization","Properties":{"sys_cpu":"{\"model\":\"intel\",\"num\":2,\"percent\":4.5,\"power\":{\"timestamp\":\"1744639093\",\"value\":\"0\"},\"temperature\":0}","sys_disk":"{\"avail\":185271488512,\"health\":true,\"size\":209129086976,\"used\":13159870464}","sys_mem":"{\"available\":1677094912,\"free\":109686784,\"total\":3111690240,\"used\":1234653184,\"usedPercent\":39.7}","sys_net":"[{\"name\":\"ens3\",\"bytesSent\":92522951,\"bytesRecv\":134019646,\"packetsSent\":223798,\"packetsRecv\":353210,\"errin\":0,\"errout\":0,\"dropin\":818,\"dropout\":0,\"fifoin\":0,\"fifoout\":0,\"state\":\"up\",\"time\":1744639093}]","sys_usb":"[]"},"Timestamp":1744639093,"uuid":"d1aa1cd4-c661-49bc-bc27-3c0abdb4cb25"}]
    // 42["docker:image:pull-begin",{"ID":0,"SourceID":"app-management","Name":"docker:image:pull-begin","Properties":{"app:icon":"https://cdn.jsdelivr.net/gh/IceWhaleTech/CasaOS-AppStore@main/Apps/Ddns-go/icon.png","app:name":"ddns-go","app:title":"{\"en_us\":\"ddns-go\"}","check_port_conflict":"true","docker:image:name":"jeessy/ddns-go:v6.8.1","dry_run":"false"},"Timestamp":1744638830,"uuid":"4762db94-b6e8-4915-90bb-b23b89ea29ef"}]
    // 42["app:install-progress",{"ID":0,"SourceID":"app-management","Name":"app:install-progress","Properties":{"app:icon":"https://cdn.jsdelivr.net/gh/IceWhaleTech/CasaOS-AppStore@main/Apps/Ddns-go/icon.png","app:name":"ddns-go","app:progress":"0","app:title":"{\"en_us\":\"ddns-go\"}","check_port_conflict":"true","dry_run":"false"},"Timestamp":1744638834,"uuid":"d22aeb7f-90ad-4418-abc9-54ecaa792c85"}]
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AppStore"),
          // actions: <Widget>[
          // TODO 查看和添加源
          //   // 系统的各种状态
          //   IconButton(
          //       icon: Icon(
          //         TDIcons.chart,
          //         // color: Colors.white,
          //       ),
          //       onPressed: () {
          //
          //       }),
          // ],
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            return _buildListTile(index);
          },
          separatorBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(left: 50), // 添加左侧缩进
              child: TDDivider(),
            );
          },
          itemCount: _listTiles.length,
        ));
  }

  ListTile _buildListTile(int index) {
    return _listTiles[index];
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Center(child: child),
    );
  }

  Future<void> _initListTiles() async {
    _listTiles.clear();
    //从API获取已安装应用列表
    final dio = Dio(BaseOptions(
        baseUrl: widget.baseUrl,
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v2/app_management/apps";
    final response = await dio.getUri(Uri.parse(reqUri));
    response.data["data"]["list"].forEach((appName, appInfo) {
      // TODO 使用远程网络ID和远程端口临时映射远程端口到本机
      // TODO 获取当前服务映射到本机的端口号
      setState(() {
        _listTiles.add(ListTile(
            //第一个功能项
            title: Text(appName),
            subtitle: Text(appInfo["category"], style: TextStyle(color: Colors.grey),),
            leading: _sizedContainer(
              CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
                imageUrl: appInfo["icon"] == null
                    ? "${widget.baseUrl}/img/default.0a7cfbf2.svg"
                    : appInfo["icon"],
              ),
            ),
            // 根据有没有安装判断显示已安装按钮还是显示安装操作按钮
            trailing: response.data["data"]["installed"].contains(appName)
                ? TDButton(
                    text: 'Installed',
                    size: TDButtonSize.small,
                    type: TDButtonType.fill,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.light,
                    disabled: true,
                    onTap: () {
                      // TODO 安装
                    },
                  )
                : TDButton(
                    text: 'Install',
                    size: TDButtonSize.small,
                    type: TDButtonType.fill,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.primary,
                    onTap: () {
                      // TODO 安装
                      _installApp(appName);
                    },
                  ),
            onTap: () {
              // TODO 判断有没有安装，没有就提示确认安装
            }));
      });
    });
  }

  _installApp(String appName) async {
    _getAppCompose(appName).then(_installAppCompose).then((value) {
      TDMessage.showMessage(
        context: context,
        content: 'The installation task has been submitted, return to the list of installed software and wait for installation to complete',
        visible: true,
        icon: false,
        theme: MessageTheme.success,
        duration: 3000,
        onDurationEnd: () {
          print('message end');
        },
      );
    });
  }

  Future<String> _getAppCompose(String appName) async {
    final dio = Dio(BaseOptions(
        baseUrl: widget.baseUrl,
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"],
          "Accept": "application/yaml"
        }));
    String reqUri = "/v2/app_management/apps/$appName/compose";
    final response = await dio.getUri(Uri.parse(reqUri));
    return response.toString();
  }

  _installAppCompose(String compose) async {
    final dio = Dio(BaseOptions(
        baseUrl: widget.baseUrl,
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"],
          "Content-Type": "application/yaml"
        }));
    String reqUri =
        "/v2/app_management/compose?dry_run=false&check_port_conflict=true";
    final response = await dio.postUri(Uri.parse(reqUri), data: compose);
    // showToast(response.data);
  }
}
