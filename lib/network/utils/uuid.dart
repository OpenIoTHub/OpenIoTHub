import 'package:uuid/uuid.dart';

String getOneUUID() {
  final uuid = Uuid();
  return uuid.v4();
}
