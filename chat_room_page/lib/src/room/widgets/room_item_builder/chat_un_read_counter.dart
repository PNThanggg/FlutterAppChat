import 'package:chat_core/chat_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;

class ChatUnReadWidget extends StatelessWidget {
  final int unReadCount;

  const ChatUnReadWidget({
    super.key,
    required this.unReadCount,
  });

  @override
  Widget build(BuildContext context) {
    if (unReadCount == 0) {
      return const SizedBox.shrink();
    }

    return FittedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 4,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBlue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
        ),
        child: "$unReadCount".text.size(12).color(Colors.white).semiBold,
      ),
    );
  }
}
