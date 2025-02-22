import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';

import '../../../chat_message_page.dart';

class VMessagePage extends StatelessWidget {
  final VRoom vRoom;
  final VMessageConfig vMessageConfig;
  final VMessageLocalization localization;

  const VMessagePage({
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
        return VSingleView(
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
        return VBroadcastView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
          language: localization,
        );
      case VRoomType.o:
        return VOrderView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
          language: localization,
        );
    }
  }
}
