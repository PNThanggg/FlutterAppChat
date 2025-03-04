import 'package:chat_platform/v_platform.dart';
import 'package:permission_handler/permission_handler.dart';

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
      final st = await Permission.camera.request();
      return st == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  static Future<bool> askForRecord() async {
    if (VPlatforms.isMobile || VPlatforms.isWindows) {
      final st = await Permission.microphone.request();
      return st == PermissionStatus.granted;
    }
    return true;
  }
}
