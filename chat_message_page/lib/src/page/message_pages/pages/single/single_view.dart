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
import 'single_app_bar_controller.dart';
import 'single_controller.dart';

class SingleView extends StatefulWidget {
  const SingleView({
    super.key,
    required this.vRoom,
    required this.vMessageConfig,
    required this.language,
  });

  final VRoom vRoom;
  final MessageConfig vMessageConfig;
  final VMessageLocalization language;

  @override
  State<SingleView> createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> {
  late final SingleController controller;

  @override
  void initState() {
    super.initState();

    final provider = MessageProvider();

    controller = SingleController(
      vRoom: widget.vRoom,
      language: widget.language,
      vMessageConfig: widget.vMessageConfig,
      singleAppBarController: SingleAppBarController(
        vRoom: widget.vRoom,
        messageProvider: provider,
      ),
      messageProvider: provider,
      scrollController: AutoScrollController(
        axis: Axis.vertical,
        suggestedRowHeight: 200,
      ),
      inputStateController: InputStateController(widget.vRoom),
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
        child: ValueListenableBuilder<SingleAppBarStateModel>(
          valueListenable: controller.singleAppBarController,
          builder: (_, value, __) {
            if (value.isSearching) {
              //handle the search
              return VSearchAppBare(
                onClose: controller.onCloseSearch,
                onSearch: controller.onSearch,
                searchLabel: widget.language.search,
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
