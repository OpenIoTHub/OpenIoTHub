import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nat_explorer/api/SessionApi.dart';
import 'package:nat_explorer/pb/service.pb.dart';

class SetClient extends StatefulWidget {
  SetClient({Key key, this.ip, this.port}) : super(key: key);

  String ip;
  int port;

  @override
  createState() => SetClientState();
}

class SetClientState extends State<SetClient> {
  TextEditingController _host_controller = TextEditingController.fromValue(
      TextEditingValue(text: "guonei.nat-cloud.com"));
  TextEditingController _tcp_port_controller =
      TextEditingController.fromValue(TextEditingValue(text: "34320"));
  TextEditingController _udp_p2p_controller =
      TextEditingController.fromValue(TextEditingValue(text: "34321"));
  TextEditingController _key_controller =
      TextEditingController.fromValue(TextEditingValue(text: "HLLdsa544&*S"));
  TextEditingController _runid_controller =
      TextEditingController.fromValue(TextEditingValue(text: ""));

  login() async {
    var url = 'http://${widget.ip}:${widget.port}/loginServer';
    var response;
    try {
      var config = {
        'last_id': _runid_controller.text,
        'server_host': _host_controller.text,
        'tcp_port': _tcp_port_controller.text,
        'udp_p2p_port': _udp_p2p_controller.text,
        'login_key': _key_controller.text
      };
      response = await http.post(url, body: config);
//    自动添加到我的列表
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Code'] == 0) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                      title: Text("登录结果"),
                      content: Text("登录成功！现在可以获取访问Token来访问本内网了！"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("取消"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("添加内网"),
                          onPressed: () {
                            addToMySessionList().then((_) {
                              Navigator.of(context).pop();
                            });
                          },
                        )
                      ]));
        } else {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                      title: Text("登录结果"),
                      content: Text("登录失败：" + data['Msg'].toString()),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("取消"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("添加内网"),
                          onPressed: () {
                            addToMySessionList().then((_) {
                              Navigator.of(context).pop();
                            });
                          },
                        )
                      ]));
        }
      }
    } catch (exception) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("登录服务器错误"),
                  content: Text(exception.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  seeToken() async {
    var url = 'http://${widget.ip}:${widget.port}/getExplorerToken';
    var response;
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Code'] == 0) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                      title: Text("本内网访问Token"),
                      content: TextFormField(initialValue: data['Token']),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("取消"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("复制到剪切板"),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: data['Token']));
                            Navigator.of(context).pop();
                          },
                        )
                      ]));
        }
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("获取Token出现错误！"),
                  content: Text(e.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("云易连(网关)"),
        ),
        body: ListView(
          children: <Widget>[
            TextFormField(
              controller: _host_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器地址',
                helperText: '输入ip或者域名',
              ),
            ),
            TextFormField(
              controller: _tcp_port_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器TCP端口',
                helperText: '与服务器的设置一致：tcp_port',
              ),
            ),
            TextFormField(
              controller: _udp_p2p_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器udp_p2p端口',
                helperText: '请输入服务器设置一致：udp_p2p_port',
              ),
            ),
            TextFormField(
              controller: _key_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入服务器秘钥',
                helperText: '请输入服务器设置一致：login_key',
              ),
            ),
            TextFormField(
              controller: _runid_controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: '请输入本内网id',
                helperText: '可以随机输入一个UUID，可以留空随机生成',
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    child: Text("连接服务器"),
                    color: Colors.blue,
                    onPressed: () {
//                      从用户的填写中获取参数请求后端连接服务器
                      login();
                    },
                  ),
                  margin: EdgeInsets.all(10.0),
                ),
                RaisedButton(
                    child: Text("查看Token"),
                    color: Colors.green,
                    onPressed: () {
                      seeToken();
                    })
              ],
            )
          ],
        ));
  }

  Future addToMySessionList() async {
    var url = 'http://${widget.ip}:${widget.port}/getExplorerToken';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['Code'] == 0) {
        SessionConfig config = SessionConfig();
        config.token = data['Token'];
        config.description = '我的网络';
        createOneSession(config);
      }
    }
  }

  Future createOneSession(SessionConfig config) async {
    try {
      final response = await SessionApi.createOneSession(config);
      print('Greeter client received: ${response}');
    } catch (e) {
      print('Caught error: $e');
    }
  }
}
