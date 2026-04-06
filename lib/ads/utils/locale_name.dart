// 根据语言/地区标签判断是否为中国大陆常用 locale（与系统/应用语言相关，非物理定位）。
// 典型输入：OpenIoTHubLocalizations.localeName（经 Intl.canonicalizedLocale）。
bool isCnMainland(String lang) {
  if (lang.isEmpty) return false;
  final parts = lang.replaceAll('-', '_').toLowerCase().split('_');
  if (parts.isEmpty || parts.first != 'zh') return false;

  var hasCn = false;
  var hasHans = false;
  var hasHant = false;
  for (var i = 1; i < parts.length; i++) {
    switch (parts[i]) {
      case 'tw':
      case 'hk':
      case 'mo':
        return false;
      case 'cn':
        hasCn = true;
        break;
      case 'hans':
        hasHans = true;
        break;
      case 'hant':
        hasHant = true;
        break;
    }
  }
  if (hasHant) return false;
  if (hasCn || hasHans) return true;
  // 仅 `zh`、无地区/脚本子标签时的历史兼容（泛用中文）
  return parts.length == 1;
}
