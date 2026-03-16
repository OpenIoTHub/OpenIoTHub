import 'dart:io';

final Map<String, String> _domainIpMap = Map();

Future<String> getIpByDomain(String domain) async {
  if (_domainIpMap.containsKey(domain)) {
    return _domainIpMap[domain]!;
  }
  String ipStr = "";
  try {
    // 使用 lookup 方法解析域名
    List<InternetAddress> addresses = await InternetAddress.lookup(domain);
    print('IP addresses for $domain:');
    addresses.forEach((address) {
      // TODO 缓存并且提高速度
      ipStr = address.address;
      _domainIpMap[domain] = ipStr;
    });
  } catch (e) {
    print('Error looking up $domain: $e');
  }
  return ipStr;
}
