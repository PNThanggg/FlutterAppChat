import 'package:chat_core/chat_core.dart';
import 'package:flutter/cupertino.dart';

class ChatTypingWidget extends StatelessWidget {
  /// The text to be displayed along with the typing indicator.
  final String text;

  /// Creates a [ChatTypingWidget] widget.
  const ChatTypingWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return text.text.color(CupertinoColors.systemGreen);
  }
}
