import 'package:chat_core/chat_core.dart';
import 'package:flutter/cupertino.dart';

class MessageTypingWidget extends StatelessWidget {
  final String text;

  const MessageTypingWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return text.text.color(CupertinoColors.systemGreen).size(12);
  }
}
