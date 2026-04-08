import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/common/openiothub_common_pages.dart';
import 'package:openiothub/plugins/openiothub_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub/router/core/app_routes.dart';
import 'package:openiothub/router/core/app_navigator.dart';
import 'package:openiothub/utils/app/check_auth.dart';

List<Widget>? buildActions(BuildContext context) {
  var popupMenuEntries = <PopupMenuEntry<String>>[
    PopupMenuItem(
      //child: _buildPopupMenuItem(Icons.camera_alt, '扫一扫'),
      child: _buildPopupMenuItem(
        TDIcons.search,
        OpenIoTHubLocalizations.of(context).find_local_gateway,
        context,
      ),
      value: "find_local_gateway",
    ),
  ];
  if (Platform.isAndroid || Platform.isIOS) {
    popupMenuEntries.addAll(<PopupMenuEntry<String>>[
      const PopupMenuDivider(height: 0.2),
      PopupMenuItem(
        //child: _buildPopupMenuItem(Icons.camera_alt, '扫一扫'),
        child: _buildPopupMenuItem(
          TDIcons.scan,
          OpenIoTHubLocalizations.of(context).scan_QR,
          context,
        ),
        value: "scan_QR",
      ),
      const PopupMenuDivider(height: 0.2),
      PopupMenuItem(
        //child: _buildPopupMenuItem(ICons.ADDRESS_BOOK_CHECKED, '添加朋友'),
        child: _buildPopupMenuItem(
          TDIcons.wifi,
          OpenIoTHubLocalizations.of(context).config_device_wifi,
          context,
        ),
        value: "config_device_wifi",
      ),
    ]);
  }
  popupMenuEntries.addAll(<PopupMenuEntry<String>>[
    const PopupMenuDivider(height: 0.2),
    PopupMenuItem(
      //child: _buildPopupMenuItem(Icons.camera_alt, '扫一扫'),
      child: _buildPopupMenuItem(
        TDIcons.info_circle,
        OpenIoTHubLocalizations.of(context).user_guide,
        context,
      ),
      value: "user_guide",
    ),
  ]);
  return <Widget>[
    PopupMenuButton(
      tooltip: OpenIoTHubLocalizations.of(context).tooltip_quick_actions,
      itemBuilder: (BuildContext context) {
        return popupMenuEntries;
      },
      padding: EdgeInsets.only(top: 0.0),
      elevation: 5.0,
      icon: const Icon(Icons.add_circle_outline),
      onSelected: (String selected) async {
        switch (selected) {
          case 'config_device_wifi':
            AppNavigator.pushAirkiss(
              context,
              title: OpenIoTHubLocalizations.of(context).config_device_wifi,
            );
            break;
          case 'scan_QR':
            scanQR(context);
            break;
          case 'find_local_gateway':
            context.push(AppRoutes.findGateway);
            break;
          case 'user_guide':
            AppNavigator.pushGuide(context, activeIndex: 0);
            break;
        }
      },
    ),
  ];
}

Future<void> scanQR(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  if (!context.mounted) return;
  if (prefs.containsKey("scan_QR_Dialog") && prefs.getBool("scan_QR_Dialog")!) {
    if (await userSignedIn()) {
      if (!context.mounted) return;
      context.push(AppRoutes.scanQr);
    } else {
      if (!context.mounted) return;
      context.push(AppRoutes.login);
    }
  } else {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              OpenIoTHubLocalizations.of(context).camera_scan_code_prompt,
            ),
            scrollable: true,
            content: SizedBox(
              height: 120,
              child: ListView(
                children: <Widget>[
                  Text(
                    OpenIoTHubLocalizations.of(
                      context,
                    ).camera_scan_code_prompt_content,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  OpenIoTHubLocalizations.of(context).cancel,
                  style: TextStyle(color: Colors.grey),
                ),
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
                  if (await userSignedIn()) {
                    if (!context.mounted) return;
                    await prefs.setBool("scan_QR_Dialog", true);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    if (!context.mounted) return;
                    context.push(AppRoutes.scanQr);
                  } else {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    if (!context.mounted) return;
                    context.push(AppRoutes.login);
                  }
                },
              ),
            ],
          ),
    );
  }
}

_buildPopupMenuItem(IconData icon, String title, BuildContext context) {
  // 使用主题颜色，确保在浅色和深色主题下都有良好的对比度
  final iconColor = Theme.of(context).iconTheme.color ?? 
                   (Theme.of(context).brightness == Brightness.dark 
                     ? Colors.white 
                     : Colors.black87);
  final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? 
                   (Theme.of(context).brightness == Brightness.dark 
                     ? Colors.white 
                     : Colors.black87);
  
  return Row(
    children: <Widget>[
      Icon(
        icon,
        color: iconColor,
      ),

      //Image.asset(CommonUtils.getBaseIconUrlPng("main_top_add_friends"), width: 18, height: 18,),
      Container(width: 12.0),
      Text(
        title,
        style: TextStyle(color: textColor),
      ),
    ],
  );
}
