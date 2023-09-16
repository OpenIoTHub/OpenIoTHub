// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_title": MessageLookupByLibrary.simpleMessage("OpenIoTHub"),
        "profile_about_this_app":
            MessageLookupByLibrary.simpleMessage("About this App"),
        "profile_click_avatar_to_sign_in":
            MessageLookupByLibrary.simpleMessage("Click avatar to sign in"),
        "profile_docs": MessageLookupByLibrary.simpleMessage("Docs"),
        "profile_not_logged_in":
            MessageLookupByLibrary.simpleMessage("Not logged in"),
        "profile_servers": MessageLookupByLibrary.simpleMessage("My Servers"),
        "profile_settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "profile_tools": MessageLookupByLibrary.simpleMessage("Tools"),
        "tab_gateway": MessageLookupByLibrary.simpleMessage("gateway"),
        "tab_host": MessageLookupByLibrary.simpleMessage("host"),
        "tab_smart": MessageLookupByLibrary.simpleMessage("smart"),
        "tab_user": MessageLookupByLibrary.simpleMessage("user")
      };
}
