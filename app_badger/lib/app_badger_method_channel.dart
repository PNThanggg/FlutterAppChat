import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_badger_platform_interface.dart';

/// An implementation of [AppBadgerPlatform] that uses method channels.
class MethodChannelAppBadger extends AppBadgerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_badger');

  @override
  Future<String?> getPlatformVersion() async {
    try {
      final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
      return version;
    } catch (e) {
      log('Error getting platform version: $e');
      return null;
    }
  }

  @override
  Future<bool> isAppBadgeSupported() async {
    try {
      bool? appBadgeSupported = await methodChannel.invokeMethod('isAppBadgeSupported');
      return appBadgeSupported ?? false;
    } on PlatformException catch (e) {
      log(
        'PlatformException in isAppBadgeSupported: ${e.message}',
        name: 'MethodChannelAppBadger',
        error: e,
      );
      return false;
    } catch (e) {
      log(
        'Unexpected error in isAppBadgeSupported: $e',
        name: 'MethodChannelAppBadger',
        error: e,
      );
      return false;
    }
  }

  @override
  Future<void> removeBadge() async {
    try {
      await methodChannel.invokeMethod('removeBadge');
    } on PlatformException catch (e) {
      log(
        'PlatformException in removeBadge: ${e.message}',
        name: 'MethodChannelAppBadger',
        error: e,
      );
      rethrow;
    } catch (e) {
      log(
        'Unexpected error in removeBadge: $e',
        name: 'MethodChannelAppBadger',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<void> updateBadgeCount(int count) async {
    try {
      await methodChannel.invokeMethod(
        'updateBadgeCount',
        {
          "count": count,
        },
      );
    } on PlatformException catch (e) {
      log(
        'PlatformException in updateBadgeCount: ${e.message}',
        name: 'MethodChannelAppBadger',
        error: e,
      );
      rethrow;
    } catch (e) {
      log(
        'Unexpected error in updateBadgeCount: $e',
        name: 'MethodChannelAppBadger',
        error: e,
      );
      rethrow;
    }
  }
}
