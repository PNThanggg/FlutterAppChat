import 'package:chat_platform/v_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension MediaQueryExt2 on BuildContext {
  bool get isDark => CupertinoTheme.of(this).brightness == Brightness.dark;

  CupertinoTextThemeData get cupertinoTextTheme => CupertinoTheme.of(this).textTheme;

  Future<T?> toPage<T>(Widget page) {
    return Navigator.push(
      this,
      VPlatforms.isIOS
          ? CupertinoPageRoute(
              builder: (context) => page,
            )
          : MaterialPageRoute(
              builder: (context) => page,
            ),
    );
  }

  bool get isRtl => Directionality.of(this).name.toLowerCase() == "rtl";
}
