import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nat_explorer/constants/Config.dart';

class Aria2Page extends StatefulWidget {
  Aria2Page({Key key, this.localPort}) : super(key: key);
  int localPort;

  @override
  State<StatefulWidget> createState() => Aria2PageState();
}

class Aria2PageState extends State<Aria2Page> {
  // 标记是否是加载中
  bool loaded = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    // 监听WebView的加载事件，该监听器已不起作用，不回调
    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      // state.type是一个枚举类型，取值有：WebViewState.shouldStart, WebViewState.startLoad, WebViewState.finishLoad
      switch (state.type) {
        case WebViewState.shouldStart:
          // 准备加载
          break;
        case WebViewState.startLoad:
          // 开始加载
          injectConfig();
          break;
        case WebViewState.finishLoad:
          // 加载完成
          break;
        case WebViewState.abortLoad:
          break;
      }
    });
  }

  // 解析WebView中的数据
  void injectConfig() {
    if (loaded) {
      return;
    }
    loaded = true;
    print("===");
    String jsCode =
        "window.localStorage.setItem(\'AriaNg.Options\', \'{\"language\":\"zh_Hans\",\"title\":\"\${downspeed}, \${upspeed} - \${title}\",\"titleRefreshInterval\":5000,\"browserNotification\":false,\"rpcAlias\":\"\",\"rpcHost\":\"localhost\",\"rpcPort\":\"${widget.localPort}\",\"rpcInterface\":\"jsonrpc\",\"protocol\":\"http\",\"httpMethod\":\"POST\",\"secret\":\"\",\"extendRpcServers\":[],\"globalStatRefreshInterval\":1000,\"downloadTaskRefreshInterval\":1000,\"rpcListDisplayOrder\":\"recentlyUsed\",\"afterCreatingNewTask\":\"task-list\",\"removeOldTaskAfterRetrying\":false,\"afterRetryingTask\":\"task-list-downloading\",\"displayOrder\":\"default:asc\",\"fileListDisplayOrder\":\"default:asc\",\"peerListDisplayOrder\":\"default:asc\"}\');location.reload();";
    flutterWebViewPlugin.evalJavascript(jsCode).then((result) {
      // result json字符串，包含token信息
      print("===");
      print(result);
      print("===");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: _scaffoldKey,
      url:
          "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/aria2/index.html", // 登录的URL
      withZoom: true, // 允许网页缩放
      withLocalStorage: true, // 允许LocalStorage
      withJavascript: true, // 允许执行js代码
    );
  }

  @override
  void dispose() {
    // 回收相关资源
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();

    super.dispose();
  }
}
