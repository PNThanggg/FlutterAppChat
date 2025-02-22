import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const SElevatedButton({
    super.key,
    required this.title,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      activeOpacity: 0.2,
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: context.isDark ? Colors.white24 : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: title.text.medium.size(16).color(Colors.white),
      ),
    );
  }
}
