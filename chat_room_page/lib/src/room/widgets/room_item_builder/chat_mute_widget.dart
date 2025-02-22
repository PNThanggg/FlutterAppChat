import 'package:chat_room_page/chat_room_page.dart';
import 'package:flutter/cupertino.dart';

class ChatMuteWidget extends StatelessWidget {
  /// Flag indicating whether the current chat is muted.
  final bool isMuted;

  /// Creates a new instance of [ChatMuteWidget].
  const ChatMuteWidget({super.key, required this.isMuted});

  @override
  Widget build(BuildContext context) {
    if (!isMuted) {
      return const SizedBox.shrink();
    }

    return context.vRoomTheme.muteIcon;
  }
}
