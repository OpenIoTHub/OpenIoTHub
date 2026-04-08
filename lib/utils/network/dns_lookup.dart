import 'dart:io';

import 'package:flutter/foundation.dart';

final Map<String, String> _domainIpMap = {};

Future<String> getIpByDomain(String domain) async {
  if (_domainIpMap.containsKey(domain)) {
    return _domainIpMap[domain]!;
  }
  String ipStr = "";
  try {
    // 使用 lookup 方法解析域名
    List<InternetAddress> addresses = await InternetAddress.lookup(domain);
    debugPrint('IP addresses for $domain:');
    for (final address in addresses) {
      // TODO 缓存并且提高速度
      ipStr = address.address;
      _domainIpMap[domain] = ipStr;
    }
  } catch (e) {
    debugPrint('Error looking up $domain: $e');
  }
  return ipStr;
}
