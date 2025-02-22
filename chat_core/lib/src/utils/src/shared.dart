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

