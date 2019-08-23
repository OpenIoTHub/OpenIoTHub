import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UploadOTAPage extends StatefulWidget {
  UploadOTAPage({Key key, this.url}) : super(key: key);
  String url;
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
                      decoration: InputDecoration(labelText: '固件网址'),
                    ),
                  ),
                  RaisedButton(
                    child: Text('开始更新'),
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
    Directory tempDir = await getTemporaryDirectory();
    String localBinPath = path.join(tempDir.path,"ota.bin");
    bool exist = await File(localBinPath).exists();
    if (exist) {
      await File(localBinPath).delete();
    }
    var downResponse = await Dio().download(fromUrl, localBinPath);
    if (downResponse.statusCode != 200){
      return;
    }
    if(uploading){
      return;
    }
    uploading = true;
    if(widget.url == null || widget.url == ""){
      widget.url = "/update";
    }
    FormData formData = FormData.from({
      "update": UploadFileInfo(File(localBinPath), "ota.bin")
    });
    var response = await Dio().post(widget.url, data: formData);
    uploading = false;
    if (response.statusCode == 200 && jsonDecode(response.data)["code"] == 0){
//      成功
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
              title: Text("设置名称："),
              content: ListView(
                children: <Widget>[
                  Text("更新成功！"),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("确定"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]),
      );
    }
//      失败
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: Text("设置名称："),
          content: ListView(
            children: <Widget>[
              Text("更新失败！"),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("确定"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]),
    );
  }

}
