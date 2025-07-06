import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  if (await Permission.locationWhenInUse.request().isGranted) {
    return true;
  } else {
    return false;
  }
}
