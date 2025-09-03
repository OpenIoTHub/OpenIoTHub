import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'openiothub_common_localizations_en.dart';
import 'openiothub_common_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of OpenIoTHubCommonLocalizations
/// returned by `OpenIoTHubCommonLocalizations.of(context)`.
///
/// Applications need to include `OpenIoTHubCommonLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/openiothub_common_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: OpenIoTHubCommonLocalizations.localizationsDelegates,
///   supportedLocales: OpenIoTHubCommonLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the OpenIoTHubCommonLocalizations.supportedLocales
/// property.
abstract class OpenIoTHubCommonLocalizations {
  OpenIoTHubCommonLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static OpenIoTHubCommonLocalizations of(BuildContext context) {
    return Localizations.of<OpenIoTHubCommonLocalizations>(
        context, OpenIoTHubCommonLocalizations)!;
  }

  static const LocalizationsDelegate<OpenIoTHubCommonLocalizations> delegate =
      _OpenIoTHubCommonLocalizationsDelegate();

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

  /// No description provided for @click_to_get_wifi_info.
  ///
  /// In en, this message translates to:
  /// **'Click to get WiFi info'**
  String get click_to_get_wifi_info;

  /// No description provided for @input_wifi_password.
  ///
  /// In en, this message translates to:
  /// **'Input WiFi password'**
  String get input_wifi_password;

  /// No description provided for @connecting_to_router.
  ///
  /// In en, this message translates to:
  /// **'Connecting_to_router'**
  String get connecting_to_router;

  /// No description provided for @device_wifi_config.
  ///
  /// In en, this message translates to:
  /// **'Device WiFi config'**
  String get device_wifi_config;

  /// No description provided for @wifi_ssid.
  ///
  /// In en, this message translates to:
  /// **'WiFi SSID'**
  String get wifi_ssid;

  /// No description provided for @start_adding_surrounding_smart_devices.
  ///
  /// In en, this message translates to:
  /// **'Start adding surrounding smart devices'**
  String get start_adding_surrounding_smart_devices;

  /// No description provided for @wifi_info_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'WiFi info can\'t be empty'**
  String get wifi_info_cant_be_empty;

  /// No description provided for @discovering_device_please_wait.
  ///
  /// In en, this message translates to:
  /// **'Discovering device, please be patient and wait for approximately one minute'**
  String get discovering_device_please_wait;

  /// No description provided for @please_input_2p4g_wifi_password.
  ///
  /// In en, this message translates to:
  /// **'Enter the router WIFI (2.4G frequency) password to start network distribution'**
  String get please_input_2p4g_wifi_password;

  /// No description provided for @airkiss_device_wifi_config_success.
  ///
  /// In en, this message translates to:
  /// **'The nearby AirKiss equipment distribution task has been completed'**
  String get airkiss_device_wifi_config_success;

  /// No description provided for @bind_wechat_success.
  ///
  /// In en, this message translates to:
  /// **'WeChat binding successful!'**
  String get bind_wechat_success;

  /// No description provided for @bind_wechat_failed.
  ///
  /// In en, this message translates to:
  /// **'Binding WeChat failed!'**
  String get bind_wechat_failed;

  /// No description provided for @get_wechat_login_info_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to obtain WeChat login information'**
  String get get_wechat_login_info_failed;

  /// No description provided for @account_and_safety.
  ///
  /// In en, this message translates to:
  /// **'Account and safety'**
  String get account_and_safety;

  /// No description provided for @mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobile_number;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @user_mobile.
  ///
  /// In en, this message translates to:
  /// **'User mobile'**
  String get user_mobile;

  /// No description provided for @user_email.
  ///
  /// In en, this message translates to:
  /// **'User email'**
  String get user_email;

  /// No description provided for @modify_password.
  ///
  /// In en, this message translates to:
  /// **'Modify password'**
  String get modify_password;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @bind_wechat.
  ///
  /// In en, this message translates to:
  /// **'Bind wechat'**
  String get bind_wechat;

  /// No description provided for @no_wechat_installed.
  ///
  /// In en, this message translates to:
  /// **'No wechat installed'**
  String get no_wechat_installed;

  /// No description provided for @unbind_wechat.
  ///
  /// In en, this message translates to:
  /// **'Unbind wechat'**
  String get unbind_wechat;

