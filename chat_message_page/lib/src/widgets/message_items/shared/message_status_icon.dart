import 'package:chat_message_page/chat_message_page.dart';
import 'package:flutter/material.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

class MessageStatusIconDataModel {
  final bool isMeSender;
  final bool isSeen;
  final bool isDeliver;
  final bool isAllDeleted;
  final VMessageEmitStatus emitStatus;

  const MessageStatusIconDataModel({
    required this.isMeSender,
    required this.isSeen,
    required this.isDeliver,
    this.isAllDeleted = false,
    required this.emitStatus,
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
    final themeData = context.vMessageTheme.messageSendingStatus;
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
      padding: const EdgeInsets.only(right: 0),
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
            if (onReSend != null) {
              onReSend!();
            }
          },
          child: themeData.refreshIcon,
        );
      case VMessageEmitStatus.sending:
        return themeData.pendingIcon;
    }
  }
}
