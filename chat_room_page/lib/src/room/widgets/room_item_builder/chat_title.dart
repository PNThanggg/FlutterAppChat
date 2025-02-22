import 'package:chat_room_page/chat_room_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatTitle extends StatelessWidget {
  /// The title of the chat.
  final String title;

  /// Creates a [ChatTitle] widget.
  const ChatTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return context.vRoomTheme.getChatTitle(title);
  }
}
