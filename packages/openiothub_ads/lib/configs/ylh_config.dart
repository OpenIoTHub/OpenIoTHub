import 'dart:io';

class YlhAdConfig {

  // Andriod
  static const String appOpenAdUnitIdAndroid = '3196809258';
  static const String bannerAdUnitIdAndroid = '515666807244';
  static const String rewardedAdUnitIdAnndroid = '117809701965';

  // iOS
  static const String appOpenAdUnitIdiOS = '410696209357';
  static const String bannerAdUnitIdiOS = '4126733603341';
  static const String rewardedAdUnitIdiOS = '819349913258';

  // -- Don't edit these --

  static const postIntervaCountInlineAdsDefault = 5;
  static const clickAmountCountInterstitalAdsDefault = 3;

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