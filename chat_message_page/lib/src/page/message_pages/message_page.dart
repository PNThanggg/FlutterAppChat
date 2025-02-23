import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  final VRoom vRoom;
  final MessageConfig vMessageConfig;
  final VMessageLocalization localization;

  const MessagePage({
    super.key,
    required this.localization,
    required this.vRoom,
    required this.vMessageConfig,
  });

  @override
  Widget build(BuildContext context) {
    return _child(context);
  }

  Widget _child(BuildContext context) {
    switch (vRoom.roomType) {
      case VRoomType.s:
        return SingleView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
          language: localization,
        );
      case VRoomType.g:
        return VGroupView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
          language: localization,
        );
      case VRoomType.b:
        return BroadcastView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
          language: localization,
        );
      case VRoomType.o:
        return OrderView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
          language: localization,
        );
    }
  }
}
