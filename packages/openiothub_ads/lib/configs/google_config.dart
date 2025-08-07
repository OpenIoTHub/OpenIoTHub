import 'dart:io';

class GoogleAdConfig {

  // Andriod
  static const String appOpenAdUnitIdAndroid = 'ca-app-pub-3940256099942544/9257395921';
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/9214589741';
  static const String rewardedAdUnitIdAnndroid = 'ca-app-pub-3940256099942544/5224354917';

  // iOS
  static const String appOpenAdUnitIdiOS = 'ca-app-pub-3940256099942544/5575463023';
  static const String bannerAdUnitIdiOS = 'ca-app-pub-3940256099942544/2435281174';
  static const String rewardedAdUnitIdiOS = 'ca-app-pub-3940256099942544/1712485313';

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