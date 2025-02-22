import 'package:flutter/material.dart';
import 'package:chat_core/chat_core.dart';

BoxDecoration sMessageBackground({
  required bool isDark,
}) {
  if (isDark) {
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/message/pattern_dark.png"),
        repeat: ImageRepeat.repeat,
        colorFilter: ColorFilter.mode(
          Colors.black,
          BlendMode.color,
        ),
      ),
    );
  }
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/message/pattern_light.png"),
      repeat: ImageRepeat.repeat,
      colorFilter: ColorFilter.mode(
        Colors.transparent,
        BlendMode.color,
      ),
    ),
  );
}

abstract class AppAuth {
  static SMyProfile? _profile;

  static void setProfileNull() {
    _profile = null;
  }

  static SMyProfile get myProfile {
    if (_profile != null) {
      return _profile!;
    }
    final map = VAppPref.getMap(SStorageKeys.myProfile.name);
    if (map == null) throw 'user is not logged in';
    final x = SMyProfile.fromMap(map);
    _profile = x;
    return _profile!;
  }

  static String get myId => myProfile.baseUser.id;
}
