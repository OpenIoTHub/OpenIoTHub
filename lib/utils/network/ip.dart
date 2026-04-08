bool isIp(String ip) {
  final pattern = RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$');
  final match = pattern.firstMatch(ip);

  if (match == null) {
    return false;
  }else{
    return true;
  }
}