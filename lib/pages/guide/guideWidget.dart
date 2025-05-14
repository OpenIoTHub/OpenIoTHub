import 'package:flutter/material.dart';
import 'package:openiothub/pages/commonPages/scanQR.dart';
import 'package:openiothub_common_pages/commPages/findGatewayGoList.dart';
import 'package:openiothub_common_pages/user/LoginPage.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../l10n/generated/openiothub_localizations.dart';
import '../commonDevice/commonDeviceListPage.dart';

class GuideWidget extends StatefulWidget {
  const GuideWidget({super.key});

  @override
  State<GuideWidget> createState() => _GuideWidgetState();
}

class _GuideWidgetState extends State<GuideWidget> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: _buildVBasicSteps(context),
    // );
    return _buildVBasicSteps(context);
  }

  Widget _buildVBasicSteps(BuildContext context) {
    var steps = [
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).register_login,
        successIcon: TDIcons.user,
      ),
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).add_gateway,
        successIcon: TDIcons.internet,
      ),
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).add_host,
        successIcon: TDIcons.desktop,
      ),
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).add_ports,
        successIcon: TDIcons.add,
      ),
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).access_ports,
        successIcon: TDIcons.accessibility,
      ),
    ];
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TDSteps(
                    steps: steps,
                    direction: TDStepsDirection.horizontal,
                    activeIndex: activeIndex,
                  ),
                )
              ],
            ),
            _buildGuideByIndex(activeIndex),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        if (activeIndex - 1 >= 0) {
                          setState(() {
                            activeIndex -= 1;
                          });
                        }
                      },
                      child:
                          Text(OpenIoTHubLocalizations.of(context).last_step)),
                  TextButton(
                      onPressed: () {
                        if (activeIndex + 1 <= steps.length - 1) {
                          setState(() {
                            activeIndex += 1;
                          });
                        }
                      },
                      child:
                          Text(OpenIoTHubLocalizations.of(context).next_step))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      OpenIoTHubLocalizations.of(context).skip_this_guide, style: TextStyle(color: Colors.grey, fontSize: 8),)),
            )
          ],
        ));
  }

  Widget _buildGuideByIndex(int index) {
    switch (index) {
      case 0:
        return _buildRegisterLoginGuide();
      case 1:
        return _buildGatewayGuide();
      case 2:
        return _buildHostGuide();
      case 3:
        return _buildPortGuide();
      case 4:
        return _buildOpenPortGuide();
      default:
        return _buildRegisterLoginGuide();
    }
  }

  Widget _buildRegisterLoginGuide() {
    return Column(children: [
      Center(
        child: Text(OpenIoTHubLocalizations.of(context).register_login_content, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: TextButton(
            style: ButtonStyle(
              side: WidgetStateProperty.all(
                  const BorderSide(color: Colors.grey, width: 1)),
              shape: WidgetStateProperty.all(const StadiumBorder()),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(OpenIoTHubLocalizations.of(context).register_login)),
      ),
    ]);
  }

  Widget _buildGatewayGuide() {
    return Column(children: [
      // ThemeUtils.isDarkMode(context)
      //     ? Center(
      //         child: Image.asset('assets/images/empty_list_black.png'),
      //       )
      //     : Center(
      //         child: Image.asset('assets/images/empty_list.png'),
      //       ),
      Padding(
          padding: EdgeInsets.only(top: 16),
          child: Center(
            child:
                Text(OpenIoTHubLocalizations.of(context).add_gateway_content, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          )),
      Padding(
          padding: EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                        const BorderSide(color: Colors.grey, width: 1)),
                    shape: WidgetStateProperty.all(const StadiumBorder()),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ScanQRPage()));
                  },
                  child: Text(OpenIoTHubLocalizations.of(context).scan_QR)),
              TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                        const BorderSide(color: Colors.grey, width: 1)),
                    shape: WidgetStateProperty.all(const StadiumBorder()),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FindGatewayGoListPage()));
                  },
                  child: Text(
                      OpenIoTHubLocalizations.of(context).find_local_gateway))
            ],
          ))
    ]);
  }

  Widget _buildHostGuide() {
    return Column(children: [
      // ThemeUtils.isDarkMode(context)
      //     ? Center(
      //         child: Image.asset('assets/images/empty_list_black.png'),
      //       )
      //     : Center(
      //         child: Image.asset('assets/images/empty_list.png'),
      //       ),
      Padding(
          padding: EdgeInsets.only(top: 16),
          child: Center(
            child: Text(OpenIoTHubLocalizations.of(context).add_host_content, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          )),
      Padding(
          padding: EdgeInsets.only(top: 16),
          child: TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.grey, width: 1)),
                shape: WidgetStateProperty.all(const StadiumBorder()),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommonDeviceListPage(
                          key: UniqueKey(),
                          title: '',
                        )));
              },
              child: Text(OpenIoTHubLocalizations.of(context).add_remote_host)))
    ]);
  }

  Widget _buildPortGuide() {
    return Column(children: [
      // ThemeUtils.isDarkMode(context)
      //     ? Center(
      //         child: Image.asset('assets/images/empty_list_black.png'),
      //       )
      //     : Center(
      //         child: Image.asset('assets/images/empty_list.png'),
      //       ),
      Padding(
          padding: EdgeInsets.only(top: 16),
          child: Center(
            child: Text(OpenIoTHubLocalizations.of(context).add_ports_content, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          )),
      Padding(
          padding: EdgeInsets.only(top: 16),
          child: TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.grey, width: 1)),
                shape: WidgetStateProperty.all(const StadiumBorder()),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommonDeviceListPage(
                          key: UniqueKey(),
                          title: '',
                        )));
              },
              child: Text(OpenIoTHubLocalizations.of(context).add_port_button)))
    ]);
  }

  Widget _buildOpenPortGuide() {
    return Column(children: [
      // ThemeUtils.isDarkMode(context)
      //     ? Center(
      //         child: Image.asset('assets/images/empty_list_black.png'),
      //       )
      //     : Center(
      //         child: Image.asset('assets/images/empty_list.png'),
      //       ),
      Padding(
          padding: EdgeInsets.only(top: 16),
          child: Center(
            child:
                Text(OpenIoTHubLocalizations.of(context).access_ports_content, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          )),
      Padding(
          padding: EdgeInsets.only(top: 16),
          child: TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.grey, width: 1)),
                shape: WidgetStateProperty.all(const StadiumBorder()),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommonDeviceListPage(
                          key: UniqueKey(),
                          title: '',
                        )));
              },
              child: Text(OpenIoTHubLocalizations.of(context).open_the_port)))
    ]);
  }
}
