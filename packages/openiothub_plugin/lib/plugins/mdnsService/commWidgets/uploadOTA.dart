import 'package:flutter/material.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';

class UploadOTAPage extends StatefulWidget {
  UploadOTAPage({required Key key, this.url = ""}) : super(key: key);
  String url = "";

  @override
  _UploadOTAPageState createState() => _UploadOTAPageState();
}

class _UploadOTAPageState extends State<UploadOTAPage> {
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController _url_controller = TextEditingController.fromValue(
        TextEditingValue(text: "http://192.168.0.2/ota.bin"));
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(height: 10),
                Container(
                  child: TextField(
                    controller: _url_controller,
                    decoration: InputDecoration(labelText: OpenIoTHubPluginLocalizations.of(context).firmware_url),
                  ),
                ),
                Container(height: 10),
                TextButton(
                  child: Text(OpenIoTHubPluginLocalizations.of(context).start_ota),
                  onPressed: () {
                    _UploadBinFile(_url_controller.text);
                  },
                ),
              ],
            )),
      ),
    );
  }

  _UploadBinFile(String fromUrl) async {
//    Directory tempDir = await getTemporaryDirectory();
//    String localBinPath = path.join(tempDir.path, "ota.bin");
//    bool exist = await File(localBinPath).exists();
//    if (exist) {
//      await File(localBinPath).delete();
//    }
//    var downResponse = await Dio().download(fromUrl, localBinPath);
//    if (downResponse.statusCode != 200 ||
//        uploading ||
//        widget.url == null ||
//        widget.url == "") {
//      showDialog(
//        context: context,
//        builder: (_) => AlertDialog(
//            title: Text("OTA结果："),
//            content: Container(
//              height: 50,
//              child: ListView(
//                children: <Widget>[
//                  Text("下载设备程序失败！结果：${downResponse.statusCode}"),
//                ],
//              ),
//            ),
//            actions: <Widget>[
//              TextButton(
//                child: Text("确定"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              )
//            ]),
//      );
//      return;
//    }
//    uploading = true;
//    FormData formData = FormData.from(
//        {"update": UploadFileInfo(File(localBinPath), "ota.bin")});
//    var response = await Dio().post(widget.url, data: formData);
//    uploading = false;
//    await Navigator.of(context).pop();
//    if (response.statusCode == 200 && jsonDecode(response.data)["code"] == 0) {
////      成功
//      showDialog(
//        context: context,
//        builder: (_) => AlertDialog(
//            title: Text("OTA结果："),
//            content: Container(
//              height: 30,
//              child: ListView(
//                children: <Widget>[
//                  Text("更新成功！"),
//                ],
//              ),
//            ),
//            actions: <Widget>[
//              TextButton(
//                child: Text("确定"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              )
//            ]),
//      );
//    } else {
//      //      失败
//      showDialog(
//        context: context,
//        builder: (_) => AlertDialog(
//            title: Text("OTA结果："),
//            content: Container(
//              height: 30,
//              child: ListView(
//                children: <Widget>[
//                  Text("更新失败！"),
//                ],
//              ),
//            ),
//            actions: <Widget>[
//              TextButton(
//                child: Text("确定"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              )
//            ]),
//      );
//    }
  }
}
