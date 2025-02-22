import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'all_tab_controller.dart';

class AllChatTab extends StatefulWidget {
  const AllChatTab({super.key});

  @override
  State<AllChatTab> createState() => _AllChatTabState();
}

class _AllChatTabState extends State<AllChatTab> {
  late final AllTabController controller;

  // final config = VAppConfigController.appConfig;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<AllTabController>();
    controller.onInit();
  }

  Widget _bottomSheet(BuildContext context, VRoom room) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 30),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.chat_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: room.title.text.color(Colors.black).size(20).bold,
        ),
        const SizedBox(height: 60),
        const Divider(
          indent: 20,
          endIndent: 20,
          height: 1,
        ),
        ListTile(
          title: "No staff".text.size(16).color(Colors.black).medium,
          subtitle: 'Click to change staff'.text.regular.size(12),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            size: 24,
          ),
          leading: const Icon(Icons.verified_rounded),
          onTap: () async {
            // String? result = await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => StaffsScreen(freeChatId: widget.info.id)),
            // );
            // if (result != null) {
            //   widget.info.userId = result;
            //   Navigator.pop(context);
            // }
            // this.nameStaff = await getNicknamesByIds(widget.info.userId ?? "");
            // setState(() {});
          },
        ),
        const Divider(
          indent: 20,
          endIndent: 20,
          height: 1,
        ),
        ListTile(
          title: 'View messages'.text.size(16).color(Colors.black).medium,
          subtitle: 'Click to view messages'.text.regular.size(12),
          trailing: const Icon(Icons.keyboard_arrow_right),
          leading: const Icon(
            EvaIcons.messageSquareOutline,
          ),
          onTap: () async {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MessagesScreen(
            //       chatId: widget.info.id,
            //       phoneNumber: '',
            //       isFirebaseChat: false,
            //       title: widget.info.title ?? "",
            //     ),
            //   ),
            // );
          },
        ),
        const Divider(
          indent: 20,
          endIndent: 20,
          height: 1,
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<VSocketStatusEvent>(
            stream: VChatController.I.nativeApi.streams.socketStatusStream,
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data!.isConnected) {
                // return Text(
                //   S.of(context).chats,
                //   style: context.textTheme.bodyMedium,
                // );

                return const SizedBox.shrink();
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    S.of(context).connecting,
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              );
            }),
        Expanded(
          child: Container(),
          // child: VChatPageAdmin(
          //   language: vRoomLanguageModel(context),
          //   showDisconnectedWidget: false,
          //   controller: controller.vRoomController,
          //   onRoomItemPress: (room) {
          //     print("ITEM_ROOM_PRESS: ${room.toString()}");
          //     showModalBottomSheet(
          //       context: context,
          //       isDismissible: true,
          //       builder: (context) => _bottomSheet(
          //         context,
          //         room,
          //       ),
          //     );
          //   },
          //   emptyWidget: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Expanded(
          //         child: Lottie.asset(
          //           AppConstant.emptyMessengerLottiePath,
          //           fit: BoxFit.contain,
          //         ),
          //       )
          //     ],
          //   ), onSearchClicked: () {  },
          // ),
        ),
      ],
    );
  }
}
