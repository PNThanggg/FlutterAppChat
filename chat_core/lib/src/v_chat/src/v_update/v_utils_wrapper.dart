import 'package:flutter/material.dart';
import 'package:chat_core/chat_core.dart';

class VUtilsWrapper extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    ThemeMode themeMode,
  ) builder;

  const VUtilsWrapper({
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: VThemeListener.I,
      builder: (context, values, _) {
        return builder(
          context,
          VThemeListener.I.appTheme,
        );
      },
    );
  }
}
