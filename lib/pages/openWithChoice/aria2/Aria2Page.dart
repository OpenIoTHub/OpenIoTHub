import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// 登录页面，使用网页加载的开源中国三方登录页面
class Aria2Page extends StatefulWidget {
  Aria2Page({Key key, this.runId, this.remoteIp, this.remotePort}) : super(key: key);
  String runId;
  String remoteIp;
  int remotePort;

  @override
  State<StatefulWidget> createState() => Aria2PageState();
}

class Aria2PageState extends State<Aria2Page> {
  // 标记是否是加载中
  bool loading = true;
  // 标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // URL变化监听器
  StreamSubscription<String> _onUrlChanged;
  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    // 监听WebView的加载事件，该监听器已不起作用，不回调
    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      // state.type是一个枚举类型，取值有：WebViewState.shouldStart, WebViewState.startLoad, WebViewState.finishLoad
      switch (state.type) {
        case WebViewState.shouldStart:
        // 准备加载
          setState(() {
            loading = true;
          });
          break;
        case WebViewState.startLoad:
        // 开始加载
          break;
        case WebViewState.finishLoad:
        // 加载完成
          setState(() {
            loading = false;
          });
          if (isLoadingCallbackPage) {
            // 当前是回调页面，则调用js方法获取数据
            parseResult();
          }
          break;
        case WebViewState.abortLoad:
          break;
      }
    });
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((url) {
      // 登录成功会跳转到自定义的回调页面，该页面地址为http://yubo725.top/osc/osc.php?code=xxx
      // 该页面会接收code，然后根据code换取AccessToken，并将获取到的token及其他信息，通过js的get()方法返回
      if (url != null && url.length > 0 && url.contains("osc/osc.php?code=")) {
        isLoadingCallbackPage = true;
      }
    });
  }

  // 解析WebView中的数据
  void parseResult() {
    flutterWebViewPlugin.evalJavascript("get();").then((result) {
      // result json字符串，包含token信息
      if (result != null && result.length > 0) {
        // 拿到了js中的数据
        try {
          // what the fuck?? need twice decode??
          var map = json.decode(result); // s is String
          if (map is String) {
            map = json.decode(map); // map is Map
          }
          if (map != null) {
            // 登录成功，取到了token，关闭当前页面
            Navigator.pop(context, "refresh");
          }
        } catch (e) {
          print("parse login result error: $e");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: _scaffoldKey,
      url: "http://127.0.0.1:9000/web/open/aria2/index.html", // 登录的URL
      withZoom: true,  // 允许网页缩放
      withLocalStorage: true, // 允许LocalStorage
      withJavascript: true, // 允许执行js代码
    );
  }

  @override
  void dispose() {
    // 回收相关资源
    // Every listener should be canceled, the same should be done with this stream.
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();

    super.dispose();
  }
}
