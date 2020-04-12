//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'package:flutter/material.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:provider/provider.dart';
import '../../../model/portService.dart';
import '../commWidgets/info.dart';
import 'package:webdav/webdav.dart';

//手动注册一些端口到mdns的声明，用于接入一些传统的设备或者服务或者帮助一些不方便注册mdns的设备或服务注册
//需要选择模型和输入相关配置参数
class MDNSResponserPage extends StatefulWidget {
  MDNSResponserPage({Key key, this.serviceInfo}) : super(key: key);

  static final String modelName = "com.iotserv.services.mdnsResponser";
  final PortService serviceInfo;

  @override
  _MDNSResponserPageState createState() => _MDNSResponserPageState();
}

class _MDNSResponserPageState extends State<MDNSResponserPage> {
  List<String> pathHistory = ["/"];
  List<FileInfo> listFile = [];

  @override
  Widget build(BuildContext context) {
    final tiles = listFile.map(
          (pair) {
            return InkWell(
              onTap: () {
                if(pair.isDirectory){
                  pathHistory.add(pair.path);
                }
              },
              child: ListTile(
                leading: pair.isDirectory?Icon(Icons.folder_open,color: Provider.of<CustomTheme>(context).themeValue == "dark"
                    ? CustomThemes.dark.accentColor
                    : CustomThemes.light.accentColor,):Icon(Icons.insert_drive_file),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(pair.displayName),
                  ],
                ),
              ),
            );
      },
    );

    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(pathHistory.last),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {

              }),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: ListView(children: divided),
    );

  }

  _info() async {
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.serviceInfo,
          );
        },
      ),
    );
  }

}
