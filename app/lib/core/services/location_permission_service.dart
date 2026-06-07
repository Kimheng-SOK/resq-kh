import 'package:permission_handler/permission_handler.dart';

class LocationPermissionService {
  static Future<bool> ensurePermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    status = await Permission.location.request();

    return status.isGranted;
  }
}
