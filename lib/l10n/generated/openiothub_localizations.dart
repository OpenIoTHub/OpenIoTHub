import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'openiothub_localizations_en.dart'
    deferred as openiothub_localizations_en;
import 'openiothub_localizations_zh.dart'
    deferred as openiothub_localizations_zh;

/// Callers can lookup localized strings with an instance of OpenIoTHubLocalizations
/// returned by `OpenIoTHubLocalizations.of(context)`.
///
/// Applications need to include `OpenIoTHubLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/openiothub_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: OpenIoTHubLocalizations.localizationsDelegates,
///   supportedLocales: OpenIoTHubLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the OpenIoTHubLocalizations.supportedLocales
/// property.
abstract class OpenIoTHubLocalizations {
  OpenIoTHubLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static OpenIoTHubLocalizations of(BuildContext context) {
    return Localizations.of<OpenIoTHubLocalizations>(
        context, OpenIoTHubLocalizations)!;
  }

  static const LocalizationsDelegate<OpenIoTHubLocalizations> delegate =
      _OpenIoTHubLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('en'),
    Locale('zh', 'CN'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'OpenIoTHub'**
  String get app_title;

  /// No description provided for @tab_smart.
  ///
  /// In en, this message translates to:
  /// **'smart'**
  String get tab_smart;

  /// No description provided for @tab_gateway.
  ///
  /// In en, this message translates to:
  /// **'gateway'**
  String get tab_gateway;

  /// No description provided for @tab_host.
  ///
  /// In en, this message translates to:
  /// **'host'**
  String get tab_host;

  /// No description provided for @tab_user.
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get tab_user;

  /// No description provided for @profile_not_logged_in.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get profile_not_logged_in;

  /// No description provided for @profile_click_avatar_to_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Click avatar to sign in'**
  String get profile_click_avatar_to_sign_in;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_settings;

  /// No description provided for @profile_servers.
  ///
  /// In en, this message translates to:
  /// **'My Servers'**
  String get profile_servers;

  /// No description provided for @profile_tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get profile_tools;

  /// No description provided for @profile_docs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get profile_docs;

  /// No description provided for @profile_video_tutorials.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get profile_video_tutorials;

  /// No description provided for @profile_feedback.
  ///
  /// In en, this message translates to:
  /// **'feedback'**
  String get profile_feedback;

  /// No description provided for @app_local_gateway.
  ///
  /// In en, this message translates to:
  /// **'App Local Gateway'**
  String get app_local_gateway;

  /// No description provided for @profile_about_this_app.
  ///
  /// In en, this message translates to:
  /// **'About this App'**
  String get profile_about_this_app;

  /// No description provided for @config_device_wifi.
  ///
  /// In en, this message translates to:
  /// **'Config Device WiFi'**
  String get config_device_wifi;

  /// No description provided for @scan_QR.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scan_QR;

  /// No description provided for @find_local_gateway.
  ///
  /// In en, this message translates to:
  /// **'Find Local Gateway'**
  String get find_local_gateway;

  /// No description provided for @add_remote_host.
  ///
  /// In en, this message translates to:
  /// **'Add Remote Host'**
  String get add_remote_host;
}

class _OpenIoTHubLocalizationsDelegate
    extends LocalizationsDelegate<OpenIoTHubLocalizations> {
  const _OpenIoTHubLocalizationsDelegate();

  @override
  Future<OpenIoTHubLocalizations> load(Locale locale) {
    return lookupOpenIoTHubLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_OpenIoTHubLocalizationsDelegate old) => false;
}

Future<OpenIoTHubLocalizations> lookupOpenIoTHubLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return openiothub_localizations_zh.loadLibrary().then((dynamic _) =>
                openiothub_localizations_zh.OpenIoTHubLocalizationsZhHans());
          case 'Hant':
            return openiothub_localizations_zh.loadLibrary().then((dynamic _) =>
                openiothub_localizations_zh.OpenIoTHubLocalizationsZhHant());
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return openiothub_localizations_zh.loadLibrary().then((dynamic _) =>
                openiothub_localizations_zh.OpenIoTHubLocalizationsZhCn());
          case 'TW':
            return openiothub_localizations_zh.loadLibrary().then((dynamic _) =>
                openiothub_localizations_zh.OpenIoTHubLocalizationsZhTw());
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return openiothub_localizations_en.loadLibrary().then((dynamic _) =>
          openiothub_localizations_en.OpenIoTHubLocalizationsEn());
    case 'zh':
      return openiothub_localizations_zh.loadLibrary().then((dynamic _) =>
          openiothub_localizations_zh.OpenIoTHubLocalizationsZh());
  }

  throw FlutterError(
      'OpenIoTHubLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
