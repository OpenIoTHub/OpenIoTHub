import 'dart:io';

class GoogleAdConfig {

  // Andriod
  static const String appOpenAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String rewardedAdUnitIdAnndroid = 'ca-app-pub-3940256099942544/2247696110';

  // iOS
  static const String appOpenAdUnitIdiOS = 'ca-app-pub-3940256099942544/4411468910';
  static const String bannerAdUnitIdiOS = 'ca-app-pub-3940256099942544/2934735716';
  static const String rewardedAdUnitIdiOS = 'ca-app-pub-3940256099942544/3986624511';

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