  /// No description provided for @unbind_wechat_success.
  ///
  /// In en, this message translates to:
  /// **'Unbind wechat success!'**
  String get unbind_wechat_success;

  /// No description provided for @unbind_wechat_failed_reason.
  ///
  /// In en, this message translates to:
  /// **'Unbind wechat failed,reason:'**
  String get unbind_wechat_failed_reason;

  /// No description provided for @cancel_account.
  ///
  /// In en, this message translates to:
  /// **'Cancel account'**
  String get cancel_account;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @please_input_new_value.
  ///
  /// In en, this message translates to:
  /// **'Please input new value'**
  String get please_input_new_value;

  /// No description provided for @new_value.
  ///
  /// In en, this message translates to:
  /// **'New value'**
  String get new_value;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel_my_account.
  ///
  /// In en, this message translates to:
  /// **'Cancel my account'**
  String get cancel_my_account;

  /// No description provided for @cancel_my_account_notify1.
  ///
  /// In en, this message translates to:
  /// **'Please note that after confirming the deletion, the deletion operation will take effect immediately and cannot be restored!'**
  String get cancel_my_account_notify1;

  /// No description provided for @operation_cannot_be_restored.
  ///
  /// In en, this message translates to:
  /// **'Operation cannot be restored!'**
  String get operation_cannot_be_restored;

  /// No description provided for @please_input_your_password.
  ///
  /// In en, this message translates to:
  /// **'Please input your password'**
  String get please_input_your_password;

  /// No description provided for @current_account_password.
  ///
  /// In en, this message translates to:
  /// **'Current account password'**
  String get current_account_password;

  /// No description provided for @confirm_cancel_account.
  ///
  /// In en, this message translates to:
  /// **'Confirm cancel account?'**
  String get confirm_cancel_account;

  /// No description provided for @cancel_account_success.
  ///
  /// In en, this message translates to:
  /// **'Cancel account success!'**
  String get cancel_account_success;

  /// No description provided for @cancel_account_failed.
  ///
  /// In en, this message translates to:
  /// **'Cancel account failed'**
  String get cancel_account_failed;

  /// No description provided for @wechat_login_failed.
  ///
  /// In en, this message translates to:
  /// **'Wechat login failed'**
  String get wechat_login_failed;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @please_input_mobile.
  ///
  /// In en, this message translates to:
  /// **'Please input mobile'**
  String get please_input_mobile;

  /// No description provided for @please_input_password.
  ///
  /// In en, this message translates to:
  /// **'Please input password'**
  String get please_input_password;

  /// No description provided for @agree_to_the_user_agreement1.
  ///
  /// In en, this message translates to:
  /// **'Please check the box'**
  String get agree_to_the_user_agreement1;

  /// No description provided for @agree_to_the_user_agreement2.
  ///
  /// In en, this message translates to:
  /// **'Only by agreeing to the privacy policy below can we proceed to the next step'**
  String get agree_to_the_user_agreement2;

  /// No description provided for @username_and_password_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Username and password cannot be empty'**
  String get username_and_password_cant_be_empty;

  /// No description provided for @user_registration.
  ///
  /// In en, this message translates to:
  /// **'User registration'**
  String get user_registration;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy_policy;

  /// No description provided for @feedback_channels.
  ///
  /// In en, this message translates to:
  /// **'Feedback channels'**
  String get feedback_channels;

  /// No description provided for @get_wechat_qr_code_failed.
  ///
  /// In en, this message translates to:
  /// **'Get wechat qr code failed！'**
  String get get_wechat_qr_code_failed;

  /// No description provided for @wechat_scan_qr_code_to_login.
  ///
  /// In en, this message translates to:
  /// **'Wechat scan qr code to login!'**
  String get wechat_scan_qr_code_to_login;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get login_failed;

  /// No description provided for @login_after_wechat_bind.
  ///
  /// In en, this message translates to:
  /// **'Please bind this WeChat account and use WeChat Quick Login now'**
  String get login_after_wechat_bind;

  /// No description provided for @wechat_fast_login_failed.
  ///
  /// In en, this message translates to:
  /// **'WeChat quick login failed'**
  String get wechat_fast_login_failed;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Registered successfully Please log in with your registration information!'**
  String get register_success;

  /// No description provided for @register_failed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed! Please register again'**
  String get register_failed;

