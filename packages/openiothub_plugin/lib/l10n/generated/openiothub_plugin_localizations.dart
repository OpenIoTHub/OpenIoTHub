import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'openiothub_plugin_localizations_en.dart';
import 'openiothub_plugin_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of OpenIoTHubPluginLocalizations
/// returned by `OpenIoTHubPluginLocalizations.of(context)`.
///
/// Applications need to include `OpenIoTHubPluginLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/openiothub_plugin_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: OpenIoTHubPluginLocalizations.localizationsDelegates,
///   supportedLocales: OpenIoTHubPluginLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the OpenIoTHubPluginLocalizations.supportedLocales
/// property.
abstract class OpenIoTHubPluginLocalizations {
  OpenIoTHubPluginLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static OpenIoTHubPluginLocalizations of(BuildContext context) {
    return Localizations.of<OpenIoTHubPluginLocalizations>(
        context, OpenIoTHubPluginLocalizations)!;
  }

  static const LocalizationsDelegate<OpenIoTHubPluginLocalizations> delegate =
      _OpenIoTHubPluginLocalizationsDelegate();

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
    Locale('en'),
    Locale('zh'),
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

  /// No description provided for @rdp_remote_desktop.
  ///
  /// In en, this message translates to:
  /// **'RDP remote desktop'**
  String get rdp_remote_desktop;

  /// No description provided for @select_server_for_gateway.
  ///
  /// In en, this message translates to:
  /// **'Select server for gateway'**
  String get select_server_for_gateway;

  /// No description provided for @add_gateway_success.
  ///
  /// In en, this message translates to:
  /// **'Add gateway success！'**
  String get add_gateway_success;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed！'**
  String get login_failed;

  /// No description provided for @add_gateway_failed.
  ///
  /// In en, this message translates to:
  /// **'Add gateway failed!'**
  String get add_gateway_failed;

  /// No description provided for @gateway_already_added.
  ///
  /// In en, this message translates to:
  /// **'This gateway has been added by another user. Please contact the gateway administrator or clear the gateway configuration and restart the gateway'**
  String get gateway_already_added;

  /// No description provided for @confirm_gateway_connect_this_server.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to add this gateway to this server?'**
  String get confirm_gateway_connect_this_server;

  /// No description provided for @get_gateway_login_status_failed.
  ///
  /// In en, this message translates to:
  /// **'Get abnormal login status of gateway'**
  String get get_gateway_login_status_failed;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @onvif_camera_manager.
  ///
  /// In en, this message translates to:
  /// **'Onvif camera manager'**
  String get onvif_camera_manager;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm_delete_onvif_device.
  ///
  /// In en, this message translates to:
  /// **'Confirm delete onvif device?'**
  String get confirm_delete_onvif_device;

  /// No description provided for @onvif_camera.
  ///
  /// In en, this message translates to:
  /// **'Onvif camera'**
  String get onvif_camera;

  /// No description provided for @add_onvif_camera.
  ///
  /// In en, this message translates to:
  /// **'Add onvif camera'**
  String get add_onvif_camera;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @custom_name.
  ///
  /// In en, this message translates to:
  /// **'Custom name'**
  String get custom_name;

  /// No description provided for @x_addr_addr.
  ///
  /// In en, this message translates to:
  /// **'XAddr addr'**
  String get x_addr_addr;

  /// No description provided for @onvif_device_host_port.
  ///
  /// In en, this message translates to:
  /// **'Onvif device addr:port'**
  String get onvif_device_host_port;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @onvif_username.
  ///
  /// In en, this message translates to:
  /// **'Onvif username'**
  String get onvif_username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @onvif_password.
  ///
  /// In en, this message translates to:
  /// **'Onvif password'**
  String get onvif_password;

  /// No description provided for @web_browser.
  ///
  /// In en, this message translates to:
  /// **'Web browser'**
  String get web_browser;

  /// No description provided for @device_name.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get device_name;

  /// No description provided for @device_model.
  ///
  /// In en, this message translates to:
  /// **'Device model'**
  String get device_model;

  /// No description provided for @mac_addr.
  ///
  /// In en, this message translates to:
  /// **'MAC addr'**
  String get mac_addr;

  /// No description provided for @firmware_author.
  ///
  /// In en, this message translates to:
  /// **'Firmware author'**
  String get firmware_author;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @home_page.
  ///
  /// In en, this message translates to:
  /// **'Home page'**
  String get home_page;

  /// No description provided for @firmware_repository.
  ///
  /// In en, this message translates to:
  /// **'Firmware repository'**
  String get firmware_repository;

  /// No description provided for @firmware_version.
  ///
  /// In en, this message translates to:
  /// **'Firmware version'**
  String get firmware_version;

