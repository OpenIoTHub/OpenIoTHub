//Serial315433:https://github.com/iotdevice/UART2TCP
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';

import '../../../../models/PortServiceInfo.dart';

class UART2TCPPage extends StatefulWidget {
  UART2TCPPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.UART2TCP";
  final PortServiceInfo device;

  @override
  State createState() => UART2TCPStatus();
}

class UART2TCPStatus extends State<UART2TCPPage> with TickerProviderStateMixin {
  late Socket uartSockt;
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = TextEditingController();
  bool _isWriting = false;

  @override
  Future initState() async {
    uartSockt = await Socket.connect(widget.device.addr, widget.device.port);
    uartSockt.listen((Uint8List msg) {
      _submitMsg(false, utf8.decode(msg));
    }, cancelOnError: true);
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
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
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
          reverse: true,
          padding: EdgeInsets.all(6.0),
        )),
        Divider(height: 1.0),
        Container(
          child: _buildComposer(),
          decoration: BoxDecoration(color: Theme.of(ctx).cardColor),
        ),
      ]),
    );
  }

  Widget _buildComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String txt) {
                  setState(() {
                    _isWriting = txt.length > 0;
                  });
                },
                onSubmitted: (String msg) => _submitMsg(true, msg),
                decoration: InputDecoration.collapsed(
                    hintText: OpenIoTHubPluginLocalizations.of(context)
                        .please_input_message),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isWriting
                      ? () => _submitMsg(true, _textController.text)
                      : null,
                )),
          ],
        ),
      ),
    );
  }

  void _submitMsg(bool me, String txt) {
    if (me) {
      uartSockt.write(txt);
    }
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = Msg(
//    用户自己发送的为true，否则false
      me: me,
      txt: txt,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 800)),
    );
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    uartSockt.close();
    super.dispose();
  }

  _info() async {
    // TODO 设备信息
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
}

class Msg extends StatelessWidget {
  Msg({required this.me, required this.txt, required this.animationController});

  bool me = true;
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: me
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 6.0),
                          child: Text(txt),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 18.0),
                    child: CircleAvatar(
                        child: Text(me
                            ? OpenIoTHubPluginLocalizations.of(ctx).me
                            : OpenIoTHubPluginLocalizations.of(ctx)
                                .serial_port)),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 18.0),
                    child: CircleAvatar(
                        child: Text(me
                            ? OpenIoTHubPluginLocalizations.of(ctx).me
                            : OpenIoTHubPluginLocalizations.of(ctx)
                                .serial_port)),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 6.0),
                          child: Text(txt),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
