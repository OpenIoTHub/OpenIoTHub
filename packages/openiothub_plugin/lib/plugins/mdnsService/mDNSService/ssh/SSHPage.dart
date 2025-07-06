import 'dart:async';
import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:xterm/xterm.dart';

import '../../../../l10n/generated/openiothub_plugin_localizations.dart';
import '../../../../models/PortServiceInfo.dart';
import './virtual_keyboard.dart';

class SSHNativePage extends StatefulWidget {
  SSHNativePage({required Key key, required this.device}) : super(key: key);
  static final String modelName = "com.iotserv.services.ssh.server";
  final PortServiceInfo device;

  @override
  State<StatefulWidget> createState() => SSHNativePageState();
}

class SSHNativePageState extends State<SSHNativePage> {
  late final terminal = Terminal(inputHandler: keyboard);

  final keyboard = VirtualKeyboard(defaultInputHandler);

  var title = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      initTerminal();
    });
  }

  Future<void> initTerminal() async {
    setState(() => this.title =
        "${widget.device.addr}:${widget.device.port}@${widget.device.runId}");
    terminal.write('Connecting...\r\n');
    TextEditingController usernameController =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    TextEditingController passwordController =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return TDAlertDialog(
          title: OpenIoTHubPluginLocalizations.of(context)
              .please_input_ssh_username_password,
          contentWidget: Column(children: <Widget>[
            TDInput(
              leftLabel: OpenIoTHubPluginLocalizations.of(context).username,
              leftLabelSpace: 0,
              hintText: "",
              backgroundColor: Colors.white,
              textAlign: TextAlign.left,
              showBottomDivider: true,
              controller: usernameController,
              inputType: TextInputType.text,
              maxLines: 1,
              needClear: true,
            ),
            TDInput(
              leftLabel: OpenIoTHubPluginLocalizations.of(context).password,
              leftLabelSpace: 0,
              hintText: "",
              backgroundColor: Colors.white,
              textAlign: TextAlign.left,
              showBottomDivider: true,
              controller: passwordController,
              inputType: TextInputType.text,
              maxLines: 1,
              needClear: true,
              obscureText: true,
            )
            // 是否自动添加网关主机
          ]),
          titleColor: Colors.black,
          contentColor: Colors.redAccent,
          // backgroundColor: AppTheme.blockBgColor,
          leftBtn: TDDialogButtonOptions(
            title: OpenIoTHubPluginLocalizations.of(context).cancel,
            // titleColor: AppTheme.color999,
            style: TDButtonStyle(
              backgroundColor: Colors.grey,
            ),
            action: () {
              Navigator.of(context).pop();
            },
          ),
          rightBtn: TDDialogButtonOptions(
            title: OpenIoTHubPluginLocalizations.of(context).ok,
            style: TDButtonStyle(
              backgroundColor: Colors.blue,
            ),
            action: () {
              Navigator.of(context).pop();
              // 弹窗获取用户名密码
              _connect_ssh(
                  username: usernameController.text,
                  password: passwordController.text);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        backgroundColor: CupertinoTheme.of(context)
            .barBackgroundColor
            .withAlpha((255.0 * 0.5).round()),
      ),
      child: Column(
        children: [
          Expanded(
            child: TerminalView(terminal),
          ),
          VirtualKeyboardView(keyboard),
        ],
      ),
    );
  }

  _connect_ssh({required String username, password}) async {
    final client = SSHClient(
      await SSHSocket.connect(widget.device.addr, widget.device.port),
      username: username,
      // onUserInfoRequest: null,
      onPasswordRequest: () => password,
    );

    terminal.write('Connected\r\n');

    final session = await client.shell(
      pty: SSHPtyConfig(
        width: terminal.viewWidth,
        height: terminal.viewHeight,
      ),
    );

    terminal.buffer.clear();
    terminal.buffer.setCursor(0, 0);

    terminal.onTitleChange = (title) {
      setState(() => this.title = title);
    };

    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      session.resizeTerminal(width, height, pixelWidth, pixelHeight);
    };

    terminal.onOutput = (data) {
      session.write(utf8.encode(data));
    };

    session.stdout
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);

    session.stderr
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);
  }
}
