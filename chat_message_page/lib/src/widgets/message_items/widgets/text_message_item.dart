import 'package:flutter/material.dart';

import '../../../../v_chat_message_page.dart';

class TextMessageItem extends StatelessWidget {
  final String message;
  final TextStyle textStyle;
  final Function(String email) onEmailPress;
  final Function(BuildContext context, String userId) onMentionPress;
  final Function(String phone) onPhonePress;
  final Function(String link) onLinkPress;

  const TextMessageItem({
    super.key,
    required this.message,
    required this.textStyle,
    required this.onEmailPress,
    required this.onMentionPress,
    required this.onPhonePress,
    required this.onLinkPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6).copyWith(
        top: 4,
      ),
      child: VTextParserWidget(
        text: message,
        textStyle: textStyle.copyWith(letterSpacing: -0.2),
        enableTabs: true,
        mentionTextStyle: const TextStyle(color: Colors.blue),
        onEmailPress: onEmailPress,
        onLinkPress: onLinkPress,
        onPhonePress: onPhonePress,
        onMentionPress: (userId) => onMentionPress(context, userId),
      ),
    );
  }
}