  /// No description provided for @is_local.
  ///
  /// In en, this message translates to:
  /// **'Is local?'**
  String get is_local;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @device_ip.
  ///
  /// In en, this message translates to:
  /// **'Device ip'**
  String get device_ip;

  /// No description provided for @device_port.
  ///
  /// In en, this message translates to:
  /// **'Device port'**
  String get device_port;

  /// No description provided for @device_info.
  ///
  /// In en, this message translates to:
  /// **'Device info'**
  String get device_info;

  /// No description provided for @modify_device_name.
  ///
  /// In en, this message translates to:
  /// **'Modify device name'**
  String get modify_device_name;

  /// No description provided for @input_new_device_name.
  ///
  /// In en, this message translates to:
  /// **'Input new device name'**
  String get input_new_device_name;

  /// No description provided for @delete_device.
  ///
  /// In en, this message translates to:
  /// **'Delete device'**
  String get delete_device;

  /// No description provided for @confirm_delete_device.
  ///
  /// In en, this message translates to:
  /// **'Confirm delete device?'**
  String get confirm_delete_device;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @delete_success.
  ///
  /// In en, this message translates to:
  /// **'Delete_success!'**
  String get delete_success;

  /// No description provided for @mdns_info.
  ///
  /// In en, this message translates to:
  /// **'Mdns info'**
  String get mdns_info;

  /// No description provided for @firmware_url.
  ///
  /// In en, this message translates to:
  /// **'Firmware url'**
  String get firmware_url;

  /// No description provided for @start_ota.
  ///
  /// In en, this message translates to:
  /// **'Start OTA'**
  String get start_ota;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @setting_name.
  ///
  /// In en, this message translates to:
  /// **'Setting name'**
  String get setting_name;

  /// No description provided for @upgrade_firmware.
  ///
  /// In en, this message translates to:
  /// **'Upgrade firmware'**
  String get upgrade_firmware;

  /// No description provided for @switch_control.
  ///
  /// In en, this message translates to:
  /// **'Switch control'**
  String get switch_control;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @effect.
  ///
  /// In en, this message translates to:
  /// **'Effect'**
  String get effect;

  /// No description provided for @switch_bottom.
  ///
  /// In en, this message translates to:
  /// **'Switch bottom'**
  String get switch_bottom;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @please_input_message.
  ///
  /// In en, this message translates to:
  /// **'Please input message'**
  String get please_input_message;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @serial_port.
  ///
  /// In en, this message translates to:
  /// **'Serial port'**
  String get serial_port;

  /// No description provided for @please_input_linux_login_info.
  ///
  /// In en, this message translates to:
  /// **'Please input linux login info'**
  String get please_input_linux_login_info;

  /// No description provided for @linux_username.
  ///
  /// In en, this message translates to:
  /// **'L(U)inux username'**
  String get linux_username;

  /// No description provided for @ssh_password.
  ///
  /// In en, this message translates to:
  /// **'SSH password'**
  String get ssh_password;

  /// No description provided for @above_mentioned_ssh_password.
  ///
  /// In en, this message translates to:
  /// **'Above mentioned SSH password'**
  String get above_mentioned_ssh_password;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @please_input_user_name.
  ///
  /// In en, this message translates to:
  /// **'Please input user name'**
  String get please_input_user_name;

  /// No description provided for @please_input_password.
  ///
  /// In en, this message translates to:
  /// **'Please input password'**
  String get please_input_password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username_and_password_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Username and password cant be empty'**
  String get username_and_password_cant_be_empty;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @please_input_ssh_username_password.
  ///
  /// In en, this message translates to:
  /// **'Please input ssh username and password'**
  String get please_input_ssh_username_password;
}

class _OpenIoTHubPluginLocalizationsDelegate
    extends LocalizationsDelegate<OpenIoTHubPluginLocalizations> {
  const _OpenIoTHubPluginLocalizationsDelegate();

  @override
  Future<OpenIoTHubPluginLocalizations> load(Locale locale) {
    return SynchronousFuture<OpenIoTHubPluginLocalizations>(
        lookupOpenIoTHubPluginLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_OpenIoTHubPluginLocalizationsDelegate old) => false;
}

OpenIoTHubPluginLocalizations lookupOpenIoTHubPluginLocalizations(
    Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return OpenIoTHubPluginLocalizationsZhHans();
          case 'Hant':
            return OpenIoTHubPluginLocalizationsZhHant();
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
            return OpenIoTHubPluginLocalizationsZhCn();
          case 'TW':
            return OpenIoTHubPluginLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return OpenIoTHubPluginLocalizationsEn();
    case 'zh':
      return OpenIoTHubPluginLocalizationsZh();
  }

  throw FlutterError(
      'OpenIoTHubPluginLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