  /// No description provided for @user_info.
  ///
  /// In en, this message translates to:
  /// **'User info'**
  String get user_info;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @share_success.
  ///
  /// In en, this message translates to:
  /// **'Share success!'**
  String get share_success;

  /// No description provided for @share_failed.
  ///
  /// In en, this message translates to:
  /// **'Share failed!'**
  String get share_failed;

  /// No description provided for @as_a_gateway.
  ///
  /// In en, this message translates to:
  /// **'As a gateway'**
  String get as_a_gateway;

  /// No description provided for @as_a_gateway_description1.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code above using the OpenIoTHub APP to add this gateway and access this network'**
  String get as_a_gateway_description1;

  /// No description provided for @change_gateway_id.
  ///
  /// In en, this message translates to:
  /// **'Change gateway id'**
  String get change_gateway_id;

  /// No description provided for @go_to_main_menu.
  ///
  /// In en, this message translates to:
  /// **'Return to the main interface'**
  String get go_to_main_menu;

  /// No description provided for @share_to_wechat.
  ///
  /// In en, this message translates to:
  /// **'Share on WeChat'**
  String get share_to_wechat;

  /// No description provided for @select_where_to_share.
  ///
  /// In en, this message translates to:
  /// **'Choose the location for the demander to share'**
  String get select_where_to_share;

  /// No description provided for @openiothub_gateway_share.
  ///
  /// In en, this message translates to:
  /// **'OpenIoTHub Gateway Sharing'**
  String get openiothub_gateway_share;

  /// No description provided for @openiothub_gateway_share_description.
  ///
  /// In en, this message translates to:
  /// **'Use OpenIoTHub to scan the QR code and add a gateway to manage all your smart devices and private clouds'**
  String get openiothub_gateway_share_description;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'App name:'**
  String get app_name;

  /// No description provided for @package_name.
  ///
  /// In en, this message translates to:
  /// **'Package name:'**
  String get package_name;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version:'**
  String get version;

  /// No description provided for @version_sn.
  ///
  /// In en, this message translates to:
  /// **'Version sn:'**
  String get version_sn;

  /// No description provided for @icp_number.
  ///
  /// In en, this message translates to:
  /// **'APP ICP number:'**
  String get icp_number;

  /// No description provided for @online_feedback.
  ///
  /// In en, this message translates to:
  /// **'Online feedback'**
  String get online_feedback;

  /// No description provided for @app_info.
  ///
  /// In en, this message translates to:
  /// **'App info'**
  String get app_info;

  /// No description provided for @share_app_title.
  ///
  /// In en, this message translates to:
  /// **'OpenIoTHub\'s internal network penetration and smart home management'**
  String get share_app_title;

  /// No description provided for @share_app_description.
  ///
  /// In en, this message translates to:
  /// **'OpenIoTHub manages all your smart devices and private clouds across the entire platform'**
  String get share_app_description;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @share_to_where.
  ///
  /// In en, this message translates to:
  /// **'Choose the location for the demander to share'**
  String get share_to_where;

  /// No description provided for @wechat_not_installed.
  ///
  /// In en, this message translates to:
  /// **'WeChat not installed'**
  String get wechat_not_installed;

  /// No description provided for @share_on_moments.
  ///
  /// In en, this message translates to:
  /// **'Share on Moments'**
  String get share_on_moments;

  /// No description provided for @find_local_gateway_list.
  ///
  /// In en, this message translates to:
  /// **'Discover local gateway list'**
  String get find_local_gateway_list;

  /// No description provided for @manually_create_a_gateway.
  ///
  /// In en, this message translates to:
  /// **'Manually creating a gateway?'**
  String get manually_create_a_gateway;

  /// No description provided for @manually_create_a_gateway_description1.
  ///
  /// In en, this message translates to:
  /// **'The installed gateway can be found on this page'**
  String get manually_create_a_gateway_description1;

  /// No description provided for @manually_create_a_gateway_description2.
  ///
  /// In en, this message translates to:
  /// **'Automatically generate a gateway information and fill it into the gateway configuration file with the token, suitable for situations where the mobile phone cannot discover the gateway on the local area network'**
  String get manually_create_a_gateway_description2;

  /// No description provided for @manually_create_a_gateway_description3.
  ///
  /// In en, this message translates to:
  /// **'Select the server that the gateway needs to connect to from below:'**
  String get manually_create_a_gateway_description3;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @paste_info.
  ///
  /// In en, this message translates to:
  /// **'The ID and token of the gateway have been copied to the clipboard. Please fill in the configuration of the clipboard in the gateway\'s configuration file'**
  String get paste_info;

