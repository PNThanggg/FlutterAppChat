import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'broadcast_app_bar_controller.dart';
import 'broadcast_controller.dart';

class BroadcastView extends StatefulWidget {
  const BroadcastView({
    super.key,
    required this.vRoom,
    required this.vMessageConfig,
    required this.language,
  });

  final VRoom vRoom;
  final MessageConfig vMessageConfig;
  final VMessageLocalization language;

  @override
  State<BroadcastView> createState() => _VBroadcastViewState();
}

class _VBroadcastViewState extends State<BroadcastView> {
  late final BroadcastController controller;

  @override
  void initState() {
    super.initState();
    final provider = MessageProvider();
    controller = BroadcastController(
      vRoom: widget.vRoom,
      vMessageConfig: widget.vMessageConfig,
      messageProvider: provider,
      scrollController: AutoScrollController(
        axis: Axis.vertical,
        suggestedRowHeight: 200,
      ),
      inputStateController: InputStateController(widget.vRoom),
      itemController: MessageItemController(
        messageProvider: provider,
        context: context,
        vMessageConfig: widget.vMessageConfig,
      ),
      broadcastAppBarController: BroadcastAppBarController(
        messageProvider: provider,
        vRoom: widget.vRoom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: ObstructingBarWrapper(
        child: ValueListenableBuilder<BroadcastAppBarStateModel>(
          valueListenable: controller.broadcastAppBarController,
          builder: (_, value, __) {
            if (value.isSearching) {
              return VSearchAppBare(
                onClose: controller.onCloseSearch,
                onSearch: controller.onSearch,
                searchLabel: widget.language.search,
              );
            }
            return MessagePageAppBar(
              isCallAllowed: false,
              language: widget.language,
              memberCount: value.members,
              room: widget.vRoom,
              inTypingText: (context) {
                return null;
              },
              // onViewMedia: () => controller.onViewMedia(context, value.roomId),
              onTitlePress: controller.onTitlePress,
            );
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.vMessageConfig.showDisconnectedWidget)
              SocketStatusWidget(
                connectingLabel: widget.language.connecting,
                delay: Duration.zero,
              ),
            Expanded(
              child: MessageBodyStateWidget(
                language: widget.language,
                controller: controller,
                roomType: widget.vRoom.roomType,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            InputWidgetState(
              controller: controller,
              language: widget.language,
              isAllowSendMedia: widget.vMessageConfig.isSendMediaAllowed,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
