import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'order_app_bar_controller.dart';
import 'order_controller.dart';

class OrderView extends StatefulWidget {
  const OrderView({
    super.key,
    required this.vRoom,
    required this.language,
    required this.vMessageConfig,
  });

  final VRoom vRoom;
  final MessageConfig vMessageConfig;
  final VMessageLocalization language;

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  late final OrderController controller;

  @override
  void initState() {
    super.initState();
    final provider = MessageProvider();
    controller = OrderController(
      vRoom: widget.vRoom,
      language: widget.language,
      vMessageConfig: widget.vMessageConfig,
      messageProvider: provider,
      scrollController: AutoScrollController(
        axis: Axis.vertical,
        suggestedRowHeight: 200,
      ),
      inputStateController: InputStateController(widget.vRoom),
      orderAppBarController: OrderAppBarController(
        vRoom: widget.vRoom,
        messageProvider: provider,
      ),
      itemController: MessageItemController(
        messageProvider: provider,
        context: context,
        vMessageConfig: widget.vMessageConfig,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: ObstructingBarWrapper(
        child: ValueListenableBuilder<OrderAppBarStateModel>(
          valueListenable: controller.orderAppBarController,
          builder: (_, value, __) {
            if (value.isSearching) {
              return VSearchAppBare(
                searchLabel: widget.language.search,
                onClose: controller.onCloseSearch,
                onSearch: controller.onSearch,
              );
            }
            return MessagePageAppBar(
              isCallAllowed: widget.vMessageConfig.isCallsAllowed,
              room: widget.vRoom,
              inTypingText: (context) => _inSingleText(value.typingModel),
              lastSeenAt: value.lastSeenAt,
              onUpdateBlock: controller.onUpdateBlock,
              onCreateCall: controller.onCreateCall,
              language: widget.language,
              onTitlePress: controller.onTitlePress,
            );
          },
        ),
      ),
      child: SafeArea(
        child: Container(
          decoration: context.vMessageTheme.scaffoldDecoration,
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
      ),
    );
  }

  String? _inSingleText(VSocketRoomTypingModel value) {
    return _statusInText(value);
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
