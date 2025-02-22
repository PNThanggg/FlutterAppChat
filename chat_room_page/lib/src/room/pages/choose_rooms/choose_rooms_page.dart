import 'package:flutter/cupertino.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

import '../../room.dart';
import 'choose_room_controller.dart';

/// A stateful widget that displays a list of available rooms and allows the user to select one. /// /// The [currentRoomId] parameter is used to highlight the
class VChooseRoomsPage extends StatefulWidget {
  final String? currentRoomId;

  const VChooseRoomsPage({
    super.key,
    required this.currentRoomId,
  });

  @override
  State<VChooseRoomsPage> createState() => _VChooseRoomsPageState();
}

class _VChooseRoomsPageState extends State<VChooseRoomsPage> {
  late final ChooseRoomsController controller;

  @override
  void initState() {
    super.initState();
    controller = ChooseRoomsController(widget.currentRoomId);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<VRoom>>(
      valueListenable: controller,
      builder: (_, value, __) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: S
                .of(context)
                .chooseRoom
                .h6
                .size(16),

            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: !controller.isThereSelection ? () => controller.onDone(context) : null,
              child: "${S
                  .of(context)
                  .send} ${controller.selectedCount}/${controller.maxForward}"
                  .h6
                  .size(16),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                cacheExtent: 300,
                itemBuilder: (context, index) {
                  return VRoomItem(
                    room: value[index],
                    isIconOnly: false,
                    onRoomItemLongPress: (room) => controller.onRoomItemPress(room, context),
                    onRoomItemPress: (room) => controller.onRoomItemPress(room, context),
                  );
                },
                itemCount: value.length,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
