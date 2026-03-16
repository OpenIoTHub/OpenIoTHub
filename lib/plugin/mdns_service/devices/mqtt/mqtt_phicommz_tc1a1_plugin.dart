//MqttPhicommzTc1A1plug_:https://gitee.com/a2633063/zTC1
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub/common_pages/utils/toast.dart';

import 'package:openiothub/plugin/models/port_service_info.dart';
import '../../comm_widgets/info.dart';

class MqttPhicommzTc1A1PluginPage extends StatefulWidget {
  MqttPhicommzTc1A1PluginPage({required Key key, required this.device})
      : super(key: key);
  static final String modelName = "com.iotserv.devices.mqtt.zTC1";
  final PortServiceInfo device;

  @override
  _MqttPhicommzTc1A1PluginPageState createState() =>
      _MqttPhicommzTc1A1PluginPageState();
}

class _MqttPhicommzTc1A1PluginPageState
    extends State<MqttPhicommzTc1A1PluginPage> {
  late MqttServerClient client;
  late String topicSensor;
  late String topicState;

  //  总开关
  static const String plug_0 = "plug_0";

  static const String plug_1 = "plug_1";
  static const String plug_2 = "plug_2";
  static const String plug_3 = "plug_3";
  static const String plug_4 = "plug_4";
  static const String plug_5 = "plug_5";

  static const String power = "power";
  static const String totalTime = "total_time";

  List<String> _switchKeyList = [
    plug_0,
    plug_1,
    plug_2,
    plug_3,
    plug_4,
    plug_5
  ];
  List<String> _valueKeyList = [power, totalTime];

//  bool _logLedStatus = true;
//  bool _wifiLedStatus = true;
//  bool _primarySwitchStatus = true;
  Map<String, dynamic> _status = Map.from({
    plug_0: 0,
    plug_1: 0,
    plug_2: 0,
    plug_3: 0,
    plug_4: 0,
    plug_5: 0,
    power: 0.0,
    totalTime: 0,
  });

  Map<String, String> _realName = Map.from({
    plug_0: "插槽1",
    plug_1: "插槽2",
    plug_2: "插槽3",
    plug_3: "插槽4",
    plug_4: "插槽5",
    plug_5: "插槽6",
    power: "功率",
    totalTime: "累计运行时长",
  });

  Map<String, String> _unit = Map.from({
    power: "W",
    totalTime: "秒",
  });

  @override
  void initState() {
    super.initState();
    topicSensor = "device/ztc1/${widget.device.info!["mac"]}/sensor";
    topicState = "device/ztc1/${widget.device.info!["mac"]}/state";
    _initMqtt();
    print("init iot devie List");
  }

  @override
  void dispose() {
    client.unsubscribeStringTopic(topicSensor);
    client.unsubscribeStringTopic(topicState);
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.addAll(_switchKeyList);
    _result.addAll(_valueKeyList);
    final tiles = _result.map(
      (pair) {
        switch (pair) {
          case plug_0:
          case plug_1:
          case plug_2:
          case plug_3:
          case plug_4:
          case plug_5:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]!),
                  Switch(
                    onChanged: (bool value) {
                      _changeSwitchStatus(pair, value);
                    },
                    value: _status[pair] == 1,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
            );
            break;
          default:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]!),
                  Text(":"),
                  Text(_status[pair].toString()),
                  Text(_unit[pair]!),
                ],
              ),
            );
            break;
        }
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.info!["name"]!),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.green,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  _initMqtt() async {
    client = MqttServerClient.withPort(
        widget.device.addr,
        widget.device.info!.containsKey("client-id")
            ? widget.device.info!["client-id"]!
            : "",
        widget.device.port);
    client.autoReconnect = true;
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    client.onAutoReconnect = onAutoReconnect;
    client.onAutoReconnected = onAutoReconnected;
    final connMess = MqttConnectMessage()
        .withClientIdentifier(widget.device.info!["client-id"]!)
        .startClean();
    client.connectionMessage = connMess;
    try {
      //用户名密码
      await client.connect(
          widget.device.info!["username"], widget.device.info!["password"]);
    } on MqttNoConnectionException catch (e) {
      showFailed("MqttNoConnectionException:$e", context);
      client.disconnect();
    } on SocketException catch (e) {
      showFailed("SocketException:$e", context);
      client.disconnect();
    }
    //QoS
    client.subscribe(topicSensor, MqttQos.atMostOnce);
    client.subscribe(topicState, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      c.forEach((MqttReceivedMessage<MqttMessage> element) {
        final recMess = element.payload as MqttPublishMessage;
        final pt =
            MqttUtilities.bytesToStringAsString(recMess.payload.message!);
        // showToast(
        //     msg:
        //         'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        //  通过获取的消息更新状态
        Map<String, dynamic> m = jsonDecode(pt);
        _switchKeyList.forEach((String key) {
          if (m.containsKey(key)) {
            setState(() {
              _status[key] = m[key]["on"];
            });
          }
        });
        _valueKeyList.forEach((String key) {
          if (m.containsKey(key)) {
            setState(() {
              _status[key] = m[key];
            });
          }
        });
      });
    });
  }

  _info() async {
    // 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  _changeSwitchStatus(String name, bool value) async {
    final builder = MqttPayloadBuilder();
    builder.addString(
        '{"mac":"${widget.device.info!["mac"]}","$name":{"on":${value ? 1 : 0}}}');
    client.publishMessage("device/ztc1/${widget.device.info!["mac"]}/set",
        MqttQos.atLeastOnce, builder.payload!);
  }

  //mqtt的调用函数
  /// The subscribed callback
  void onSubscribed(MqttSubscription subscription) {
    showSuccess("onSubscribed:${subscription.topic}", context);
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    showSuccess("onDisconnected", context);
  }

  /// The successful connect callback
  void onConnected() {
    showSuccess(
        'EXAMPLE::OnConnected client callback - Client connection was successful', context);
  }

  /// Pong callback
  void pong() {
    showSuccess('EXAMPLE::Ping response client callback invoked', context);
  }

  void onAutoReconnect() {
    showSuccess('重连mqtt...', context);
  }

  void onAutoReconnected() {
    showSuccess('重连mqtt服务器成功！', context);
  }
}