  /// No description provided for @add_gateway_success.
  ///
  /// In en, this message translates to:
  /// **'The ID and token of the gateway have been copied to the clipboard. Please fill in the configuration of the clipboard in the gateway\'s configuration file'**
  String get add_gateway_success;

  /// No description provided for @gateway_install_guide.
  ///
  /// In en, this message translates to:
  /// **'Gateway Installation Guide'**
  String get gateway_install_guide;

  /// No description provided for @gateway_install_guide_content1.
  ///
  /// In en, this message translates to:
  /// **'Here\'s how to install your own gateway'**
  String get gateway_install_guide_content1;

  /// No description provided for @gateway_install_guide_content2.
  ///
  /// In en, this message translates to:
  /// **'Firstly, you need to install the gateway to the local area network you need to access and keep it running continuously'**
  String get gateway_install_guide_content2;

  /// No description provided for @gateway_install_guide_content3.
  ///
  /// In en, this message translates to:
  /// **'On the first attempt, connect this app to the local area network where the gateway is located'**
  String get gateway_install_guide_content3;

  /// No description provided for @gateway_install_guide_content4.
  ///
  /// In en, this message translates to:
  /// **'After searching and configuring the gateway on the local area network, the APP adds it once'**
  String get gateway_install_guide_content4;

  /// No description provided for @gateway_install_guide_content5.
  ///
  /// In en, this message translates to:
  /// **'In the future, as long as the gateway is online, the mobile client can access it'**
  String get gateway_install_guide_content5;

  /// No description provided for @gateway_install_guide_content6.
  ///
  /// In en, this message translates to:
  /// **'Here is an introduction on how to install a gateway on the network you need to access'**
  String get gateway_install_guide_content6;

  /// No description provided for @gateway_install_guide_content7.
  ///
  /// In en, this message translates to:
  /// **'View the open source address of the gateway'**
  String get gateway_install_guide_content7;

  /// No description provided for @gateway_install_guide_content8.
  ///
  /// In en, this message translates to:
  /// **'OpenWRT router snapshot source installation: opkg install gateway-go'**
  String get gateway_install_guide_content8;

  /// No description provided for @gateway_install_guide_content9.
  ///
  /// In en, this message translates to:
  /// **'MacOS installation using homebrew: brew install gateway-go'**
  String get gateway_install_guide_content9;

  /// No description provided for @gateway_install_guide_content10.
  ///
  /// In en, this message translates to:
  /// **'Linux installation using Snapcraft: sudo snap install gateway-go'**
  String get gateway_install_guide_content10;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @define_server_name.
  ///
  /// In en, this message translates to:
  /// **'Customize server name'**
  String get define_server_name;

  /// No description provided for @define_server_ip_or_domain.
  ///
  /// In en, this message translates to:
  /// **'Server IP address or domain name'**
  String get define_server_ip_or_domain;

  /// No description provided for @define_server_addr.
  ///
  /// In en, this message translates to:
  /// **'The address of the public server go server'**
  String get define_server_addr;

  /// No description provided for @define_server_key.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get define_server_key;

  /// No description provided for @define_server_tcp_port.
  ///
  /// In en, this message translates to:
  /// **'Tcp port'**
  String get define_server_tcp_port;

  /// No description provided for @define_server_kcp_port.
  ///
  /// In en, this message translates to:
  /// **'Kcp port'**
  String get define_server_kcp_port;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @define_description.
  ///
  /// In en, this message translates to:
  /// **'Customize description information'**
  String get define_description;

  /// No description provided for @for_everyone_to_use.
  ///
  /// In en, this message translates to:
  /// **'Provided to all users of the app for use:'**
  String get for_everyone_to_use;

  /// No description provided for @update_success.
  ///
  /// In en, this message translates to:
  /// **'Update successful!'**
  String get update_success;

  /// No description provided for @confirm_modify.
  ///
  /// In en, this message translates to:
  /// **'Confirm modification'**
  String get confirm_modify;

  /// No description provided for @server_info.
  ///
  /// In en, this message translates to:
  /// **'Server information'**
  String get server_info;

  /// No description provided for @delete_success.
  ///
  /// In en, this message translates to:
  /// **'Delete successfully！'**
  String get delete_success;

