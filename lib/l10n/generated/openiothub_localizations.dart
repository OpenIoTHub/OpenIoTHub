import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'openiothub_localizations_en.dart';
import 'openiothub_localizations_zh.dart';

// ignore_for_file: type=lint

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
      context,
      OpenIoTHubLocalizations,
    )!;
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
    Locale('zh', 'TW'),
  ];

  /// No description provided for @app_title.
  ///
  /// In zh, this message translates to:
  /// **'云亿连'**
  String get app_title;

  /// No description provided for @tab_smart.
  ///
  /// In zh, this message translates to:
  /// **'智能'**
  String get tab_smart;

  /// No description provided for @tab_gateway.
  ///
  /// In zh, this message translates to:
  /// **'网关'**
  String get tab_gateway;

  /// No description provided for @tab_host.
  ///
  /// In zh, this message translates to:
  /// **'主机'**
  String get tab_host;

  /// No description provided for @tab_user.
  ///
  /// In zh, this message translates to:
  /// **'我'**
  String get tab_user;

  /// No description provided for @profile_not_logged_in.
  ///
  /// In zh, this message translates to:
  /// **'未登录'**
  String get profile_not_logged_in;

  /// No description provided for @profile_click_avatar_to_sign_in.
  ///
  /// In zh, this message translates to:
  /// **'点击头像登录'**
  String get profile_click_avatar_to_sign_in;

  /// No description provided for @profile_settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get profile_settings;

  /// No description provided for @profile_servers.
  ///
  /// In zh, this message translates to:
  /// **'我的服务器'**
  String get profile_servers;

  /// No description provided for @profile_tools.
  ///
  /// In zh, this message translates to:
  /// **'工具'**
  String get profile_tools;

  /// No description provided for @profile_docs.
  ///
  /// In zh, this message translates to:
  /// **'文档'**
  String get profile_docs;

  /// No description provided for @profile_video_tutorials.
  ///
  /// In zh, this message translates to:
  /// **'视频教程'**
  String get profile_video_tutorials;

  /// No description provided for @profile_feedback.
  ///
  /// In zh, this message translates to:
  /// **'反馈和建议'**
  String get profile_feedback;

  /// No description provided for @app_local_gateway.
  ///
  /// In zh, this message translates to:
  /// **'本机网关'**
  String get app_local_gateway;

  /// No description provided for @profile_about_this_app.
  ///
  /// In zh, this message translates to:
  /// **'关于本软件'**
  String get profile_about_this_app;

  /// No description provided for @config_device_wifi.
  ///
  /// In zh, this message translates to:
  /// **'配置设备WiFi'**
  String get config_device_wifi;

  /// No description provided for @scan_QR.
  ///
  /// In zh, this message translates to:
  /// **'扫描二维码(推荐)'**
  String get scan_QR;

  /// No description provided for @find_local_gateway.
  ///
  /// In zh, this message translates to:
  /// **'发现局域网网关'**
  String get find_local_gateway;

  /// No description provided for @add_remote_host.
  ///
  /// In zh, this message translates to:
  /// **'添加远程主机'**
  String get add_remote_host;

  /// No description provided for @i_also_have_a_bottom_line.
  ///
  /// In zh, this message translates to:
  /// **'我也是有底线的'**
  String get i_also_have_a_bottom_line;

  /// No description provided for @ftp_port_list_title.
  ///
  /// In zh, this message translates to:
  /// **'FTP端口列表'**
  String get ftp_port_list_title;

  /// No description provided for @remote_port.
  ///
  /// In zh, this message translates to:
  /// **'远程端口'**
  String get remote_port;

  /// No description provided for @local_port.
  ///
  /// In zh, this message translates to:
  /// **'映射到本机端口'**
  String get local_port;

  /// No description provided for @description.
  ///
  /// In zh, this message translates to:
  /// **'描述'**
  String get description;

  /// No description provided for @forwarding_connection_status.
  ///
  /// In zh, this message translates to:
  /// **'转发连接状态'**
  String get forwarding_connection_status;

  /// No description provided for @online.
  ///
  /// In zh, this message translates to:
  /// **'在线'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In zh, this message translates to:
  /// **'离线'**
  String get offline;

  /// No description provided for @port_details.
  ///
  /// In zh, this message translates to:
  /// **'端口详情'**
  String get port_details;

  /// No description provided for @add_port.
  ///
  /// In zh, this message translates to:
  /// **'添加端口：'**
  String get add_port;

  /// No description provided for @notes.
  ///
  /// In zh, this message translates to:
  /// **'备注'**
  String get notes;

  /// No description provided for @custom_remarks.
  ///
  /// In zh, this message translates to:
  /// **'自定义备注'**
  String get custom_remarks;

  /// No description provided for @port_number.
  ///
  /// In zh, this message translates to:
  /// **'端口号'**
  String get port_number;

  /// No description provided for @the_port_number_of_this_machine.
  ///
  /// In zh, this message translates to:
  /// **'该机器的端口号'**
  String get the_port_number_of_this_machine;

  /// No description provided for @map_to_the_port_number_of_this_mobile_phone.
  ///
  /// In zh, this message translates to:
  /// **'映射到本手机端口号(随机则填0)'**
  String get map_to_the_port_number_of_this_mobile_phone;

  /// No description provided for @this_phone_has_an_idle_port_number_of_1024_or_above.
  ///
  /// In zh, this message translates to:
  /// **'本手机1024以上空闲端口号'**
  String get this_phone_has_an_idle_port_number_of_1024_or_above;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @check_if_the_port_is_a_number.
  ///
  /// In zh, this message translates to:
  /// **'检查端口是否为数字'**
  String get check_if_the_port_is_a_number;

  /// No description provided for @delete_ftp.
  ///
  /// In zh, this message translates to:
  /// **'删除FTP'**
  String get delete_ftp;

  /// No description provided for @confirm_to_delete_this_ftp.
  ///
  /// In zh, this message translates to:
  /// **'确认删除此FTP?'**
  String get confirm_to_delete_this_ftp;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @http_port_list_title.
  ///
  /// In zh, this message translates to:
  /// **'Http端口列表'**
  String get http_port_list_title;

  /// No description provided for @domain.
  ///
  /// In zh, this message translates to:
  /// **'域名'**
  String get domain;

  /// No description provided for @add_port_domain_name.
  ///
  /// In zh, this message translates to:
  /// **'添加端口域名：'**
  String get add_port_domain_name;

  /// No description provided for @configure_the_domain_name_for_this_port.
  ///
  /// In zh, this message translates to:
  /// **'配置该端口的域名'**
  String get configure_the_domain_name_for_this_port;

  /// No description provided for @ports_that_need_to_be_mapped.
  ///
  /// In zh, this message translates to:
  /// **'需要映射的端口'**
  String get ports_that_need_to_be_mapped;

  /// No description provided for @delete_this_http.
  ///
  /// In zh, this message translates to:
  /// **'删除Http'**
  String get delete_this_http;

  /// No description provided for @are_you_sure_to_delete_this_http.
  ///
  /// In zh, this message translates to:
  /// **'确认删除此Http？'**
  String get are_you_sure_to_delete_this_http;

  /// No description provided for @tcp_port_list_title.
  ///
  /// In zh, this message translates to:
  /// **'TCP端口列表'**
  String get tcp_port_list_title;

  /// No description provided for @opening_method.
  ///
  /// In zh, this message translates to:
  /// **'打开方式：'**
  String get opening_method;

  /// No description provided for @my_tcp_port.
  ///
  /// In zh, this message translates to:
  /// **'我的TCP'**
  String get my_tcp_port;

  /// No description provided for @the_port_number_that_the_remote_machine_needs_to_access.
  ///
  /// In zh, this message translates to:
  /// **'远程机器需要访问的端口号'**
  String get the_port_number_that_the_remote_machine_needs_to_access;

  /// No description provided for @domain_notes.
  ///
  /// In zh, this message translates to:
  /// **'不是网站端口请不要修改;不想映射到服务器请不要修改'**
  String get domain_notes;

  /// No description provided for @delete_tcp.
  ///
  /// In zh, this message translates to:
  /// **'删除TCP'**
  String get delete_tcp;

  /// No description provided for @confirm_to_delete_this_tcp.
  ///
  /// In zh, this message translates to:
  /// **'确认删除此TCP?'**
  String get confirm_to_delete_this_tcp;

  /// No description provided for @tcp_port.
  ///
  /// In zh, this message translates to:
  /// **'TCP端口'**
  String get tcp_port;

  /// No description provided for @udp_port.
  ///
  /// In zh, this message translates to:
  /// **'UDP端口'**
  String get udp_port;

  /// No description provided for @ftp_port.
  ///
  /// In zh, this message translates to:
  /// **'FTP端口'**
  String get ftp_port;

  /// No description provided for @http_port.
  ///
  /// In zh, this message translates to:
  /// **'HTTP端口'**
  String get http_port;

  /// No description provided for @service.
  ///
  /// In zh, this message translates to:
  /// **'服务'**
  String get service;

  /// No description provided for @ports.
  ///
  /// In zh, this message translates to:
  /// **'端口'**
  String get ports;

  /// No description provided for @delete_device.
  ///
  /// In zh, this message translates to:
  /// **'删除设备'**
  String get delete_device;

  /// No description provided for @confirm_delete_device.
  ///
  /// In zh, this message translates to:
  /// **'确认删除此设备？'**
  String get confirm_delete_device;

  /// No description provided for @wake_up_device.
  ///
  /// In zh, this message translates to:
  /// **'唤醒设备'**
  String get wake_up_device;

  /// No description provided for @wake_up_device_notes1.
  ///
  /// In zh, this message translates to:
  /// **'第一次使用请选择\'设置物理地址\'，设置过物理地址可以直接点击\'唤醒设备\'。'**
  String get wake_up_device_notes1;

  /// No description provided for @reset_physical_address.
  ///
  /// In zh, this message translates to:
  /// **'重设物理地址'**
  String get reset_physical_address;

  /// No description provided for @set_physical_address.
  ///
  /// In zh, this message translates to:
  /// **'设置物理地址'**
  String get set_physical_address;

  /// No description provided for @physical_address.
  ///
  /// In zh, this message translates to:
  /// **'物理地址'**
  String get physical_address;

  /// No description provided for @the_physical_address_of_the_machine.
  ///
  /// In zh, this message translates to:
  /// **'机器有线网卡的物理地址'**
  String get the_physical_address_of_the_machine;

  /// No description provided for @set.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get set;

  /// No description provided for @device_id.
  ///
  /// In zh, this message translates to:
  /// **'本设备id(简化后)'**
  String get device_id;

  /// No description provided for @gateway_id.
  ///
  /// In zh, this message translates to:
  /// **'内网id(简化后)'**
  String get gateway_id;

  /// No description provided for @addr.
  ///
  /// In zh, this message translates to:
  /// **'地址'**
  String get addr;

  /// No description provided for @copy_successful.
  ///
  /// In zh, this message translates to:
  /// **'复制成功!'**
  String get copy_successful;

  /// No description provided for @device_details.
  ///
  /// In zh, this message translates to:
  /// **'设备详情'**
  String get device_details;

  /// No description provided for @internal_network_devices.
  ///
  /// In zh, this message translates to:
  /// **'内网设备'**
  String get internal_network_devices;

  /// No description provided for @add_device.
  ///
  /// In zh, this message translates to:
  /// **'添加设备'**
  String get add_device;

  /// No description provided for @ip_address_of_remote_intranet.
  ///
  /// In zh, this message translates to:
  /// **'远程内网的IP'**
  String get ip_address_of_remote_intranet;

  /// No description provided for @ip_address_of_internal_network_devices.
  ///
  /// In zh, this message translates to:
  /// **'内网设备的IP'**
  String get ip_address_of_internal_network_devices;

  /// No description provided for @create_device_failed.
  ///
  /// In zh, this message translates to:
  /// **'创建设备失败'**
  String get create_device_failed;

  /// No description provided for @camera_scan_code_prompt.
  ///
  /// In zh, this message translates to:
  /// **'摄像头扫码提示！'**
  String get camera_scan_code_prompt;

  /// No description provided for @camera_scan_code_prompt_content.
  ///
  /// In zh, this message translates to:
  /// **'请注意，点击下方 确定 我们将请求摄像头权限进行扫码'**
  String get camera_scan_code_prompt_content;

  /// No description provided for @select_the_network_where_the_remote_host_is_located.
  ///
  /// In zh, this message translates to:
  /// **'请选择远程主机所在网络'**
  String get select_the_network_where_the_remote_host_is_located;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @udp_port_list_title.
  ///
  /// In zh, this message translates to:
  /// **'UDP端口列表'**
  String get udp_port_list_title;

  /// No description provided for @my_udp_port.
  ///
  /// In zh, this message translates to:
  /// **'我的UDP'**
  String get my_udp_port;

  /// No description provided for @delete_udp.
  ///
  /// In zh, this message translates to:
  /// **'删除UDP'**
  String get delete_udp;

  /// No description provided for @confirm_to_delete_this_udp.
  ///
  /// In zh, this message translates to:
  /// **'确认删除此UDP?'**
  String get confirm_to_delete_this_udp;

  /// No description provided for @please_scan_the_qr_code.
  ///
  /// In zh, this message translates to:
  /// **'请扫码云亿连网关提供的二维码'**
  String get please_scan_the_qr_code;

  /// No description provided for @scan_the_qr_code.
  ///
  /// In zh, this message translates to:
  /// **'扫码二维码'**
  String get scan_the_qr_code;

  /// No description provided for @unsupported_qr_code.
  ///
  /// In zh, this message translates to:
  /// **'不支持的二维码'**
  String get unsupported_qr_code;

  /// No description provided for @unsupported_uri_path.
  ///
  /// In zh, this message translates to:
  /// **'不支持的Uri路径'**
  String get unsupported_uri_path;

  /// No description provided for @adding_gateway_to_my_account_failed.
  ///
  /// In zh, this message translates to:
  /// **'添加网关到我的账户失败'**
  String get adding_gateway_to_my_account_failed;

  /// No description provided for @add_gateway_failed.
  ///
  /// In zh, this message translates to:
  /// **'添加网关失败'**
  String get add_gateway_failed;

  /// No description provided for @add_gateway_successful.
  ///
  /// In zh, this message translates to:
  /// **'添加网关成功！'**
  String get add_gateway_successful;

  /// No description provided for @login_failed.
  ///
  /// In zh, this message translates to:
  /// **'登录失败,请重新登录'**
  String get login_failed;

  /// No description provided for @please_use_the_magnifying_glass_in_the_upper_right_corner.
  ///
  /// In zh, this message translates to:
  /// **'请使用右上角发现网关或者通过扫描二维码添加网关'**
  String get please_use_the_magnifying_glass_in_the_upper_right_corner;

  /// No description provided for @add_a_gateway.
  ///
  /// In zh, this message translates to:
  /// **'添加一个远程网关'**
  String get add_a_gateway;

  /// No description provided for @install_gateway.
  ///
  /// In zh, this message translates to:
  /// **'局域网安装网关'**
  String get install_gateway;

  /// No description provided for @delete_result.
  ///
  /// In zh, this message translates to:
  /// **'删除结果'**
  String get delete_result;

  /// No description provided for @delete_successful.
  ///
  /// In zh, this message translates to:
  /// **'删除成功！'**
  String get delete_successful;

  /// No description provided for @delete_failed.
  ///
  /// In zh, this message translates to:
  /// **'删除失败！'**
  String get delete_failed;

  /// No description provided for @web_browser.
  ///
  /// In zh, this message translates to:
  /// **'网页浏览器'**
  String get web_browser;

  /// No description provided for @mdns_service_list.
  ///
  /// In zh, this message translates to:
  /// **'mdns列表'**
  String get mdns_service_list;

  /// No description provided for @delete_gateway.
  ///
  /// In zh, this message translates to:
  /// **'删除网关'**
  String get delete_gateway;

  /// No description provided for @confirm_delete_gateway.
  ///
  /// In zh, this message translates to:
  /// **'确认删除此网关？'**
  String get confirm_delete_gateway;

  /// No description provided for @after_simplification.
  ///
  /// In zh, this message translates to:
  /// **'简化后'**
  String get after_simplification;

  /// No description provided for @connection_code_simplified.
  ///
  /// In zh, this message translates to:
  /// **'连接码(简化后)'**
  String get connection_code_simplified;

  /// No description provided for @p2p_connection_status.
  ///
  /// In zh, this message translates to:
  /// **'P2P连接状态'**
  String get p2p_connection_status;

  /// No description provided for @modify.
  ///
  /// In zh, this message translates to:
  /// **'修改'**
  String get modify;

  /// No description provided for @gateway_config_notes1.
  ///
  /// In zh, this message translates to:
  /// **'网关的token已经复制到了剪切板！你可以将此token作为网关参数运行或者添加到配置文件：bash>gateway-go -t <你的token>'**
  String get gateway_config_notes1;

  /// No description provided for @gateway_config_notes2.
  ///
  /// In zh, this message translates to:
  /// **'复制网关Token'**
  String get gateway_config_notes2;

  /// No description provided for @gateway_config_notes3.
  ///
  /// In zh, this message translates to:
  /// **'网关的配置文件已经复制到了剪切板！你可以将这个配置内容复制到网关的配置文件(gateway-go.yaml)了'**
  String get gateway_config_notes3;

  /// No description provided for @gateway_config_notes4.
  ///
  /// In zh, this message translates to:
  /// **'复制网关配置内容'**
  String get gateway_config_notes4;

  /// No description provided for @gateway_config_notes5.
  ///
  /// In zh, this message translates to:
  /// **'网络详情'**
  String get gateway_config_notes5;

  /// No description provided for @failed_to_delete_the_configuration_of_the_remote_gateway.
  ///
  /// In zh, this message translates to:
  /// **'删除远程网关的配置失败'**
  String get failed_to_delete_the_configuration_of_the_remote_gateway;

  /// No description provided for @failed_to_delete_mapping_for_local_gateway.
  ///
  /// In zh, this message translates to:
  /// **'删除本地网关的映射失败'**
  String get failed_to_delete_mapping_for_local_gateway;

  /// No description provided for @successfully_deleted_gateway.
  ///
  /// In zh, this message translates to:
  /// **'删除网关成功!'**
  String get successfully_deleted_gateway;

  /// No description provided for @modify_name.
  ///
  /// In zh, this message translates to:
  /// **'修改名称：'**
  String get modify_name;

  /// No description provided for @name.
  ///
  /// In zh, this message translates to:
  /// **'名称'**
  String get name;

  /// No description provided for @please_input_new_name.
  ///
  /// In zh, this message translates to:
  /// **'请输入新的名称'**
  String get please_input_new_name;

  /// No description provided for @privacy_policy.
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get privacy_policy;

  /// No description provided for @agree.
  ///
  /// In zh, this message translates to:
  /// **'同意'**
  String get agree;

  /// No description provided for @feedback_channels.
  ///
  /// In zh, this message translates to:
  /// **'反馈渠道'**
  String get feedback_channels;

  /// No description provided for @if_you_do_not_agree_with_the_privacy_policy_please_click_to_exit_the_application.
  ///
  /// In zh, this message translates to:
  /// **'如果不同意《隐私政策》请点击 退出应用'**
  String
  get if_you_do_not_agree_with_the_privacy_policy_please_click_to_exit_the_application;

  /// No description provided for @exit_the_application.
  ///
  /// In zh, this message translates to:
  /// **'退出应用'**
  String get exit_the_application;

  /// No description provided for @agree_to_the_privacy_policy.
  ///
  /// In zh, this message translates to:
  /// **'同意隐私政策'**
  String get agree_to_the_privacy_policy;

  /// No description provided for @wechat.
  ///
  /// In zh, this message translates to:
  /// **'微信'**
  String get wechat;

  /// No description provided for @tools.
  ///
  /// In zh, this message translates to:
  /// **'工具'**
  String get tools;

  /// No description provided for @skip_ad.
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get skip_ad;

  /// No description provided for @please_add_device_first.
  ///
  /// In zh, this message translates to:
  /// **'请先添加设备'**
  String get please_add_device_first;

  /// No description provided for @failed_to_obtain_the_iot_list_remotely.
  ///
  /// In zh, this message translates to:
  /// **'从远程获取物联网列表失败'**
  String get failed_to_obtain_the_iot_list_remotely;

  /// No description provided for @failure_reason.
  ///
  /// In zh, this message translates to:
  /// **'失败原因'**
  String get failure_reason;

  /// No description provided for @add_mqtt_devices.
  ///
  /// In zh, this message translates to:
  /// **'添加mqtt设备'**
  String get add_mqtt_devices;

  /// No description provided for @add_zip_devices.
  ///
  /// In zh, this message translates to:
  /// **'添加zip的设备(zDC1,zTC1...)'**
  String get add_zip_devices;

  /// No description provided for @device_list.
  ///
  /// In zh, this message translates to:
  /// **'设备列表'**
  String get device_list;

  /// No description provided for @add_device_to_opneiothub.
  ///
  /// In zh, this message translates to:
  /// **'添加设备到云亿连'**
  String get add_device_to_opneiothub;

  /// No description provided for @are_you_sure_to_add_this_device_to_openiothub.
  ///
  /// In zh, this message translates to:
  /// **'确认添加该设备到云亿连？'**
  String get are_you_sure_to_add_this_device_to_openiothub;

  /// No description provided for @you_havent_logged_in_yet.
  ///
  /// In zh, this message translates to:
  /// **'您还没有登录!请先登录再添加设备'**
  String get you_havent_logged_in_yet;

  /// No description provided for @add_successful.
  ///
  /// In zh, this message translates to:
  /// **'添加成功!'**
  String get add_successful;

  /// No description provided for @please_add_host_first.
  ///
  /// In zh, this message translates to:
  /// **'请先添加主机'**
  String get please_add_host_first;

  /// No description provided for @no_more_prompts_next_time.
  ///
  /// In zh, this message translates to:
  /// **'下次不再提示：'**
  String get no_more_prompts_next_time;

  /// No description provided for @network_protocol.
  ///
  /// In zh, this message translates to:
  /// **'网络协议'**
  String get network_protocol;

  /// No description provided for @application_protocol.
  ///
  /// In zh, this message translates to:
  /// **'应用协议'**
  String get application_protocol;

  /// No description provided for @confirm_add_gateway.
  ///
  /// In zh, this message translates to:
  /// **'确认添加次网关到账户？'**
  String get confirm_add_gateway;

  /// No description provided for @ok.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get ok;

  /// No description provided for @choose_an_network.
  ///
  /// In zh, this message translates to:
  /// **'选择一个远程网络'**
  String get choose_an_network;

  /// No description provided for @choose_an_host_address.
  ///
  /// In zh, this message translates to:
  /// **'选择一个远程主机地址'**
  String get choose_an_host_address;

  /// No description provided for @fill_in_below.
  ///
  /// In zh, this message translates to:
  /// **'不选择，下面填写'**
  String get fill_in_below;

  /// No description provided for @user_guide.
  ///
  /// In zh, this message translates to:
  /// **'新手引导'**
  String get user_guide;

  /// No description provided for @register_login.
  ///
  /// In zh, this message translates to:
  /// **'注册登录'**
  String get register_login;

  /// No description provided for @register_login_content.
  ///
  /// In zh, this message translates to:
  /// **'点击下方按钮开始注册登录'**
  String get register_login_content;

  /// No description provided for @add_gateway.
  ///
  /// In zh, this message translates to:
  /// **'添加网关'**
  String get add_gateway;

  /// No description provided for @add_gateway_content.
  ///
  /// In zh, this message translates to:
  /// **'从下方两个按钮任选其一选择扫码添加网关还是局域网发现添加网关'**
  String get add_gateway_content;

  /// No description provided for @add_host.
  ///
  /// In zh, this message translates to:
  /// **'添加主机'**
  String get add_host;

  /// No description provided for @add_host_content.
  ///
  /// In zh, this message translates to:
  /// **'点击下方按钮跳转到主机列表页面，\n点击右下角按钮开始添加远程主机'**
  String get add_host_content;

  /// No description provided for @add_ports.
  ///
  /// In zh, this message translates to:
  /// **'添加端口'**
  String get add_ports;

  /// No description provided for @add_ports_content.
  ///
  /// In zh, this message translates to:
  /// **'点击下方按钮跳转到主机列表页面，\n点击需要添加端口的主机，在主机上添加端口'**
  String get add_ports_content;

  /// No description provided for @access_ports.
  ///
  /// In zh, this message translates to:
  /// **'访问端口'**
  String get access_ports;

  /// No description provided for @access_ports_content.
  ///
  /// In zh, this message translates to:
  /// **'点击下方按钮跳转到主机列表页面，\n点击主机进入端口列表页面，\n点击任意端口访问远程端口(可能需要选择访问方式)'**
  String get access_ports_content;

  /// No description provided for @last_step.
  ///
  /// In zh, this message translates to:
  /// **'上一步'**
  String get last_step;

  /// No description provided for @next_step.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get next_step;

  /// No description provided for @skip_this_guide.
  ///
  /// In zh, this message translates to:
  /// **'跳过本指导'**
  String get skip_this_guide;

  /// No description provided for @open_the_port.
  ///
  /// In zh, this message translates to:
  /// **'打开端口'**
  String get open_the_port;

  /// No description provided for @add_port_button.
  ///
  /// In zh, this message translates to:
  /// **'添加端口'**
  String get add_port_button;

  /// No description provided for @open_gateway_guide.
  ///
  /// In zh, this message translates to:
  /// **'打开网关软件主页'**
  String get open_gateway_guide;

  /// No description provided for @remote_lan_browser.
  ///
  /// In zh, this message translates to:
  /// **'远程局域网浏览器'**
  String get remote_lan_browser;
}

class _OpenIoTHubLocalizationsDelegate
    extends LocalizationsDelegate<OpenIoTHubLocalizations> {
  const _OpenIoTHubLocalizationsDelegate();

  @override
  Future<OpenIoTHubLocalizations> load(Locale locale) {
    return SynchronousFuture<OpenIoTHubLocalizations>(
      lookupOpenIoTHubLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_OpenIoTHubLocalizationsDelegate old) => false;
}

OpenIoTHubLocalizations lookupOpenIoTHubLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return OpenIoTHubLocalizationsZhHans();
          case 'Hant':
            return OpenIoTHubLocalizationsZhHant();
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
            return OpenIoTHubLocalizationsZhCn();
          case 'TW':
            return OpenIoTHubLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return OpenIoTHubLocalizationsEn();
    case 'zh':
      return OpenIoTHubLocalizationsZh();
  }

  throw FlutterError(
    'OpenIoTHubLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
