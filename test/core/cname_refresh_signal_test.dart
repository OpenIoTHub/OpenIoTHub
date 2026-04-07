import 'package:flutter_test/flutter_test.dart';
import 'package:openiothub/core/cname_refresh_signal.dart';

void main() {
  test('notifyCnamesSynced invokes listeners', () {
    var calls = 0;
    void listener() => calls++;
    final signal = CnameRefreshSignal.instance;
    signal.addListener(listener);
    signal.notifyCnamesSynced();
    expect(calls, 1);
    signal.removeListener(listener);
    signal.notifyCnamesSynced();
    expect(calls, 1);
  });
}
