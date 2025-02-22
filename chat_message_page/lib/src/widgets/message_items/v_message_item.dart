import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../chat_message_page.dart';
import '../../v_chat/v_message_constants.dart';
import 'shared/bubble/swipe_to_reply.dart';
import 'shared/center_item_holder.dart';
import 'shared/forward_item_widget.dart';
import 'shared/message_broadcast_icon.dart';
import 'shared/message_time_widget.dart';
import 'shared/star_item_widget.dart';
import 'widgets/all_deleted_item.dart';
import 'widgets/one_seen_widget.dart';
import 'widgets/text_message_item.dart';
import 'widgets/voice_message_item.dart';

class VMessageItem extends StatelessWidget {
  final VBaseMessage message;
  final VMessageCallback? onSwipe;

  final VMessageCallback? onLongTap;
  final VVoiceMessageController? Function(VBaseMessage message)? voiceController;
  final VMessageCallback? onHighlightMessage;
  final VMessageCallback? onReSend;
  final VRoomType roomType;
  final VMessageLocalization language;
  final bool forceSeen;

  const VMessageItem({
    super.key,
    required this.roomType,
    required this.message,
    required this.language,
    this.onLongTap,
    this.voiceController,
    this.onSwipe,
    this.forceSeen = false,
    this.onReSend,
    this.onHighlightMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (message.messageType.isCenter) {
      return CenterItemHolder(
        child: VMessageConstants.getMessageBody(message, language.vMessagesInfoTrans).h6.regular.size(14),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final maxWidth = VPlatforms.isMobile
        ? width * .75
        : width <= 600
            ? width * .75
            : width * .40;
    return GestureDetector(
      onLongPress: () => onLongTap?.call(message),
      child: SwipeToReply(
        key: UniqueKey(),
        onRightSwipe: message.canNotSwipe
            ? null
            : () {
                onSwipe?.call(message);
              },
        child: Row(
          mainAxisAlignment: message.isMeSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _getGroupUserAvatar(context),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getGroupUserTitle(context),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: message.isMeSender
                            ? Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF012A4A)
                                : const Color(0xFF004893)
                            : Theme.of(context).brightness == Brightness.dark
                                ? const Color(0x26FFFFFF)
                                : const Color.fromARGB(255, 233, 233, 233),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(message.isMeSender ? 20 : 20),
                          bottomRight: Radius.circular(message.isMeSender ? 20 : 20),
                        ),
                      ),
                      child: IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ///Reply
                            ReplyItemWidget(
                              rToMessage: message.isAllDeleted ? null : message.replyTo,
                              onHighlightMessage: onHighlightMessage,
                              isMeSender: message.isMeSender,
                              repliedToYourSelf: language.repliedToYourSelf,
                            ),

                            ///Link
                            LinkViewerWidget(
                              data: message.linkAtt,
                              isMeSender: message.isMeSender,
                            ),

                            ///real message
                            _getChild(context),

                            ///attachment
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              // Spread out the elements
                              children: [
                                if (message.isMeSender) const Spacer(),
                                if (message.isMeSender) ..._getMessageActions,
                                if (!message.isMeSender) ..._getMessageActions,
                                if (!message.isMeSender) const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _getMessageActions {
    return [
      MessageTimeWidget(
        dateTime: message.createdAtDate,
        isMeSender: message.isMeSender,
      ),
      const SizedBox(
        width: 4,
      ),
      StarItemWidget(
        isStar: message.isStared,
      ),
      const SizedBox(
        width: 4,
      ),
      MessageBroadcastWidget(
        isFromBroadcast: message.isFromBroadcast,
      ),
      const SizedBox(
        width: 4,
      ),
      ForwardItemWidget(
        isFroward: message.isForward,
      ),
      if (message.isOneSeen)
        const Icon(
          CupertinoIcons.eye_fill,
          size: 16,
        ),
      const SizedBox(
        width: 4,
      ),
      MessageStatusIcon(
        model: MessageStatusIconDataModel(
          isSeen: message.seenAt != null,
          isDeliver: message.deliveredAt != null,
          emitStatus: message.emitStatus,
          isMeSender: message.isMeSender,
        ),
        onReSend: () {
          onReSend?.call(message);
        },
      ),
    ];
  }

  Widget _getChild(BuildContext context) {
    if (message.allDeletedAt != null) {
      return AllDeletedItem(
        message: message,
        messageHasBeenDeletedLabel: language.messageHasBeenDeleted,
      );
    }

    if (!forceSeen) {
      if (message.isOneSeenByMe) {
        return const OneSeenWidget();
      }

      if (message.isOneSeen && !message.isMeSender && !message.isOneSeenByMe) {
        return ClickToSeenWidget(
          message: message,
          language: language,
        );
      }
    }

    switch (message.messageType) {
      case VMessageType.text:
        return TextMessageItem(
          message: (message as VTextMessage).realContent,
          textStyle: message.isMeSender
              ? context.vMessageTheme.senderTextStyle.copyWith(letterSpacing: 0)
              : context.textTheme.bodyLarge!.copyWith(
                  color: context.isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
          onLinkPress: (link) async {
            await VStringUtils.lunchLink(link);
          },
          onEmailPress: (email) async {
            await VStringUtils.lunchEmail(email);
          },
          onMentionPress: _onMentionPress,
          onPhonePress: (phone) async {
            await VStringUtils.lunchLink(phone);
          },
        );

      case VMessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageMessageItem(
              message: message as VImageMessage,
              fit: BoxFit.cover,
            ),
            message.realContent == 'image'
                ? const SizedBox.shrink()
                : TextMessageItem(
                    message: message.realContent,
                    textStyle: message.isMeSender
                        ? context.vMessageTheme.senderTextStyle
                        : context.textTheme.bodyLarge!.copyWith(
                            color: context.isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    onLinkPress: (link) async {
                      await VStringUtils.lunchLink(link);
                    },
                    onEmailPress: (email) async {
                      await VStringUtils.lunchEmail(email);
                    },
                    onMentionPress: _onMentionPress,
                    onPhonePress: (phone) async {
                      await VStringUtils.lunchLink(phone);
                    },
                  ),
          ],
        );

      case VMessageType.file:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FileMessageItem(
              message: message as VFileMessage,
            ),
            message.realContent == 'image'
                ? const SizedBox.shrink()
                : TextMessageItem(
                    message: message.realContent,
                    textStyle: message.isMeSender
                        ? context.vMessageTheme.senderTextStyle
                        : context.textTheme.bodyLarge!.copyWith(
                            color: context.isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    onLinkPress: (link) async {
                      await VStringUtils.lunchLink(link);
                    },
                    onEmailPress: (email) async {
                      await VStringUtils.lunchEmail(email);
                    },
                    onMentionPress: _onMentionPress,
                    onPhonePress: (phone) async {
                      await VStringUtils.lunchLink(phone);
                    },
                  ),
          ],
        );

      case VMessageType.video:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VideoMessageItem(
              message: message as VVideoMessage,
            ),
            message.realContent == 'image'
                ? const SizedBox.shrink()
                : TextMessageItem(
                    message: message.realContent,
                    textStyle: message.isMeSender
                        ? context.vMessageTheme.senderTextStyle
                        : context.textTheme.bodyLarge!.copyWith(
                            color: context.isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    onLinkPress: (link) async {
                      await VStringUtils.lunchLink(link);
                    },
                    onEmailPress: (email) async {
                      await VStringUtils.lunchEmail(email);
                    },
                    onMentionPress: _onMentionPress,
                    onPhonePress: (phone) async {
                      await VStringUtils.lunchLink(phone);
                    },
                  ),
          ],
        );

      case VMessageType.voice:
        return VoiceMessageItem(
          message: message as VVoiceMessage,
          voiceController: voiceController!,
        );

      case VMessageType.location:
        return LocationMessageItem(
          message: message as VLocationMessage,
        );

      case VMessageType.call:
        return CallMessageItem(
          message: message as VCallMessage,
          audioCallLabel: language.audioCall,
          callStatusLabel: language.transCallStatus((message as VCallMessage).data.callStatus),
        );

      case VMessageType.custom:
        return context.vMessageTheme.customMessageItem?.call(
              context,
              message.isMeSender,
              (message as VCustomMessage).data.data,
            ) ??
            const Text(
              "custom message not implemented you need to add this data inside VInheritedMessageTheme which should be at the top of your app material widget",
            );

      case VMessageType.info:
        throw "MessageType.info should not render her it center render!";

      case VMessageType.bug:
        return const SizedBox.shrink();
    }
  }

  void _onMentionPress(BuildContext context, String peerId) {
    final method = VChatController.I.vNavigator.messageNavigator.toUserProfilePage;
    if (method != null) {
      method(context, peerId);
    }
  }

  Widget _getGroupUserAvatar(BuildContext context) {
    if (roomType.isGroup && !message.isMeSender) {
      return GestureDetector(
        onTap: () {
          _onMentionPress(context, message.senderId);
        },
        child: Row(
          children: [
            VCircleAvatar(
              vFileSource: VPlatformFile.fromUrl(
                url: message.senderImageThumb,
              ),
              radius: 14,
            ),
            const SizedBox(
              width: 6,
            )
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _getGroupUserTitle(BuildContext context) {
    if (roomType.isGroup && !message.isMeSender) {
      return GestureDetector(
        onTap: () {
          _onMentionPress(context, message.senderId);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 4),
          child: (message.telegramName == null ? message.senderName : "${message.senderName} ${message.telegramName}")
              .h6
              .color(Colors.grey)
              .size(11),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
