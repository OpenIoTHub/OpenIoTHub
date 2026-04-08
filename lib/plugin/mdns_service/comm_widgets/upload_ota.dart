import 'package:flutter/material.dart';
import 'package:openiothub/plugin/openiothub_plugin.dart';
import 'package:openiothub/utils/openiothub_desktop_layout.dart';

class UploadOTAPage extends StatefulWidget {
  const UploadOTAPage({super.key, this.url = ''});

  final String url;

  @override
  State<UploadOTAPage> createState() => UploadOTAPageState();
}

class UploadOTAPageState extends State<UploadOTAPage> {
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController urlController = TextEditingController.fromValue(
      TextEditingValue(text: "http://192.168.0.2/ota.bin"),
    );
    return Scaffold(
      body: Center(
        child: openIoTHubDesktopConstrainedBody(
          maxWidth: 480,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(height: 10),
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: OpenIoTHubLocalizations.of(context).firmware_url,
                  ),
                ),
                Container(height: 10),
                TextButton(
                  child: Text(OpenIoTHubLocalizations.of(context).start_ota),
                  onPressed: () {
                    _uploadBinFile(urlController.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _uploadBinFile(String fromUrl) async {
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
