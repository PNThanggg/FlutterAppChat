import 'package:chat_core/chat_core.dart';
import 'package:chat_room_page/chat_room_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart' hide VMessageConstants;
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/material.dart';

class RoomItemMsg extends StatelessWidget {
  /// The message to be displayed.
  final bool isBold;
  final String messageHasBeenDeletedLabel;

  /// Determines if the message should be displayed in bold text.
  final VBaseMessage message;

  /// Creates a [RoomItemMsg] widget.
  const RoomItemMsg({
    super.key,
    required this.message,
    required this.isBold,
    required this.messageHasBeenDeletedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.vRoomTheme;
    final language = VMessageInfoTrans(
      addedYouToNewBroadcast: S.of(context).addedYouToNewBroadcast,
      dismissedToMemberBy: S.of(context).dismissedToMemberBy,
      groupCreatedBy: S.of(context).groupCreatedBy,
      joinedBy: S.of(context).joinedBy,
      kickedBy: S.of(context).kickedBy,
      leftTheGroup: S.of(context).leftTheGroup,
      promotedToAdminBy: S.of(context).promotedToAdminBy,
      updateImage: S.of(context).updateImage,
      updateTitleTo: S.of(context).updateTitleTo,
      you: S.of(context).you,
    );

    if (message.allDeletedAt != null) {
      return messageHasBeenDeletedLabel.text.italic.color(Colors.grey).size(14);
    }

    if (message.isDeleted) {
      return VMessageConstants.getMessageBody(message, language).text.lineThrough;
    }

    if (message.isOneSeen) {
      return Row(
        children: [
          S.of(context).oneSeenMessage.text.black.italic.color(Colors.red),
        ],
      );
    }

    if (isBold) {
      return VTextParserWidget(
        text: VMessageConstants.getMessageBody(message, language),
        enableTabs: false,
        isOneLine: true,
        textStyle: theme.unSeenLastMessageTextStyle,
      );
    }

    return VTextParserWidget(
      text: VMessageConstants.getMessageBody(message, language),
      enableTabs: false,
      isOneLine: true,
      textStyle: theme.seenLastMessageTextStyle,
    );
  }
}
