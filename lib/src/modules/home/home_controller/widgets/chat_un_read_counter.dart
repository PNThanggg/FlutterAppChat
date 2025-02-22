import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart' hide Badge;

/// A widget that represents the un-read count of chats.
/// This widget can be used to display the number of un-read chats, typically
/// used in a messaging app. The [unReadCount] property is required to set the
/// number of un-read chats to be displayed.
class ChatUnReadWidget extends StatelessWidget {
  /// The number of un-read chats to be displayed.
  final int unReadCount;
  final int height;
  final int width;

  /// Creates a new instance of [ChatUnReadWidget].
  /// The [unReadCount] property is required to set the number of un-read
  /// chats to be displayed.
  const ChatUnReadWidget({
    super.key,
    required this.unReadCount,
    this.height = 17,
    this.width = 17,
  });

  @override
  Widget build(BuildContext context) {
    if (unReadCount == 0) {
      return const SizedBox.shrink();
    }

    return FittedBox(
      child: Container(
        height: height.toDouble(),
        padding: EdgeInsets.zero,
        width: width.toDouble(),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        child: unReadCount.toString().text.size(8).color(Colors.white),
      ),
    );
  }
}
