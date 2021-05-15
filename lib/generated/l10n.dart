// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `OpenIoTHub`
  String get app_title {
    return Intl.message(
      'OpenIoTHub',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `smart`
  String get tab_smart {
    return Intl.message(
      'smart',
      name: 'tab_smart',
      desc: '',
      args: [],
    );
  }

  /// `gateway`
  String get tab_gateway {
    return Intl.message(
      'gateway',
      name: 'tab_gateway',
      desc: '',
      args: [],
    );
  }

  /// `host`
  String get tab_host {
    return Intl.message(
      'host',
      name: 'tab_host',
      desc: '',
      args: [],
    );
  }

  /// `user`
  String get tab_user {
    return Intl.message(
      'user',
      name: 'tab_user',
      desc: '',
      args: [],
    );
  }

  /// `Not logged in`
  String get profile_not_logged_in {
    return Intl.message(
      'Not logged in',
      name: 'profile_not_logged_in',
      desc: '',
      args: [],
    );
  }

  /// `Click avatar to sign in`
  String get profile_click_avatar_to_sign_in {
    return Intl.message(
      'Click avatar to sign in',
      name: 'profile_click_avatar_to_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get profile_settings {
    return Intl.message(
      'Settings',
      name: 'profile_settings',
      desc: '',
      args: [],
    );
  }

  /// `Tools`
  String get profile_tools {
    return Intl.message(
      'Tools',
      name: 'profile_tools',
      desc: '',
      args: [],
    );
  }

  /// `Docs`
  String get profile_docs {
    return Intl.message(
      'Docs',
      name: 'profile_docs',
      desc: '',
      args: [],
    );
  }

  /// `About this App`
  String get profile_about_this_app {
    return Intl.message(
      'About this App',
      name: 'profile_about_this_app',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}