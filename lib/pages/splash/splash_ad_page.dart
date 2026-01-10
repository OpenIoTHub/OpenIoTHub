import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub/pages/home/all/home_page.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

class SplashAdPage extends StatefulWidget {
  const SplashAdPage({super.key});

  @override
  State<StatefulWidget> createState() => SplashAdPageState();
}

class SplashAdPageState extends State<SplashAdPage> {
  final String launchImage = "assets/images/splash/1.jpg";
  int _countdown = 2;
  late Timer _countdownTimer;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.initState();
    _startRecordTime();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    print('启动页面结束');
    if (_countdownTimer.isActive) {
      _countdownTimer.cancel();
    }
  }

  void _startRecordTime() {
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (_countdown <= 1) {
//          Navigator.of(context).pushNamed("/demo1");
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MyHomePage(
              key: UniqueKey(),
              title: '',
            );
          }));
          _countdownTimer.cancel();
        } else {
          setState(() {
            _countdown -= 1;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO 等待加载完成就切换到列表页或者等到超时；加载网络图片或者广告
    // if (initList != null) {
    //   if (_countdownTimer.isActive){
    //     _countdownTimer.cancel();
    //   }
    //   print("initList != null");
    //   print(initList.toString());
    //   return SplashPage();
    // }
    return Scaffold(
      extendBody: true, //底部NavigationBar透明
      extendBodyBehindAppBar: true, //顶部Bar透明
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(child: Image.asset(launchImage, fit: BoxFit.fill)),
          Positioned(
            top: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                _countdown = 1;
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                child: RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: '$_countdown',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        )),
                    TextSpan(
                      text: OpenIoTHubLocalizations.of(context).skip_ad,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
