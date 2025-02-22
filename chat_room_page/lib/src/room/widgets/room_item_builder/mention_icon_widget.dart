import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

class MentionIcon extends StatelessWidget {
  const MentionIcon({
    super.key,
    required this.mentionsCount,
    required this.isMeSender,
  });

  final int mentionsCount;
  final bool isMeSender;

  @override
  Widget build(BuildContext context) {
    if (mentionsCount == 0 || isMeSender) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: '@$mentionsCount'.text.color(Colors.green).bold,
    );
  }
}
