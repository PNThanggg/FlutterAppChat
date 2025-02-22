import 'package:chat_config/chat_preferences.dart';

import '../model.dart';

abstract class AppAuth {
  static MyProfile? _profile;

  static void setProfileNull() {
    _profile = null;
  }

  static MyProfile get myProfile {
    if (_profile != null) {
      return _profile!;
    }
    final map = ChatPreferences.getMap(SStorageKeys.myProfile.name);
    if (map == null) throw 'user is not logged in';
    final x = MyProfile.fromMap(map);
    _profile = x;
    return _profile!;
  }

  static String get myId => myProfile.baseUser.id;
}
