import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../v_chat/v_socket_status_widget.dart';
import '../../../../widgets/app_bar/message_page_app_bar.dart';
import '../../controllers/v_message_item_controller.dart';
import '../../providers/message_provider.dart';
import '../../states/input_state_controller.dart';
import '../../widget_states/input_widget_state.dart';
import 'order_app_bar_controller.dart';
import 'v_order_controller.dart';

class VOrderView extends StatefulWidget {
  const VOrderView({
    super.key,
    required this.vRoom,
    required this.language,
    required this.vMessageConfig,
  });

  final VRoom vRoom;
  final VMessageConfig vMessageConfig;
  final VMessageLocalization language;

  @override
  State<VOrderView> createState() => _VOrderViewState();
}

class _VOrderViewState extends State<VOrderView> {
  late final VOrderController controller;

  @override
  void initState() {
    super.initState();
    final provider = MessageProvider();
    controller = VOrderController(
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
      itemController: VMessageItemController(
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
                VSocketStatusWidget(
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