  /// No description provided for @grpc_server_addr.
  ///
  /// In en, this message translates to:
  /// **'Address of grpc service'**
  String get grpc_server_addr;

  /// No description provided for @grpc_server_ip_or_domain.
  ///
  /// In en, this message translates to:
  /// **'Please enter the IP or domain name of the grpc service'**
  String get grpc_server_ip_or_domain;

  /// No description provided for @grpc_service_port.
  ///
  /// In en, this message translates to:
  /// **'Port for grpc service'**
  String get grpc_service_port;

  /// No description provided for @input_grpc_service_port.
  ///
  /// In en, this message translates to:
  /// **'Please enter the port of the grpc service'**
  String get input_grpc_service_port;

  /// No description provided for @iot_manager_addr.
  ///
  /// In en, this message translates to:
  /// **'iot-manager addr'**
  String get iot_manager_addr;

  /// No description provided for @input_iot_manager_addr.
  ///
  /// In en, this message translates to:
  /// **'Please enter the iot_manager GRPC service address'**
  String get input_iot_manager_addr;

  /// No description provided for @activate_front_desk_service.
  ///
  /// In en, this message translates to:
  /// **'Android background service keep alive'**
  String get activate_front_desk_service;

  /// No description provided for @auto_start_gateway.
  ///
  /// In en, this message translates to:
  /// **'Auto start gateway when APP started'**
  String get auto_start_gateway;

  /// No description provided for @wake_lock_enabled.
  ///
  /// In en, this message translates to:
  /// **'Wake lock enabled'**
  String get wake_lock_enabled;

  /// No description provided for @my_server_description_example.
  ///
  /// In en, this message translates to:
  /// **'My own server-go server'**
  String get my_server_description_example;

  /// No description provided for @server_go_addr_example.
  ///
  /// In en, this message translates to:
  /// **'usa.servers.iothub.cloud'**
  String get server_go_addr_example;

  /// No description provided for @my_server_description.
  ///
  /// In en, this message translates to:
  /// **'Description of my server'**
  String get my_server_description;

  /// No description provided for @add_self_hosted_server.
  ///
  /// In en, this message translates to:
  /// **'Add self built server:'**
  String get add_self_hosted_server;

  /// No description provided for @server_uuid.
  ///
  /// In en, this message translates to:
  /// **'Server uuid'**
  String get server_uuid;

  /// No description provided for @as_config_file.
  ///
  /// In en, this message translates to:
  /// **'Consistent with the configuration files in the server-go server'**
  String get as_config_file;

  /// No description provided for @add_to_server.
  ///
  /// In en, this message translates to:
  /// **'Add to server'**
  String get add_to_server;

  /// No description provided for @add_server.
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get add_server;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @location_req_name.
  ///
  /// In en, this message translates to:
  /// **'Request location permission'**
  String get location_req_name;

  /// No description provided for @location_req_desc.
  ///
  /// In en, this message translates to:
  /// **'Apply for location permission to obtain WiFi information for smart device distribution network'**
  String get location_req_desc;

  /// No description provided for @confirm_add_gateway.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to add a gateway?'**
  String get confirm_add_gateway;

  /// No description provided for @github_repo.
  ///
  /// In en, this message translates to:
  /// **'Github Repository'**
  String get github_repo;
}

class _OpenIoTHubCommonLocalizationsDelegate
    extends LocalizationsDelegate<OpenIoTHubCommonLocalizations> {
  const _OpenIoTHubCommonLocalizationsDelegate();

  @override
  Future<OpenIoTHubCommonLocalizations> load(Locale locale) {
    return SynchronousFuture<OpenIoTHubCommonLocalizations>(
        lookupOpenIoTHubCommonLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_OpenIoTHubCommonLocalizationsDelegate old) => false;
}

OpenIoTHubCommonLocalizations lookupOpenIoTHubCommonLocalizations(
    Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return OpenIoTHubCommonLocalizationsZhHans();
          case 'Hant':
            return OpenIoTHubCommonLocalizationsZhHant();
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
            return OpenIoTHubCommonLocalizationsZhCn();
          case 'TW':
            return OpenIoTHubCommonLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return OpenIoTHubCommonLocalizationsEn();
    case 'zh':
      return OpenIoTHubCommonLocalizationsZh();
  }

  throw FlutterError(
      'OpenIoTHubCommonLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
