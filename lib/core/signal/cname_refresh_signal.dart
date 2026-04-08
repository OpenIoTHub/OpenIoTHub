import 'package:flutter/foundation.dart';

/// 设备别名写入本地缓存后发出通知（含 [CnameManager.loadAllCnameFromRemote]、[CnameManager.setCname]），
/// 供列表等仅更新展示名（读 [SharedPreferences]，不打远程）。
final class CnameRefreshSignal extends ChangeNotifier {
  CnameRefreshSignal._();
  static final CnameRefreshSignal instance = CnameRefreshSignal._();

  void notifyCnamesSynced() => notifyListeners();
}
