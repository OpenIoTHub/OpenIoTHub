import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/commonPages/scanQR.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../pages/guide/guidePage.dart';
import '../util/check/check.dart';

List<Widget>? build_actions(BuildContext context) {
  var popupMenuEntrys = <PopupMenuEntry<String>>[
    PopupMenuItem(
      //child: _buildPopupMenuItem(Icons.camera_alt, '扫一扫'),
      child: _buildPopupMenuItem(TDIcons.search,
          OpenIoTHubLocalizations.of(context).find_local_gateway),
      value: "find_local_gateway",
    ),
  ];
  if (Platform.isAndroid || Platform.isIOS) {
    popupMenuEntrys.addAll(<PopupMenuEntry<String>>[
      const PopupMenuDivider(
        height: 0.2,
      ),
      PopupMenuItem(
        //child: _buildPopupMenuItem(Icons.camera_alt, '扫一扫'),
        child: _buildPopupMenuItem(
            TDIcons.scan, OpenIoTHubLocalizations.of(context).scan_QR),
        value: "scan_QR",
      ),
      const PopupMenuDivider(
        height: 0.2,
      ),
      PopupMenuItem(
        //child: _buildPopupMenuItem(ICons.ADDRESS_BOOK_CHECKED, '添加朋友'),
        child: _buildPopupMenuItem(TDIcons.wifi,
            OpenIoTHubLocalizations.of(context).config_device_wifi),
        value: "config_device_wifi",
      ),
    ]);
  }
  popupMenuEntrys.addAll(<PopupMenuEntry<String>>[
    const PopupMenuDivider(
      height: 0.2,
    ),
    PopupMenuItem(
      //child: _buildPopupMenuItem(Icons.camera_alt, '扫一扫'),
      child: _buildPopupMenuItem(
          TDIcons.info_circle, OpenIoTHubLocalizations.of(context).user_guide),
      value: "user_guide",
    ),
  ]);
  return <Widget>[
    PopupMenuButton(
      tooltip: "",
      itemBuilder: (BuildContext context) {
        return popupMenuEntrys;
      },
      padding: EdgeInsets.only(top: 0.0),
      elevation: 5.0,
      icon: const Icon(Icons.add_circle_outline),
      onSelected: (String selected) async {
        switch (selected) {
          case 'config_device_wifi':
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Airkiss(
                    title:
                        OpenIoTHubLocalizations.of(context).config_device_wifi,
                    key: UniqueKey(),
                  );
                },
              ),
            );
            break;
          case 'scan_QR':
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (prefs.containsKey("scan_QR_Dialog") &&
                prefs.getBool("scan_QR_Dialog")!) {
              if (await userSignedIn()) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ScanQRPage(
                        key: UniqueKey(),
                      );
                    },
                  ),
                );
              }else{
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginPage()));
              }
            } else {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                          title: Text(OpenIoTHubLocalizations.of(context)
                              .camera_scan_code_prompt),
                          scrollable: true,
                          content: SizedBox(
                              height: 120,
                              child: ListView(
                                children: <Widget>[
                                  Text(
                                    OpenIoTHubLocalizations.of(context)
                                        .camera_scan_code_prompt_content,
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              )),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                  OpenIoTHubLocalizations.of(context).cancel,
                                  style: TextStyle(color: Colors.grey)),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                OpenIoTHubLocalizations.of(context).confirm,
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () async {
                                prefs.setBool("scan_QR_Dialog", true);
                                if (await userSignedIn()) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ScanQRPage(
                                          key: UniqueKey(),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                                }
                              },
                            ),
                          ]));
            }
            break;
          case 'find_local_gateway':
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  // 写成独立的组件，支持刷新
                  return FindGatewayGoListPage(
                    key: UniqueKey(),
                  );
                },
              ),
            );
            break;
          case 'user_guide':
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  // 写成独立的组件，支持刷新
                  return GuidePage(activeIndex: 0,);
                },
              ),
            );
            break;
        }
      },
    ),
  ];
}

_buildPopupMenuItem(IconData icon, String title) {
  return Row(children: <Widget>[
    Icon(
      icon,
      // color: Colors.white,
    ),
    //Image.asset(CommonUtils.getBaseIconUrlPng("main_top_add_friends"), width: 18, height: 18,),

    Container(width: 12.0),
    Text(
      title,
      // style: TextStyle(color: Color(0xFFFFFFFF)),
    )
  ]);
}
