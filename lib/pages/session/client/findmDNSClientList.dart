import 'package:flutter/material.dart';
import 'package:modules/constants/Config.dart';
import 'package:modules/constants/Constants.dart';
import 'package:modules/model/portService.dart';
import 'package:modules/pages/mdnsService/components.dart';
import 'package:modules/pages/mdnsService/mdnsType2ModelMap.dart';

import 'package:mdns_plugin/mdns_plugin.dart' as mdns_plugin;

class FindmDNSClientListPage extends StatefulWidget {
  FindmDNSClientListPage({Key key}) : super(key: key);

  @override
  _FindmDNSClientListPageState createState() => _FindmDNSClientListPageState();
}

class _FindmDNSClientListPageState extends State<FindmDNSClientListPage>
    implements mdns_plugin.MDNSPluginDelegate {
  static const double IMAGE_ICON_WIDTH = 30.0;

  List<PortService> _ServiceList = [];
  mdns_plugin.MDNSPlugin _mdns;

  @override
  void initState() {
    super.initState();
    _mdns = mdns_plugin.MDNSPlugin(this);
    _findClientListBymDNS();
  }

  @override
  void dispose() {
    super.dispose();
    _mdns.stopDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceList.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.devices),
              ),
              Expanded(
                  child: Text(
                '${pair.ip}:${pair.port}',
                style: Constants.titleTextStyle,
              )),
              Constants.rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            //直接打开内置web浏览器浏览页面
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//              return Text("${pair.iP}:${pair.port}");
              return Gateway(serviceInfo: pair);
            }));
          },
          child: listItemContent,
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("发现本地网关列表"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _findClientListBymDNS();
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  void _findClientListBymDNS() async {
    _ServiceList.clear();
    _mdns.startDiscovery(Config.mdnsGatewayService, enableUpdating: true);
  }

  void onDiscoveryStarted() {
    print("Discovery started");
  }

  void onDiscoveryStopped() {
    print("Discovery stopped");
  }

  bool onServiceFound(mdns_plugin.MDNSService service) {
    print("Found: $service");
    // Always returns true which begins service resolution
    return true;
  }

  void onServiceResolved(mdns_plugin.MDNSService service) {
    print("Resolved: $service");
    try {
      print("service.serviceType:${service.serviceType}");
      PortService portService =
          MDNS2ModelsMap.modelsMap[Config.mdnsGatewayService];
      if (service.addresses != null && service.addresses.length > 0) {
        portService.ip = service.addresses[0];
      } else {
        portService.ip = service.hostName;
      }
      portService.port = service.port;
      portService.info["id"] = "${portService.ip}:${portService.port}@local";
      portService.isLocal = true;
      setState(() {
        _ServiceList.add(portService);
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text("从本地获取网关列表失败："),
                  content: Text("失败原因：$e"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("确认"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }

  void onServiceUpdated(mdns_plugin.MDNSService service) {
    print("Updated: $service");
  }

  void onServiceRemoved(mdns_plugin.MDNSService service) {
    print("Removed: $service");
  }
}
