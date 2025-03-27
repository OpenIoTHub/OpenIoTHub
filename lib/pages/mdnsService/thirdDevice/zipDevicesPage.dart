import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/user/LoginPage.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/manager/mqttDeviceManager.pb.dart';
import 'package:provider/provider.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

class ZipDevicesPage extends StatefulWidget {
  const ZipDevicesPage({super.key});

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
          title: Text(OpenIoTHubLocalizations.of(context).device_list),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.refresh,
                  // color: Colors.white,
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
                title: Text(OpenIoTHubLocalizations.of(context).add_device_to_opneiothub),
                content: SizedBox.expand(child: Text(OpenIoTHubLocalizations.of(context).are_you_sure_to_add_this_device_to_openiothub)),
                actions: <Widget>[
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).confirm),
                    onPressed: () async {
                      // print("添加该设备到云亿连");
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
      showToast(OpenIoTHubLocalizations.of(context).you_havent_logged_in_yet);
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
    showToast(OpenIoTHubLocalizations.of(context).add_successful);
    return;
  }
}
