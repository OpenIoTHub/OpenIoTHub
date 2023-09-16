import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iot_manager_grpc_api/iot_manager_grpc_api.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/user/LoginPage.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:provider/provider.dart';

class ZipDevicesPage extends StatefulWidget {
  @override
  _ZipDevicesPageState createState() => _ZipDevicesPageState();
}

class _ZipDevicesPageState extends State<ZipDevicesPage> {
  List<ZipLocalDevice> _zipLocalDeviceList = [];

  @override
  void initState() async {
    _findAllDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _zipLocalDeviceList.map(
      (pair) {
        var listItemContent = ListTile(
          leading: Icon(Icons.devices,
              color: Provider.of<CustomTheme>(context).isLightTheme()
                  ? CustomThemes.light.primaryColorLight
                  : CustomThemes.dark.primaryColorDark),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(pair.name, style: Constants.titleTextStyle),
            ],
          ),
          trailing: Constants.rightArrowIcon,
        );
        return InkWell(
          onTap: () {
            //点击设置mqtt服务器信息并添加设备到用户账号
            _ComfirmAddDeviceAndSetMqttServer(pair);
          },
          child: listItemContent,
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text("设备列表"),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  _findAllDevices();
                }),
          ],
        ),
        body: ListView(children: divided));
  }

  Future<void> _findAllDevices() async {
    setState(() async {
      _zipLocalDeviceList = await findZipDevicesFromLocal(1);
    });
  }

  Future<void> _ComfirmAddDeviceAndSetMqttServer(
      ZipLocalDevice zipLocalDevice) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("添加设备到云易连"),
                content: Text("确认添加该设备到云易连？"),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("确认"),
                    onPressed: () async {
                      // print("添加该设备到云易连");
                      _addDeviceAndSetMqttServer(zipLocalDevice)
                          .then((value) => Navigator.of(context).pop());
                    },
                  )
                ]));
  }

  Future<void> _addDeviceAndSetMqttServer(ZipLocalDevice zipLocalDevice) async {
    //  检查用户是否已经登录，如果没有登录则跳转到登录界面
    bool userSignedIned = await userSignedIn();
    if (!userSignedIned) {
      Fluttertoast.showToast(msg: "您还没有登录!请先登录再添加设备");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }
    //  添加设备到数据库
    MqttDeviceInfo mqttDeviceInfo = MqttDeviceInfo();
    mqttDeviceInfo.deviceId = zipLocalDevice.mac;
    mqttDeviceInfo.deviceModel =
        "com.iotserv.devices.mqtt.${zipLocalDevice.type_name}";
    await MqttDeviceManager.AddMqttDevice(mqttDeviceInfo);
    //  根据数据库生成mqtt的账号
    MqttInfo mqttInfo =
        await MqttDeviceManager.GenerateMqttUsernamePassword(mqttDeviceInfo);
    //  将生成的账号配置到设备
    await zipLocalDevice.configMqttServer(mqttInfo);
    //  提示配置结果
    Fluttertoast.showToast(msg: "添加成功!");
    return;
  }
}
