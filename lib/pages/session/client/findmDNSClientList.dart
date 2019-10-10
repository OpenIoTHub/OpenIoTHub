import 'package:flutter/material.dart';
import 'package:nat_explorer/api/Utils.dart';
import './setClient.dart';
import 'package:nat_explorer/pb/service.pb.dart';
import 'package:nat_explorer/pb/service.pbgrpc.dart';

const String discovery_service = "_nat-cloud-client._tcp";

class FindmDNSClientListPage extends StatefulWidget {
  FindmDNSClientListPage({Key key}) : super(key: key);

  @override
  _FindmDNSClientListPageState createState() => _FindmDNSClientListPageState();
}

class _FindmDNSClientListPageState extends State<FindmDNSClientListPage> {
  final _biggerFont = const TextStyle(fontSize: 16.0);
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;
  final rightArrowIcon = Image.asset(
    'assets/images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  List<MDNSService> _ServiceList = [];

  @override
  void initState() {
    super.initState();
    _findClientListBymDNS();
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
                '${pair.name}@${pair.iP}:${pair.port}',
                style: _biggerFont,
              )),
              rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            //直接打开内置web浏览器浏览页面
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//              return Text("${pair.iP}:${pair.port}");
              return SetClient(ip: pair.iP, port: pair.port);
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
        title: Text("内网端列表"),
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
    MDNSService config = MDNSService();
//    config.name = '_nat-cloud-client._tcp';
    config.name = discovery_service;
    UtilApi.getAllmDNSServiceList(config).then((v) {
      setState(() {
        _ServiceList = v.mDNSServices;
      });
    });
  }
}
