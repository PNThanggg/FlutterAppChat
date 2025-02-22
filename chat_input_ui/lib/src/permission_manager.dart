import 'package:permission_handler/permission_handler.dart';
import 'package:chat_platform/v_platform.dart';

abstract class PermissionManager {
  static Future<bool> isAllowRecord() async {
    if (VPlatforms.isMobile || VPlatforms.isWindows) {
      return Permission.microphone.isGranted;
    }
    return true;
  }

  static Future<bool> isCameraAllowed() async {
    if (VPlatforms.isMobile || VPlatforms.isWindows) {
      return Permission.camera.isGranted;
    }
    return true;
  }

  static Future<bool> askForCamera() async {
    if (VPlatforms.isMobile || VPlatforms.isWindows) {
      final status = await Permission.camera.request();
      return status == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  static Future<bool> askForRecord() async {
    if (VPlatforms.isMobile || VPlatforms.isWindows) {
      final status = await Permission.microphone.request();
      return status == PermissionStatus.granted;
    }
    return true;
  }
}
