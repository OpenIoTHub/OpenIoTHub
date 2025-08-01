import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_plugin/utils/toast.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'widgets/indicator.dart';

class SystemInfoPage extends StatefulWidget {
  const SystemInfoPage(
      {super.key, required this.baseUrl, required this.data});

  final String baseUrl;
  final Map<String, dynamic> data;

  @override
  State<SystemInfoPage> createState() => _SystemInfoPageState();
}

class _SystemInfoPageState extends State<SystemInfoPage> {
  bool usb_auto_mount = true;
  Map<String, dynamic> utilization = {};
  int touchedIndex = -1;
  late Timer _refresh_timer;

  @override
  void dispose() {
    if (_refresh_timer.isActive) {
      _refresh_timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    getUtilization();
    _refresh_timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      getUtilization();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listView = <Widget>[
      // CPU 饼状图
      AspectRatio(
        aspectRatio: 1.3,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingCpuSections(),
                  ),
                ),
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.red,
                  text: 'UsedCPU',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.green,
                  text: 'UnusedCPU',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
      Divider(),
      // 内存 饼状图
      AspectRatio(
        aspectRatio: 1.3,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingMemSections(),
                  ),
                ),
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.red,
                  text: 'UsedMem',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.green,
                  text: 'UnusedMem',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
      Divider(),
      // 硬盘 饼状图
      AspectRatio(
        aspectRatio: 1.3,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingDiskSections(),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.red,
                  text: 'UsedDisk',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.green,
                  text: 'UnusedDisk',
                  isSquare: true,
                ),
                Indicator(
                  color: (utilization["sys_disk"] == null ||
                          utilization["sys_disk"]["health"])
                      ? Colors.greenAccent
                      : Colors.orangeAccent,
                  text: (utilization["sys_disk"] == null ||
                          utilization["sys_disk"]["health"])
                      ? 'Health'
                      : "Unhealthy",
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
      Divider()
      // TODO 网络 折线图

      // TODO USB
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text("System Info"),
          // actions: [Text("")],
        ),
        body: utilization.isEmpty
            ? TDLoading(
                size: TDLoadingSize.small,
                icon: TDLoadingIcon.activity,
              )
            : Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: ListView(
                    children: listView,
                  ),
                ),
              ));
  }

  Future<void> getUtilization() async {
    final dio = Dio(BaseOptions(
        baseUrl: widget.baseUrl,
        headers: {
          "Authorization": widget.data["data"]["token"]["access_token"]
        }));
    String reqUri = "/v1/sys/utilization";
    try {
      final response = await dio.getUri(Uri.parse(reqUri));
      if (response.data["success"] == 200) {
        setState(() {
          utilization = response.data["data"];
        });
      }
    } catch (e) {
      show_failed(e.toString(), context);
    }
  }

  List<PieChartSectionData>? showingCpuSections() {
    if (utilization.isEmpty) {
      return null;
    }
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: utilization["cpu"]["percent"].toDouble(),
            title: '${utilization["cpu"]["percent"].toDouble()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: (100 - utilization["cpu"]["percent"]).toDouble(),
            title: '${(100 - utilization["cpu"]["percent"]).toDouble()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData>? showingMemSections() {
    if (utilization.isEmpty) {
      return null;
    }
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: utilization["mem"]["usedPercent"].toDouble(),
            title:
                '${utilization["mem"]["usedPercent"].toDouble().toStringAsFixed(1)}% (${(utilization["mem"]["used"] / 1024 / 1024 / 1024).toDouble().toStringAsFixed(1)} GB)',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value:
                (100 - utilization["mem"]["usedPercent"].toDouble()).toDouble(),
            title:
                '${(100 - utilization["mem"]["usedPercent"].toDouble()).toDouble().toStringAsFixed(1)}% (${((utilization["mem"]["total"] - utilization["mem"]["used"]) / 1024 / 1024 / 1024).toDouble().toStringAsFixed(1)} GB)',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData>? showingDiskSections() {
    if (utilization.isEmpty) {
      return null;
    }
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: ((utilization["sys_disk"]["size"] -
                        utilization["sys_disk"]["avail"]) /
                    utilization["sys_disk"]["size"])
                .toDouble(),
            title:
                '${(((utilization["sys_disk"]["size"] - utilization["sys_disk"]["avail"]) / utilization["sys_disk"]["size"]).toDouble() * 100).toStringAsFixed(1)}% (${((utilization["sys_disk"]["size"] - utilization["sys_disk"]["avail"]) / 1024 / 1024 / 1024).toDouble().toStringAsFixed(1)}GB)',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: (utilization["sys_disk"]["avail"] /
                    utilization["sys_disk"]["size"])
                .toDouble(),
            title:
                '${((utilization["sys_disk"]["avail"] / utilization["sys_disk"]["size"]).toDouble() * 100).toStringAsFixed(1)}% (${(utilization["sys_disk"]["avail"] / 1024 / 1024 / 1024).toDouble().toStringAsFixed(1)}GB)',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
//{
//     "success": 200,
//     "message": "ok",
//     "data": {
//         "cpu": {
//             "model": "intel",
//             "num": 2,
//             "percent": 1.8,
//             "power": {
//                 "timestamp": "1744540165",
//                 "value": "0"
//             },
//             "temperature": 0
//         },
//         "mem": {
//             "available": 1757048832,
//             "free": 766914560,
//             "total": 3111690240,
//             "used": 1165348864,
//             "usedPercent": 37.5
//         },
//         "net": [
//             {
//                 "name": "ens3",
//                 "bytesSent": 5638011,
//                 "bytesRecv": 1909751,
//                 "packetsSent": 5931,
//                 "packetsRecv": 9175,
//                 "errin": 0,
//                 "errout": 0,
//                 "dropin": 1,
//                 "dropout": 0,
//                 "fifoin": 0,
//                 "fifoout": 0,
//                 "state": "up",
//                 "time": 1744540165
//             }
//         ],
//         "sys_disk": {
//             "avail": 185420419072,
//             "health": true,
//             "size": 209129086976,
//             "used": 13010939904
//         },
//         "sys_usb": []
//     }
// }
