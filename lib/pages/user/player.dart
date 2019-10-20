import 'package:nat_explorer/pages/openWithChoice/sshWeb/fileExplorer/services/connection.dart';
import 'package:nat_explorer/pages/openWithChoice/sshWeb/fileExplorer/services/connection_methods.dart';
import 'package:nat_explorer/model/custom_theme.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

//void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '测试',
      theme: Provider.of<CustomTheme>(context).themeValue == "dark"
          ? CustomThemes.dark
          : CustomThemes.light,
      home: Scaffold(
        appBar: AppBar(title: Text('播放器'), actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: () {
                //                TODO 使用某种方式打开此端口，检查这个软件是否已经安装
                _pushSSHFileExplorer();
//                    _launchURL("http://127.0.0.1:${config.localProt}");
//                    PortConfig config = PortConfig();
//                    Device device = Device();
//                    device.runId = "runId";
//                    device.addr = "192.168.0.1";
//                    config.device = device;
//                    config.remotePort = 5900;
//                    showDialog(
//                        context: context,
//                        builder: (_) => AlertDialog(
//                          title: Text("打开方式："),
//                          content: OpenWithChoice(config),
//                          actions: <Widget>[
//                            FlatButton(
//                              child: Text("取消"),
//                              onPressed: () {
//                                Navigator.of(context).pop();
//                              },
//                            ),
//                            FlatButton(
//                              child: Text("添加"),
//                              onPressed: () {
//                                Navigator.of(context).pop();
//                              },
//                            )
//                          ]
//                        ));
              }),
        ]),
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _pushSSHFileExplorer() async {
    // 查看设备下的服务 CommonDeviceServiceTypesList
//    Navigator.of(context).push(
//      MaterialPageRoute(
//        builder: (context) {
//          // 写成独立的组件，支持刷新
//          return ConnectionPage(
//            Connection(
//              address: '192.168.0.15',
//              port: '22',
//              username: 'root',
//              passwordOrKey: 'root',
//              path: '~',
//            ),);
//        },//      ),
//    );

//    ConnectionMethods.connectClient(
//      context,
//      address: '192.168.0.15',
//      port: 22,
//      username: 'root',
//      passwordOrKey: 'root',
//    );

//        .then((bool connected) {
//      Navigator.popUntil(context, ModalRoute.withName("/"));
//      if (connected) {
//        ConnectionMethods.connect(
//          context,
//          Connection(
//            address: '192.168.0.15',
//            port: '22',
//            username: 'root',
//            passwordOrKey: 'root',
//            path: '~',
//          ),
//        );
//      } else {
//        Scaffold.of(context).showSnackBar(SnackBar(
//          duration: Duration(seconds: 5),
//          content: Text(
//            "Unable to connect to " + '192.168.0.15',
//          ),
//        ));
//      }
//    });

    Connection _connection = Connection();
    _connection.address = "192.168.0.15";
    _connection.port = "22";
    _connection.username = "root";
    _connection.passwordOrKey = "root";
    ConnectionMethods.connectClient(
      context,
      address: _connection.address,
      port: int.parse(_connection.port),
      username: _connection.username,
      passwordOrKey: _connection.passwordOrKey,
    ).then((bool connected) {
      Navigator.popUntil(context, ModalRoute.withName("/"));
      if (connected) {
        ConnectionMethods.connect(context, _connection);
      } else {
        print('fail');
      }
    });
  }
}
