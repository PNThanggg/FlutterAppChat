import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_v2/v_chat_v2.dart';
import 'package:v_platform/v_platform.dart';

import '../controllers/chat_star_messages_controller.dart';

class ChatStarMessagesPage extends StatefulWidget {
  final String? roomId;

  const ChatStarMessagesPage({
    super.key,
    this.roomId,
  });

  @override
  State<ChatStarMessagesPage> createState() => _ChatStarMessagesPageState();
}

class _ChatStarMessagesPageState extends State<ChatStarMessagesPage> {
  late final ChatStarMessagesController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatStarMessagesController(widget.roomId);
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.vMessageTheme.scaffoldDecoration,
      child: CupertinoPageScaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        navigationBar: CupertinoNavigationBar(
          border: Border.all(color: Colors.transparent),
          backgroundColor: context.theme.scaffoldBackgroundColor,
          middle: S
              .of(context)
              .starMessage
              .h6
              .color(context.textTheme.bodyLarge!.color!)
              .semiBold
              .size(20),
        ),
        child: SafeArea(
          bottom: false,
          child: ValueListenableBuilder<SLoadingState<List<VBaseMessage>>>(
            valueListenable: controller,
            builder: (_, data, ___) => VAsyncWidgetsBuilder(
              loadingState: data.loadingState,
              onRefresh: controller.getData,
              successWidget: () {
                final value = data.data;
                return Scrollbar(
                  interactive: true,
                  thickness: 5,
                  controller: controller.scrollController,
                  child: ListView.separated(
                    // key: const PageStorageKey("VListViewItems"),
                    // reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: value.length,
                    controller: controller.scrollController,
                    cacheExtent: 300,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                      height: VPlatforms.isWeb ? 12 : 10,
                    ),
                    itemBuilder: (context, index) {
                      VBaseMessage message = value[index];
                      VMessageLocalization language = vMessageLocalizationPageModel(
                        context,
                      );

                      return Builder(
                        key: UniqueKey(),
                        builder: (context) {
                          if (message.isDeleted) {
                            return const SizedBox.shrink();
                          }

                          VMessageItem msgItem = VMessageItem(
                            language: language,
                            onLongTap: (message) => controller.onLongTab(context, message),
                            roomType: VRoomType.s,
                            message: message,
                            voiceController: (message) {
                              if (message is VVoiceMessage) {
                                return controller.voiceControllers.getVoiceController(message);
                              }
                              return null;
                            },
                          );

                          bool isTopMessage = _isTopMessage(value.length, index);
                          DateTime? dividerDate = _getDateDiff(
                            bigDate: message.createdAtDate,
                            smallDate: isTopMessage
                                ? value[index].createdAtDate
                                : value[index + 1].createdAtDate,
                          );

                          if (dividerDate != null || isTopMessage) {
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
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  bool _isTopMessage(int listLength, int index) {
    return listLength - 1 == index;
  }

  DateTime? _getDateDiff({
    required DateTime bigDate,
    required DateTime smallDate,
  }) {
    Duration difference = bigDate.difference(smallDate);

    if (difference.isNegative) {
      return null;
    }

    if (difference.inHours < 24) {
      int d1 = bigDate.day;
      int d2 = smallDate.day;

      if (d1 == d2) {
        return null;
      } else {
        return bigDate;
      }
    }

    return bigDate;
  }
}
