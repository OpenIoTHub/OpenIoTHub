import 'package:uuid/uuid.dart';

String getOneUUID() {
  var uuid = new Uuid();
  return uuid.v4();
}
