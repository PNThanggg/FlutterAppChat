import 'dart:async';

import 'package:chat_config/chat_preferences.dart';
import 'package:flutter/material.dart';

class VThemeListener extends ValueNotifier<ThemeMode> {
  VThemeListener._() : super(ThemeMode.system);

  static final _instance = VThemeListener._();

  static VThemeListener get I {
    return _instance;
  }

  Future setTheme(ThemeMode themeMode) async {
    await ChatPreferences.setStringKey(
      SStorageKeys.appTheme.name,
      themeMode.name,
    );
    value = themeMode;
  }

  ThemeMode get appTheme {
    final prefTheme = ChatPreferences.getStringOrNullKey(
      SStorageKeys.appTheme.name,
    );
    if (prefTheme == null) {
      unawaited(setTheme(themeLocal));
      return themeLocal;
    }
    return ThemeMode.values.byName(prefTheme);
  }

  ThemeMode get themeLocal => ThemeMode.system;
}
