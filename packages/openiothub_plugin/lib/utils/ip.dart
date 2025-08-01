import 'dart:io';

final Map<String, String> _domain_ip_map = Map();

Future<String> get_ip_by_domain(String domain) async {
  if (_domain_ip_map.containsKey(domain)) {
    return _domain_ip_map[domain]!;
  }
  String ip_str = "";
  try {
    // 使用 lookup 方法解析域名
    List<InternetAddress> addresses = await InternetAddress.lookup(domain);
    print('IP addresses for $domain:');
    addresses.forEach((address) {
      // TODO 缓存并且提高速度
      ip_str = address.address;
      _domain_ip_map[domain] = ip_str;
    });
  } catch (e) {
    print('Error looking up $domain: $e');
  }
  return ip_str;
}
