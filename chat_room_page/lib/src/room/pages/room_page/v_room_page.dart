import 'dart:async';

import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_room_page/src/room/room.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

/// A [StatefulWidget] that represents a page for displaying and managing video chat rooms.
/// /// The [VChatPage] requires a [VRoomController] instance to manage and display rooms.
/// The controller is passed in through the [controller] parameter.
/// /// The [onRoomItemPress] parameter is an optional callback that is called when a room item is pressed.
/// The callback provides a [VRoom] instance representing the room that was pressed.
/// /// The [showDisconnectedWidget] parameter determines whether to show a widget when the user is disconnected from the server.
/// If set to true (which is the default), a [VDisconnectedWidget] will be displayed. Otherwise, nothing will be displayed.
/// /// The [useIconForRoomItem] parameter is an optional parameter that, if set to true, will cause the room list items to display an icon instead of a thumbnail image.
/// /// The [appBar] and [floatingActionButton] parameters are optional, and allow customization of the app bar and action button displayed on the page
class VChatPage extends StatefulWidget {
  const VChatPage({
    super.key,
    required this.controller,
    required this.onCreateNewBroadcast,
    required this.onCreateNewGroup,
    required this.language,
    required this.onSearchClicked,
    this.appBar,
    this.emptyWidget,
    this.onRoomItemPress,
    this.showDisconnectedWidget = true,
    this.isAdmin = false,
    this.isShowMember = false,
    this.useIconForRoomItem = false,
  });

  final VRoomController controller;
  final Function(VRoom room)? onRoomItemPress;
  final bool showDisconnectedWidget;
  final bool isAdmin;
  final bool isShowMember;
  final Widget? appBar;
  final Widget? emptyWidget;
  final VRoomLanguage language;
  final bool useIconForRoomItem;
  final GestureTapCallback? onCreateNewGroup;
  final GestureTapCallback onSearchClicked;
  final GestureTapCallback? onCreateNewBroadcast;

  @override
  State<VChatPage> createState() => _VChatPageState();
}

class _VChatPageState extends State<VChatPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.init(context, widget.language);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: VPlatforms.isMobile ? 15 : 0),
      child: Column(
        children: [
          widget.appBar ?? Container(),
          const SizedBox(
            height: 12,
          ),
          widget.useIconForRoomItem
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onSearchClicked,
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.theme.hintColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          margin: EdgeInsets.zero,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                CupertinoIcons.search,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              S.of(context).search.h6.size(16).color(Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ValueListenableBuilder<VPaginationModel<VRoom>>(
              valueListenable: widget.controller.roomState,
              builder: (_, value, __) {
                List<VRoom> list = value.data
                    .where(
                      (element) => widget.isAdmin ? element.tgGroupId != null : element.tgGroupId == null,
                    )
                    .toList();

                StreamController<VRoom> streamController = widget.isAdmin
                    ? widget.controller.roomState.workspaceStateStream
                    : widget.controller.roomState.roomStateStream;

                if (list.isEmpty) {
                  return widget.emptyWidget ?? const SizedBox.shrink();
                }

                return LoadMore(
                  onLoadMore: widget.controller.onLoadMore,
                  isFinish: widget.controller.getIsFinishLoadMore,
                  textBuilder: (status) {
                    return "";
                  },
                  delegate: const DefaultLoadMoreDelegate(),
                  child: ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final room = list[index];
                      return StreamBuilder<VRoom>(
                        key: UniqueKey(),
                        stream: streamController.stream.where(
                          (e) => e.id == room.id,
                        ),
                        initialData: room,
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              VRoomItem(
                                isIconOnly: widget.useIconForRoomItem,
                                isSelected: snapshot.data!.id == widget.controller.selectedRoomId,
                                room: snapshot.data!,
                                onRoomItemLongPress: (room) => widget.controller.onRoomItemLongPress(room, context),
                                showMember: widget.isShowMember,
                                onRoomItemPress: (room) {
                                  if (widget.onRoomItemPress == null) {
                                    widget.controller.onRoomItemPress(room, context);
                                  } else {
                                    widget.onRoomItemPress!(room);
                                  }
                                },
                              ),
                              Divider(
                                thickness: .8,
                                color: Colors.grey.withOpacity(.1),
                                height: 16,
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
