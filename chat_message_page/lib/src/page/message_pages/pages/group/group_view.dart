import 'dart:math';

import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_message_page/src/page/message_pages/pages/group/group_controller.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../v_chat/v_socket_status_widget.dart';
import '../../../../widgets/app_bare/v_message_app_bare.dart';
import '../../controllers/v_message_item_controller.dart';
import '../../providers/message_provider.dart';
import '../../states/input_state_controller.dart';
import '../../widget_states/input_widget_state.dart';
import 'group_app_bar_controller.dart';

class VGroupView extends StatefulWidget {
  const VGroupView({
    super.key,
    required this.vRoom,
    required this.language,
    required this.vMessageConfig,
  });

  final VRoom vRoom;
  final VMessageConfig vMessageConfig;
  final VMessageLocalization language;

  @override
  State<VGroupView> createState() => _VGroupViewState();
}

class _VGroupViewState extends State<VGroupView> {
  late final VGroupController controller;
  final MessageProvider _provider = MessageProvider();

  bool _isPinnedVisible = true;

  @override
  void initState() {
    super.initState();

    controller = VGroupController(
      vRoom: widget.vRoom,
      vMessageConfig: widget.vMessageConfig,
      messageProvider: _provider,
      scrollController: AutoScrollController(
        axis: Axis.vertical,
        suggestedRowHeight: 200,
      ),
      inputStateController: InputStateController(widget.vRoom),
      itemController: VMessageItemController(
        messageProvider: _provider,
        context: context,
        vMessageConfig: widget.vMessageConfig,
      ),
      groupAppBarController: GroupAppBarController(
        messageProvider: _provider,
        vRoom: widget.vRoom,
      ),
    );

    controller.itemController.setStarSuccessCallback(() {
      controller.getStarMessage();
    });

    controller.itemController.setUnStarSuccessCallback(() {
      controller.getStarMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: ObstructingBarWrapper(
        child: ValueListenableBuilder<GroupAppBarStateModel>(
          valueListenable: controller.groupAppBarController,
          builder: (_, value, __) {
            if (value.isSearching) {
              return VSearchAppBare(
                onClose: controller.onCloseSearch,
                onSearch: controller.onSearch,
                searchLabel: widget.language.search,
              );
            }

            return VMessageAppBare(
              room: widget.vRoom,
              isCallAllowed: false,
              memberCount: value.myGroupInfo.membersCount,
              onCreateCall: (isVideo) {
                controller.onCreateCall(context, isVideo);
              },
              totalOnline: value.myGroupInfo.totalOnline,
              inTypingText: (context) => _inGroupText(value.typingModel),
              language: widget.language,
              onTitlePress: controller.onTitlePress,
            );
          },
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.vMessageConfig.showDisconnectedWidget)
                  VSocketStatusWidget(
                    connectingLabel: widget.language.connecting,
                    delay: Duration.zero,
                  ),
                Expanded(
                  child: Padding(
                    padding: controller.value.listStarMessage.isNotEmpty
                        ? const EdgeInsets.only(top: 70)
                        : EdgeInsets.zero,
                    child: MessageBodyStateWidget(
                      language: widget.language,
                      controller: controller,
                      roomType: widget.vRoom.roomType,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                InputWidgetState(
                  controller: controller,
                  language: widget.language,
                  isAllowSendMedia: widget.vMessageConfig.isSendMediaAllowed,
                )
              ],
            ),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
                if (value.listStarMessage.isEmpty) {
                  return const SizedBox.shrink();
                }

                VBaseMessage lastStarMessage = value.listStarMessage.last;

                if (!_isPinnedVisible) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.mark_chat_unread_outlined,
                              color: Colors.blueAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            "Pinned Messages".h6.color(Colors.blueAccent).semiBold.size(16),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPinnedVisible = true;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: value.listStarMessage.length,
                            itemBuilder: (context, index) {
                              VBaseMessage message = value.listStarMessage[index];

                              return GestureDetector(
                                onTap: () {
                                  controller.onHighlightMessage(message);

                                  setState(() {
                                    _isPinnedVisible = true;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade50, width: 0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            message.senderName.h6.semiBold.size(16),
                                            const SizedBox(height: 4),
                                            message.realContent.h6
                                                .color(Colors.grey.shade700)
                                                .size(12)
                                                .overflowEllipsis,
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey.shade400,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPinnedVisible = !_isPinnedVisible;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          // Icon for pinned message
                          Icons.mark_unread_chat_alt_rounded,
                          color: Colors.blueAccent,
                          size: 25,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lastStarMessage.senderName.h6
                                  .maxLine(1)
                                  .bold
                                  .size(12)
                                  .color(context.textTheme.bodyLarge!.color!),
                              _processText(lastStarMessage.realContent)
                                  .h6
                                  .maxLine(1)
                                  .bold
                                  .size(12)
                                  .color(Colors.grey.shade600)
                                  .overflowEllipsis,
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${value.listStarMessage.length} more',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey.shade400,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _processText(String text) {
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].startsWith('@')) {
        String prefix = words[i].substring(0, min(5, words[i].length));
        String suffix = ' ';
        words[i] = '$prefix$suffix';
      }
    }
    return words.join(' ');
  }

  /// Returns a string representation of the typing status in a group.
  String? _inGroupText(VSocketRoomTypingModel value) {
    if (_statusInText(value) == null) return null;
    return "${value.userName} ${_statusInText(value)!}";
  }

  /// Converts the typing status to a localized text.
  String? _statusInText(VSocketRoomTypingModel value) {
    switch (value.status) {
      case VRoomTypingEnum.stop:
        return null;
      case VRoomTypingEnum.typing:
        return widget.language.typing;
      case VRoomTypingEnum.recording:
        return widget.language.recording;
    }
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
