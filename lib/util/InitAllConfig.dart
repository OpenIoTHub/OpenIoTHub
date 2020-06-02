import 'package:modules/api/OpenIoTHub/SessionApi.dart';

Future<void> InitAllConfig() {
  SessionApi.loadSessions();
}