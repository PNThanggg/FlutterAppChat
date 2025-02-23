import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../widgets/arrow_down.dart';
import '../../../widgets/drag_drop_if_web_desk.dart';

class MessageBodyStateWidget extends StatelessWidget {
  final BaseMessageController controller;
  final VRoomType roomType;
  final VMessageLocalization language;

  const MessageBodyStateWidget({
    super.key,
    required this.controller,
    required this.roomType,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DragDropIfWeb(
          onDragDone: (files) => controller.onSubmitMedia(context, files),
          child: ValueListenableBuilder<MessageState>(
            valueListenable: controller,
            builder: (_, value, __) {
              return Scrollbar(
                interactive: true,
                thickness: 5,
                controller: controller.scrollController,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: VPlatforms.isWeb ? 10 : 15,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  controller: controller.scrollController,
                  cacheExtent: 300,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Builder(
                      key: UniqueKey(),
                      builder: (context) {
                        final message = value.listMessage[index];
                        final msgItem = StreamBuilder<VBaseMessage>(
                          stream: controller.messageStateStream.stream.where(
                            (e) => e.localId == message.localId,
                          ),
                          initialData: message,
                          builder: (context, snapshot) {
                            if (message.isDeleted) {
                              return const SizedBox.shrink();
                            }
                            return AutoScrollTag(
                              key: UniqueKey(),
                              controller: controller.scrollController,
                              index: index,
                              highlightColor:
                                  context.isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
                              child: VMessageItem(
                                language: language,
                                roomType: roomType,
                                onLongTap: (message) => controller.onMessageLongTap(context, message),
                                message: snapshot.data!,
                                voiceController: (message) {
                                  if (message is VVoiceMessage) {
                                    return controller.voiceControllers.getVoiceController(message);
                                  }
                                  return null;
                                },
                                onSwipe: controller.setReply,
                                onHighlightMessage: controller.onHighlightMessage,
                                onReSend: controller.onReSend,
                              ),
                            );
                          },
                        );

                        final isTopMessage = _isTopMessage(value.listMessage.length, index);
                        final dividerDate = _getDateDiff(
                          bigDate: message.createdAtDate,
                          smallDate: isTopMessage
                              ? value.listMessage[index].createdAtDate
                              : value.listMessage[index + 1].createdAtDate,
                        );
                        if (dividerDate != null || isTopMessage) {
                          //set date divider
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DateDividerItem(
                                dateTime: dividerDate ?? message.createdAtDate,
                                today: language.today,
                                yesterday: language.yesterday,
                              ),
                              msgItem,
                            ],
                          );
                        }
                        return msgItem;
                      },
                    );
                  },
                  itemCount: value.listMessage.length,
                  reverse: true,
                ),
              );
            },
          ),
        ),
        PositionedDirectional(
          bottom: 10,
          end: 0,
          child: ListViewArrowDown(
            scrollController: controller.scrollController,
            onPress: controller.scrollDown,
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(),
        ),
      ],
    );
  }

  bool _isTopMessage(int listLength, int index) {
    return listLength - 1 == index;
  }

  DateTime? _getDateDiff({
    required DateTime bigDate,
    required DateTime smallDate,
  }) {
    final difference = bigDate.difference(smallDate);
    if (difference.isNegative) {
      return null;
    }
    if (difference.inHours < 24) {
      final d1 = bigDate.day;
      final d2 = smallDate.day;
      if (d1 == d2) {
        return null;
      } else {
        return bigDate;
      }
    }
    return bigDate;
  }
}
