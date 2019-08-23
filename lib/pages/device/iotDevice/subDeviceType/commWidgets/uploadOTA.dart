import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
                      controller: null,
                      decoration: InputDecoration(labelText: '固件路径'),
                    ),
                  ),
                  RaisedButton(
                    child: Text('开始更新'),
                    onPressed: () {
                      setState(() {

                      });
                    },
                  ),
                ],
              )),
        ),
      );
  }

  _UploadBinFile(String path) async {
    if(uploading){
      return;
    }
    uploading = true;
    if(widget.url == null || widget.url == ""){
      widget.url = "/update";
    }
    FormData formData = FormData.from({
      "update": UploadFileInfo(File(path), "ota.bin")
    });
    var response = await Dio().post(widget.url, data: formData);
    uploading = false;
    if (response.statusCode == 200 && jsonDecode(response.data)["code"] == 0){
//      成功
    }
//      失败
  }

}
