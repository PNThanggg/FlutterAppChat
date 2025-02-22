import 'package:chat_message_page/src/theme/theme.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';

class AllDeletedItem extends StatelessWidget {
  final VBaseMessage message;
  final String messageHasBeenDeletedLabel;

  const AllDeletedItem({
    super.key,
    required this.message,
    required this.messageHasBeenDeletedLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Text(
        messageHasBeenDeletedLabel,
        style: message.isMeSender
            ? context.vMessageTheme.senderTextStyle.merge(
                const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              )
            : context.vMessageTheme.receiverTextStyle.merge(
                const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
      ),
    );
  }
}
