import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

import '../../chat_message_page.dart';

typedef CustomMessageItemTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  Map<String, dynamic> data,
);
typedef ItemHolderColorTypeDef = Color Function(
  BuildContext context,
  bool isMeSender,
  bool isDarkMode,
);

const _darkMeSenderColor = Color(0xff012a4a);
const _darkReceiverColor = Color(0xff515156);

const _lightReceiverColor = Color(0xffffffff);
const _lightMySenderColor = Color(0xff023e7d);

const _lightTextMeSenderColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
const _lightTextMeReceiverColor = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const _darkTextMeSenderColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
const _darkTextReceiverColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

class MessageTheme extends ThemeExtension<MessageTheme> {
  final Color senderBubbleColor;
  final Color receiverBubbleColor;

  final Color senderReplyColor;
  final Color receiverReplyColor;
  final MsgStatusTheme messageSendingStatus;
  final BoxDecoration scaffoldDecoration;
  final CustomMessageItemTypeDef? customMessageItem;
  final TextStyle receiverTextStyle;
  final TextStyle senderTextStyle;

  final VMessageItemTheme vMessageItemTheme;

  MessageTheme._({
    required this.senderBubbleColor,
    required this.receiverBubbleColor,
    required this.senderReplyColor,
    required this.receiverReplyColor,
    required this.senderTextStyle,
    this.customMessageItem,
    required this.scaffoldDecoration,
    required this.messageSendingStatus,
    required this.receiverTextStyle,
    required this.vMessageItemTheme,
  });

  factory MessageTheme.light() {
    return MessageTheme._(
      senderBubbleColor: _lightMySenderColor,
      vMessageItemTheme: const VMessageItemTheme.light(),
      receiverBubbleColor: _lightReceiverColor,
      senderTextStyle: _lightTextMeSenderColor,
      receiverTextStyle: _lightTextMeReceiverColor,
      messageSendingStatus: const MsgStatusTheme.light(),
      scaffoldDecoration: sMessageBackground(isDark: false),
      senderReplyColor: const Color(0xffD7F2C9),
      receiverReplyColor: const Color(0xffF2F2F2),
    );
  }

  factory MessageTheme.dark() {
    return MessageTheme._(
      senderBubbleColor: _darkMeSenderColor,
      receiverBubbleColor: _darkReceiverColor,
      vMessageItemTheme: const VMessageItemTheme.dark(),
      senderTextStyle: _darkTextMeSenderColor,
      receiverTextStyle: _darkTextReceiverColor,
      messageSendingStatus: const MsgStatusTheme.dark(),
      scaffoldDecoration: sMessageBackground(isDark: true),
      senderReplyColor: const Color(0xff003C34),
      receiverReplyColor: const Color(0xff28282A),
    );
  }

  @override
  ThemeExtension<MessageTheme> lerp(ThemeExtension<MessageTheme>? other, double t) {
    if (other is! MessageTheme) {
      return this;
    }
    return this;
  }

  @override
  MessageTheme copyWith({
    Color? senderBubbleColor,
    Color? receiverBubbleColor,
    Color? senderReplyColor,
    Color? receiverReplyColor,
    VMessageItemTheme? vMessageItemTheme,
    MsgStatusTheme? messageSendingStatus,
    BoxDecoration? scaffoldDecoration,
    CustomMessageItemTypeDef? customMessageItem,
    TextStyle? receiverTextStyle,
    TextStyle? senderTextStyle,
  }) {
    return MessageTheme._(
      senderBubbleColor: senderBubbleColor ?? this.senderBubbleColor,
      vMessageItemTheme: vMessageItemTheme ?? this.vMessageItemTheme,
      senderReplyColor: senderReplyColor ?? this.senderReplyColor,
      receiverReplyColor: receiverReplyColor ?? this.receiverReplyColor,
      receiverBubbleColor: receiverBubbleColor ?? this.receiverBubbleColor,
      messageSendingStatus: messageSendingStatus ?? this.messageSendingStatus,
      scaffoldDecoration: scaffoldDecoration ?? this.scaffoldDecoration,
      customMessageItem: customMessageItem ?? this.customMessageItem,
      receiverTextStyle: receiverTextStyle ?? this.receiverTextStyle,
      senderTextStyle: senderTextStyle ?? this.senderTextStyle,
    );
  }
}

extension VMessageThemeNewExt on BuildContext {
  MessageTheme get vMessageTheme {
    return Theme.of(this).extension<MessageTheme>() ?? MessageTheme.light();
  }

  Color getMessageItemHolderColor(bool isSender, BuildContext context) {
    if (isSender) {
      return context.vMessageTheme.senderBubbleColor;
    } else {
      return context.vMessageTheme.receiverBubbleColor;
    }
  }
}
