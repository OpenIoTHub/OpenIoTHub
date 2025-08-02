import 'dart:io';

class CsjAdConfig {

  // Andriod
  static const String appIdAndroid = '1037524';
  static const String appOpenAdUnitIdAndroid = '1037524';
  static const String bannerAdUnitIdAndroid = '1078260';
  static const String rewardedAdUnitIdAnndroid = '1035474';

  // iOS
  static const String appIdiOS = '1076284';
  static const String appOpenAdUnitIdiOS = '1076284';
  static const String bannerAdUnitIdiOS = '1037981';
  static const String rewardedAdUnitIdiOS = '1035455';

  // -- Don't edit these --

  static const postIntervaCountInlineAdsDefault = 5;
  static const clickAmountCountInterstitalAdsDefault = 3;

  static String getAppId() {
    if (Platform.isAndroid) {
      return appIdAndroid;
    } else {
      return appIdiOS;
    }
  }

  static String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return bannerAdUnitIdAndroid;
    } else {
      return bannerAdUnitIdiOS;
    }
  }

  static String getAppOpenAdUnitId() {
    if (Platform.isAndroid) {
      return appOpenAdUnitIdAndroid;
    } else {
      return appOpenAdUnitIdiOS;
    }
  }

  static String getRewardedAdUnitId() {
    if (Platform.isAndroid) {
      return rewardedAdUnitIdAnndroid;
    } else {
      return rewardedAdUnitIdiOS;
    }
  }
}