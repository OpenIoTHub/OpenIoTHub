bool isIp(String ip) {
  final pattern = RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$');
  return pattern.hasMatch(ip);
}
