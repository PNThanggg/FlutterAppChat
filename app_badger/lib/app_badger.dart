import 'app_badger_platform_interface.dart';

abstract class AppBadger {
  const AppBadger();

  static Future<String?> getPlatformVersion() {
    return AppBadgerPlatform.instance.getPlatformVersion();
  }

  static Future<bool> isAppBadgeSupported() {
    return AppBadgerPlatform.instance.isAppBadgeSupported();
  }

  static Future<void> removeBadge() {
    return AppBadgerPlatform.instance.removeBadge();
  }

  static Future<void> updateBadgeCount(int count) {
    return AppBadgerPlatform.instance.updateBadgeCount(count);
  }
}
