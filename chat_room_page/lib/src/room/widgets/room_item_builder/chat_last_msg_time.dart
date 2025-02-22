import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatLastMsgTime extends StatelessWidget {
  /// The [DateTime] object representing the last time a message was sent in a chat.
  final DateTime lastMessageTime;
  final String yesterdayLabel;

  /// Creates a new instance of [ChatLastMsgTime].
  const ChatLastMsgTime({
    super.key,
    required this.lastMessageTime,
    required this.yesterdayLabel,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();
    final difference = now.difference(lastMessageTime).inDays;
    final TextStyle? txtStyle = context.textTheme.bodyLarge?.copyWith(
      fontSize: 12,
      color: Colors.grey,
    );
    if (difference == 0) {
      //same day
      return DateFormat.jm(Localizations.localeOf(context).languageCode)
          .format(lastMessageTime)
          .text
          .styled(style: txtStyle);
    }
    if (difference == 1) {
      return yesterdayLabel.text.styled(style: txtStyle);
    }
    if (difference <= 7) {
      return DateFormat.E(Localizations.localeOf(context).languageCode)
          .format(lastMessageTime)
          .text
          .styled(style: txtStyle);
    }
    return DateFormat("dd/MM/yyyy").format(lastMessageTime).text.styled(style: txtStyle);
  }
}
