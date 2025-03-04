import 'dart:async';
import 'dart:ui' as ui;

import 'package:chat_config/chat_preferences.dart';
import 'package:flutter/cupertino.dart';

class VLanguageListener extends ValueNotifier<Locale> {
  VLanguageListener._() : super(const Locale("en"));

  static final _instance = VLanguageListener._();

  static VLanguageListener get I {
    return _instance;
  }

  Future setLocal(Locale locale) async {
    await ChatPreferences.setStringKey(
      SStorageKeys.appLanguageCode.name,
      locale.languageCode,
    );

    value = locale;
  }

  Locale get appLocal {
    final prefLang = ChatPreferences.getStringOrNullKey(
      SStorageKeys.appLanguageCode.name,
    );
    if (prefLang == null) {
      unawaited(
        ChatPreferences.setStringKey(
          SStorageKeys.appLanguageTitle.name,
          deviceLocal.languageCode,
        ),
      );
      unawaited(setLocal(deviceLocal));
      return deviceLocal;
    }
    final split = prefLang.split("_");
    if (split.length == 1) {
      return Locale(split.first);
    } else {
      return Locale(split.first, split.last);
    }
  }

  Locale get deviceLocal => ui.window.locale;
}
