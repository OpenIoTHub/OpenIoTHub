//MqttPhicommzA1plug_:https://gitee.com/a2633063/zA1
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_seekbar/flutter_seekbar.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:openiothub/common_pages/utils/toast.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

import 'package:openiothub/plugin/models/port_service_info.dart';
import '../../../mdns_service/comm_widgets/info.dart';

class MqttPhicommzA1PluginPage extends StatefulWidget {
  const MqttPhicommzA1PluginPage({required Key key, required this.device})
      : super(key: key);
  static final String modelName = "com.iotserv.devices.mqtt.zA1";
  final PortServiceInfo device;

  @override
  State<MqttPhicommzA1PluginPage> createState() =>
      MqttPhicommzA1PluginPageState();
}

class MqttPhicommzA1PluginPageState extends State<MqttPhicommzA1PluginPage> {
  late MqttServerClient client;
  late String topicState;
  late String topicSet;

  //  总开关
  static const String on = "on";

  static const String speed = "speed";

  final List<String> _keyList = [on, speed];

  final Map<String, dynamic> _status = Map.from({
    on: 0,
    speed: 0,
  });

  final Map<String, String> _realName = Map.from({
    on: "开关",
    speed: "速度",
  });

  @override
  void initState() {
    super.initState();
    topicState = "device/za1/${widget.device.info!["mac"]}/state";
    topicSet = "device/za1/${widget.device.info!["mac"]}/set";
    _initMqtt();
    debugPrint("init iot device list");
  }

  @override
  void dispose() {
    client.unsubscribeStringTopic(topicState);
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List result = [];
    result.addAll(_keyList);
    final tiles = result.map(
      (pair) {
        switch (pair) {
          case on:
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
          default:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]!),
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
                      onValueChanged: (v) {
                        _changeProgressStatus(pair, v.value.toInt());
                      }),
                ],
              ),
            );
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
      if (!mounted) return;
      showFailed(
        '${OpenIoTHubLocalizations.of(context).mqtt_connection_failed}: $e',
        context,
      );
      client.disconnect();
    } on SocketException catch (e) {
      if (!mounted) return;
      showFailed(
        '${OpenIoTHubLocalizations.of(context).mqtt_socket_error}: $e',
        context,
      );
      client.disconnect();
    }
    //QoS
    client.subscribe(topicState, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      for (var element in c) {
        final recMess = element.payload as MqttPublishMessage;
        final pt =
            MqttUtilities.bytesToStringAsString(recMess.payload.message!);
        // Fluttertoast.showToast(
        //     msg:
        //         'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        //  通过获取的消息更新状态
        Map<String, dynamic> m = jsonDecode(pt);
        for (var key in _keyList) {
          if (m.containsKey(key)) {
            setState(() {
              _status[key] = m[key];
            });
          }
        }
      }
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
        '{"mac":"${widget.device.info!["mac"]}","$name":${value ? 1 : 0}}');
    client.publishMessage(topicSet, MqttQos.atLeastOnce, builder.payload!);
  }

  _changeProgressStatus(String name, int value) async {
    final builder = MqttPayloadBuilder();
    builder
        .addString('{"mac":"${widget.device.info!["mac"]}","$name":$value}');
    client.publishMessage(topicSet, MqttQos.atLeastOnce, builder.payload!);
  }

  //mqtt的调用函数
  /// The subscribed callback
  void onSubscribed(MqttSubscription subscription) {
    showSuccess(
      '${OpenIoTHubLocalizations.of(context).mqtt_subscribed}: ${subscription.topic}',
      context,
    );
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    showSuccess(
      OpenIoTHubLocalizations.of(context).mqtt_disconnected,
      context,
    );
  }

  /// The successful connect callback
  void onConnected() {
    showSuccess(
      OpenIoTHubLocalizations.of(context).mqtt_connected,
      context,
    );
  }

  /// Pong callback
  void pong() {
    showSuccess(
      OpenIoTHubLocalizations.of(context).mqtt_ping_received,
      context,
    );
  }

  void onAutoReconnect() {
    showSuccess(
      OpenIoTHubLocalizations.of(context).mqtt_reconnecting,
      context,
    );
  }

  void onAutoReconnected() {
    showSuccess(
      OpenIoTHubLocalizations.of(context).mqtt_reconnected_success,
      context,
    );
  }
}
