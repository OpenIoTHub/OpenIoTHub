import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gtads/gtads.dart';
import 'package:gtads_csj/gtads_csj.dart';
import 'package:gtads_ylh/gtads_ylh.dart';
import 'package:openiothub_constants/constants/SharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/configs.dart';

Future initGTADsAD() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (Platform.isAndroid &&
      (!prefs.containsKey(SharedPreferencesKey.Agreed_Privacy_Policy) ||
          !(prefs.getBool(SharedPreferencesKey.Agreed_Privacy_Policy)!))) {
    return null;
  }
  MobileAds.instance.initialize().then((onValue){print(onValue.adapterStatuses.toString());});
  //添加Provider列表
  GTAds.addProviders([
    GTAdsYlhProvider("ylh", YlhAdConfig.getAppId(), YlhAdConfig.getAppId()),
    GTAdsCsjProvider("csj", CsjAdConfig.getAppId(), CsjAdConfig.getAppId(), appName: "云亿连"),
    // GTAdsYlhProvider("ylh", YlhAdConfig.appIdAndroid, YlhAdConfig.appIdiOS),
    // GTAdsCsjProvider("csj", CsjAdConfig.appIdAndroid, CsjAdConfig.appIdiOS, appName: "云亿连"),
  ]);
  var initList = await GTAds.init(isDebug: true);
  return initList;
}