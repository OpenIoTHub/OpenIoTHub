//MqttPhicommzM1plug_:https://gitee.com/a2633063/zM1
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_seekbar/flutter_seekbar.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/utils/toast.dart';

import '../../../../models/PortServiceInfo.dart';
import '../../commWidgets/info.dart';

class MqttPhicommzM1PluginPage extends StatefulWidget {
  MqttPhicommzM1PluginPage({required Key key, required this.device})
      : super(key: key);
  static final String modelName = "com.iotserv.devices.mqtt.zM1";
  final PortServiceInfo device;

  @override
  _MqttPhicommzM1PluginPageState createState() =>
      _MqttPhicommzM1PluginPageState();
}

class _MqttPhicommzM1PluginPageState extends State<MqttPhicommzM1PluginPage> {
  late MqttServerClient client;
  late String topic_sensor;
  late String topic_set;

  static const String brightness = "brightness";
  static const String temperature = "temperature";
  static const String humidity = "humidity";
  static const String pm25 = "PM25";
  static const String hcho = "formaldehyde";

  List<String> _valueKeyList = [brightness, temperature, humidity, pm25, hcho];

  List<SectionTextModel> sectionTexts = [
    SectionTextModel(position: 0, text: '关闭', progressColor: Colors.red),
    SectionTextModel(position: 1, text: '1', progressColor: Colors.green),
    SectionTextModel(position: 2, text: '2', progressColor: Colors.blue),
    SectionTextModel(position: 3, text: '3', progressColor: Colors.purple),
    SectionTextModel(position: 4, text: '4', progressColor: Colors.amber),
  ];

  Map<String, dynamic> _status =
      Map.from({brightness: 0, temperature: 0, humidity: 0, pm25: 0, hcho: 0});

  Map<String, String> _realName = Map.from({
    brightness: "亮度",
    temperature: "温度",
    humidity: "湿度",
    pm25: "PM2.5",
    hcho: "甲醛"
  });

  Map<String, String> _unit = Map.from(
      {brightness: "", temperature: "", humidity: "", pm25: "", hcho: ""});

  @override
  void initState() {
    super.initState();
    topic_sensor = "device/zm1/${widget.device.info!["mac"]}/sensor";
    topic_set = "device/zm1/${widget.device.info!["mac"]}/set";
    _initMqtt();
    print("init iot devie List");
  }

  @override
  void dispose() {
    client.unsubscribeStringTopic(topic_sensor);
    client.unsubscribeStringTopic(topic_set);
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.addAll(_valueKeyList);
    final tiles = _result.map(
      (pair) {
        switch (pair) {
          case brightness:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]!),
                  Text(":"),
                  SeekBar(
                    indicatorRadius: 0.0,
                    progresseight: 5,
                    hideBubble: false,
                    alwaysShowBubble: true,
                    bubbleRadius: 14,
                    bubbleColor: Colors.purple,
                    bubbleTextColor: Colors.white,
                    bubbleTextSize: 14,
                    bubbleMargin: 4,
                    bubbleInCenter: true,
                    sectionTexts: sectionTexts,
                    onValueChanged: (v) {
                      _changeStatus(pair, v.value.toInt());
                    },
                    key: UniqueKey(),
                    backgroundColor: null,
                    progressColor: null,
                  ),
                ],
              ),
            );
            break;
          // case temperature:
          // case humidity:
          // case pm25:
          // case hcho:
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
                // color: Colors.white,
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
      show_failed("MqttNoConnectionException:$e", context);
      client.disconnect();
    } on SocketException catch (e) {
      show_failed("SocketException:$e", context);
      client.disconnect();
    }
    //QoS
    client.subscribe(topic_sensor, MqttQos.atMostOnce);
    client.subscribe(topic_set, MqttQos.atMostOnce);

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

  _changeStatus(String name, int value) async {
    final builder = MqttPayloadBuilder();
    builder
        .addString('{"mac":"${widget.device.info!["mac"]}","$name":${value}}');
    client.publishMessage(topic_set, MqttQos.atLeastOnce, builder.payload!);
  }

  //mqtt的调用函数
  /// The subscribed callback
  void onSubscribed(MqttSubscription subscription) {
    show_success("onSubscribed:${subscription.topic}", context);
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    show_failed("onDisconnected",context);
  }

  /// The successful connect callback
  void onConnected() {
    show_success(
        'EXAMPLE::OnConnected client callback - Client connection was successful', context);
  }

  /// Pong callback
  void pong() {
    show_success('EXAMPLE::Ping response client callback invoked',context);
  }

  void onAutoReconnect() {
    show_success('重连mqtt...', context);
  }

  void onAutoReconnected() {
    show_success('重连mqtt服务器成功！', context);
  }
}
