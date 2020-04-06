//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:nat_explorer/model/custom_theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../model/portService.dart';
import '../commWidgets/info.dart';
import 'package:webdav/webdav.dart';

class WebDAVPage extends StatefulWidget {
  WebDAVPage({Key key, this.serviceInfo}) : super(key: key);

  static final String modelName = "com.iotserv.services.webdav";
  final PortService serviceInfo;

  @override
  _WebDAVPageState createState() => _WebDAVPageState();
}

class _WebDAVPageState extends State<WebDAVPage> {
  List<String> pathHistory = ["/"];
  List<FileInfo> listFile = [];

  @override
  void initState() {
    super.initState();
    _ls();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = listFile.map(
          (pair) {
            return InkWell(
              onTap: () {
                if(pair.isDirectory){
                  pathHistory.add(pair.path);
                  _ls();
                }else{
                  //TODO 文件，打开这个文件
                  _openWithWeb("http://${widget.serviceInfo.ip}:${widget.serviceInfo.port}" + pair.path);
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
                _ls();
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
      bottomNavigationBar: _buildBottomNavigationBar()
    );

  }

  _ls() async {
    Client webDAV = Client(widget.serviceInfo.ip, "", "", "/", protocol: "http",
        port: widget.serviceInfo.port);
    try{
      List<FileInfo> listFileRst = await webDAV.ls(pathHistory.last);
      print("listFileRst:$listFileRst");
      setState(() {
        listFile = listFileRst;
      });
    }catch (e){
      print(e.toString());
    }
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

  _openWithWeb(String url) async {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return Scaffold(
        appBar: AppBar(title: new Text("网页浏览器"), actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: () {
                _launchURL(url);
              })
        ]),
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          );
        }),
      );
    }));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            title: Text(
              '返回',
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.cloud_upload,
            ),
            title: Text(
              '上传',
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.cloud_download,
            ),
            title: Text(
              '离线下载',
            )),
      ],
      onTap: (int index) {
        switch(index){
          case 0:
            if(pathHistory.length > 1){
               pathHistory.removeLast();
               _ls();
            }
        }
      },
    );
  }

}
