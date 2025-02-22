import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_room_page/chat_room_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../room_item_builder/chat_un_read_counter.dart';

/// A widget representing an individual virtual room item.
/// This widget handles rendering the room information and can be configured
/// to either show only an icon representation of the room or include additional information.
/// Required fields:
/// * [room] – The virtual room object that this item represents.
/// * [onRoomItemPress] – Callback function that is triggered when this item is pressed.
/// * [onRoomItemLongPress] – Callback function that is triggered when this item is long pressed.
/// Optional fields:
/// * [isIconOnly] – Flag indicating whether to show only the icon representation of the room.
class VRoomItem extends StatefulWidget {
  /// The virtual room object that this item represents.
  final VRoom room;

  /// Flag indicating whether to show only the icon representation of the room.
  final bool isIconOnly;

  /// Callback function that is triggered when this item is pressed.

  /// Callback function that is triggered when this item is long pressed.
  final Function(VRoom room) onRoomItemPress;

  /// Callback function that is triggered when this item is long pressed.
  final Function(VRoom room) onRoomItemLongPress;
  final bool isSelected;

  final bool showMember;

  /// Creates a new instance of [VRoomItem].
  const VRoomItem({
    super.key,
    required this.room,
    required this.onRoomItemPress,
    required this.onRoomItemLongPress,
    this.isIconOnly = false,
    this.isSelected = false,
    this.showMember = false,
  });

  @override
  State<VRoomItem> createState() => _VRoomItemState();
}

class _VRoomItemState extends State<VRoomItem> {
  List<VGroupMember> listMember = [];

  @override
  void initState() {
    super.initState();

    _initData();
  }

  Future<void> _initData() async {
    if (!widget.showMember) {
      return;
    }

    await vSafeApiCall<List<VGroupMember>>(
      onLoading: () async {},
      onError: (exception, trace) {
        debugPrint(exception);
      },
      request: () async {
        return VChatController.I.roomApi.getGroupMembers(widget.room.id);
      },
      onSuccess: (response) {
        listMember.clear();
        listMember.addAll(response);
        listMember.removeWhere(
          (element) => element.role == VGroupMemberRole.admin,
        );

        listMember.removeWhere(
          (element) => element.userData.fullName == "Customer",
        );

        if (mounted) {
          setState(() {});
        }
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room.isDeleted) {
      return const SizedBox.shrink();
    }

    final theme = context.vRoomTheme;
    return GestureDetector(
      onTap: () {
        widget.onRoomItemPress(widget.room);
      },
      onLongPress: () {
        widget.onRoomItemLongPress(widget.room);
      },
      child: Container(
        padding: EdgeInsets.only(
          left: VPlatforms.isMobile ? 0 : 16,
          right: VPlatforms.isMobile ? 0 : 16,
          top: 8,
          bottom: 8,
        ),
        margin: EdgeInsets.zero,
        alignment: AlignmentDirectional.topStart,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade300
                  : theme.selectedRoomColor
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget.isIconOnly
            ? theme.getChatAvatar(
                imageUrl: widget.room.thumbImageS3,
                chatTitle: widget.room.realTitle,
                isOnline: widget.room.isOnline,
                size: 55,
              )
            : Row(
                children: [
                  theme.getChatAvatar(
                    imageUrl: widget.room.thumbImageS3,
                    chatTitle: widget.room.realTitle,
                    isOnline: widget.room.isOnline,
                    size: 50,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///header and time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: ChatTitle(title: widget.room.realTitle),
                            ),
                            ChatLastMsgTime(
                              yesterdayLabel: S.of(context).yesterday,
                              lastMessageTime: widget.room.lastMessageTime,
                            )
                          ],
                        ),
                        const SizedBox.shrink(),

                        ///message and icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_roomTypingText(widget.room.typingStatus) != null)
                              ChatTypingWidget(
                                text: _roomTypingText(widget.room.typingStatus)!,
                              )
                            else if (widget.room.lastMessage.isMeSender)

                              ///icon
                              Flexible(
                                child: Row(
                                  children: [
                                    //status
                                    MessageStatusIcon(
                                      model: MessageStatusIconDataModel(
                                        isAllDeleted: widget.room.lastMessage.allDeletedAt != null,
                                        isSeen: widget.room.lastMessage.seenAt != null,
                                        isDeliver: widget.room.lastMessage.deliveredAt != null,
                                        emitStatus: widget.room.lastMessage.emitStatus,
                                        isMeSender: widget.room.lastMessage.isMeSender,
                                      ),
                                    ),
                                    //grey
                                    Flexible(
                                      child: RoomItemMsg(
                                        messageHasBeenDeletedLabel: S.of(context).messageHasBeenDeleted,
                                        message: widget.room.lastMessage,
                                        isBold: false,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            else if (widget.room.isRoomUnread)
                              //bold
                              Flexible(
                                child: RoomItemMsg(
                                  isBold: true,
                                  message: widget.room.lastMessage,
                                  messageHasBeenDeletedLabel: S.of(context).messageHasBeenDeleted,
                                ),
                              )
                            else
                              //normal gray
                              Flexible(
                                child: RoomItemMsg(
                                  isBold: false,
                                  messageHasBeenDeletedLabel: S.of(context).messageHasBeenDeleted,
                                  message: widget.room.lastMessage,
                                ),
                              ),
                            Row(
                              children: [
                                Visibility(
                                  visible: widget.room.isRoomUnread,
                                  child: MentionIcon(
                                    mentionsCount: widget.room.mentionsCount,
                                    isMeSender: widget.room.lastMessage.isMeSender,
                                  ),
                                ),
                                ChatMuteWidget(isMuted: widget.room.isMuted),
                                ChatUnReadWidget(unReadCount: widget.room.unReadCount),
                                if (widget.room.isOneSeen)
                                  const Icon(
                                    CupertinoIcons.eye,
                                    size: 16,
                                  ),
                              ],
                            )
                          ],
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        /// List Member
                        widget.showMember
                            ? listMember.isEmpty
                                ? const SizedBox.shrink()
                                : Wrap(
                                    spacing: 4,
                                    children: listMember.map(
                                      (item) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF9CD7F1),
                                            borderRadius: BorderRadius.circular(4),
                                            shape: BoxShape.rectangle,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 4,
                                          ),
                                          child: item.userData.fullName.h6.medium.size(10).color(
                                                const Color(0xFF0097DA),
                                              ),
                                        );
                                      },
                                    ).toList(),
                                  )
                            : const SizedBox.shrink()
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  String? _roomTypingText(VSocketRoomTypingModel value) {
    if (widget.room.roomType.isSingle) {
      return _inSingleText(value);
    }
    if (widget.room.roomType.isGroup) {
      return _inGroupText(value);
    }
    return null;
  }

  /// Returns a string representation of the typing status.
  String? _inSingleText(VSocketRoomTypingModel value) {
    return _statusInText(value);
  }

  /// Converts the typing status to a localized text.
  String? _statusInText(VSocketRoomTypingModel value) {
    switch (widget.room.typingStatus.status) {
      case VRoomTypingEnum.stop:
        return null;
      case VRoomTypingEnum.typing:
        return S.of(VChatController.I.navigatorKey.currentState!.context).typing;
      case VRoomTypingEnum.recording:
        return S.of(VChatController.I.navigatorKey.currentState!.context).recording;
    }
  }

  /// Returns a string representation of the typing status in a group.
  String? _inGroupText(VSocketRoomTypingModel value) {
    if (_statusInText(value) == null) return null;
    return "${value.userName} ${_statusInText(value)!}";
  }
}
