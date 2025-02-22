import 'package:chat_room_page/chat_room_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';

class MessageStatusIconDataModel {
  /// Whether the message was sent by the current user.
  final bool isMeSender;

  /// Whether the message has been seen.
  final bool isSeen;

  /// Whether the message has been delivered.
  final bool isDeliver;

  /// Whether all copies of the message have been deleted. Default value is false.
  final bool isAllDeleted;

  /// The current emit status of the message.
  final VMessageEmitStatus emitStatus;

  /// Constructs a new instance of [MessageStatusIconDataModel].
  const MessageStatusIconDataModel({
    required this.isMeSender,
    required this.isSeen,
    required this.isDeliver,
    required this.emitStatus,
    this.isAllDeleted = false,
  });
}

class MessageStatusIcon extends StatelessWidget {
  final VoidCallback? onReSend;
  final MessageStatusIconDataModel model;

  const MessageStatusIcon({
    super.key,
    required this.model,
    this.onReSend,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.vRoomTheme.lastMessageStatus;
    if (!model.isMeSender || model.isAllDeleted) {
      return const SizedBox.shrink();
    }
    if (model.isSeen) {
      return _getBody(themeData.seenIcon);
    }
    if (model.isDeliver) {
      return _getBody(themeData.deliverIcon);
    }
    return _getBody(
      _getIcon(themeData),
    );
  }

  Widget _getBody(Widget icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: icon,
    );
  }

  Widget _getIcon(VMsgStatusTheme themeData) {
    switch (model.emitStatus) {
      case VMessageEmitStatus.serverConfirm:
        return themeData.sendIcon;
      case VMessageEmitStatus.error:
        return GestureDetector(
          onTap: () {
            onReSend?.call();
          },
          child: themeData.refreshIcon,
        );
      case VMessageEmitStatus.sending:
        return themeData.pendingIcon;
    }
  }
}
