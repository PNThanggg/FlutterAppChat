import 'package:app_badger/app_badger.dart';
import 'package:app_badger/app_badger_method_channel.dart';
import 'package:app_badger/app_badger_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppBadgerPlatform with MockPlatformInterfaceMixin implements AppBadgerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> isAppBadgeSupported() {
    throw UnimplementedError();
  }

  @override
  Future<void> removeBadge() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateBadgeCount(int count) {
    throw UnimplementedError();
  }
}

void main() {
  final AppBadgerPlatform initialPlatform = AppBadgerPlatform.instance;

  test('$MethodChannelAppBadger is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppBadger>());
  });

  test('getPlatformVersion', () async {
    MockAppBadgerPlatform fakePlatform = MockAppBadgerPlatform();
    AppBadgerPlatform.instance = fakePlatform;

    expect(await AppBadger.getPlatformVersion(), '42');
  });
}
