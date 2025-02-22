import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_room_page/chat_room_page.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

import '../controllers/chats_search_controller.dart';

class ChatsSearchView extends StatefulWidget {
  const ChatsSearchView({super.key});

  @override
  State<ChatsSearchView> createState() => _ChatsSearchViewState();
}

class _ChatsSearchViewState extends State<ChatsSearchView> {
  late final ChatsSearchController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatsSearchController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.only(left: VPlatforms.isMobile ? 10 : 0),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            S.of(context).cancel,
            style: const TextStyle(
              color: CupertinoColors.activeBlue,
            ),
          ),
        ),
        middle: CupertinoSearchTextField(
          placeholder: S.of(context).search,
          controller: controller.searchController,
          focusNode: controller.searchFocusNode,
          onChanged: (value) {
            controller.onSearch(value);
          },
        ),
      ),
      child: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: controller.data.length,
              itemBuilder: (context, index) {
                final room = controller.data[index];
                return VRoomItem(
                  room: room,
                  onRoomItemPress: (room) => controller.onRoomItemPress(room, context),
                  onRoomItemLongPress: (room) {},
                );
              },
            );
          },
        ),
      ),
    );
  }
}
