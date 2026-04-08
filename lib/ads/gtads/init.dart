import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gtads/gtads.dart';
// import 'package:gtads_csj/gtads_csj.dart';
import 'package:gtads_ylh/gtads_ylh.dart';
import 'package:openiothub/core/storage/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/configs.dart';

Future initGTADsAD() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (Platform.isAndroid &&
      (!prefs.containsKey(SharedPreferencesKey.agreedPrivacyPolicy) ||
          !(prefs.getBool(SharedPreferencesKey.agreedPrivacyPolicy)!))) {
    return null;
  }
  MobileAds.instance.initialize().then((status) {
    debugPrint('MobileAds adapterStatuses: ${status.adapterStatuses}');
  });
  // 添加 Provider：优量汇(ylh) 置于首位，与各广告位 GTAdsCode 中 ylh 优先策略一致
  GTAds.addProviders([
    GTAdsYlhProvider("ylh", YlhAdConfig.getAppId(), YlhAdConfig.getAppId()),
    // GTAdsCsjProvider("csj", CsjAdConfig.getAppId(), CsjAdConfig.getAppId(), appName: "云亿连"),
  ]);
  var initList = await GTAds.init(isDebug: true);
  return initList;
}