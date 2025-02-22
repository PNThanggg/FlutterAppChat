import 'package:chat_core/chat_core.dart';
import 'package:chat_room_page/chat_room_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:chat_v2/translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/app_config/app_config_controller.dart';
import '../controllers/rooms_tab_controller.dart';

class RoomsTabView extends StatefulWidget {
  const RoomsTabView({super.key});

  @override
  State<RoomsTabView> createState() => _RoomsTabViewState();
}

class _RoomsTabViewState extends State<RoomsTabView> {
  late final RoomsTabController controller;
  final config = VAppConfigController.appConfig;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<RoomsTabController>();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsetsDirectional.only(
                start: 8,
                end: 12,
              ),
              largeTitle: "Chats".h3.bold.color(Theme.of(context).textTheme.bodyLarge!.color!).size(32),
              // trailing: CupertinoButton(
              //   onPressed: () => controller.onCameraPress(context),
              //   padding: EdgeInsets.zero,
              //   minSize: 0,
              //   child: const Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(
              //         CupertinoIcons.camera,
              //         size: 28,
              //       ),
              //     ],
              //   ),
              // ),
              middle: StreamBuilder<VSocketStatusEvent>(
                  stream: VChatController.I.nativeApi.streams.socketStatusStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null || snapshot.data!.isConnected) {
                      if (innerBoxIsScrolled) {
                        return const Text(
                          "Chats",
                        );
                      }
                      return const SizedBox.shrink();
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CupertinoActivityIndicator(),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).connecting,
                          style: context.cupertinoTextTheme.textStyle,
                        ),
                      ],
                    );
                  }),

              border: innerBoxIsScrolled
                  ? const Border(
                      bottom: BorderSide(
                        color: Color(0x4D000000),
                        width: 0.0, // 0.0 means one physical pixel
                      ),
                    )
                  : null,
            ),
          ];
        },
        body: VChatPage(
          language: vRoomLanguageModel(context),
          onCreateNewBroadcast: config.allowCreateBroadcast
              ? () {
                  controller.createNewBroadcast(this.context);
                }
              : null,
          onSearchClicked: () {
            controller.onSearchClicked(this.context);
          },
          onCreateNewGroup: config.allowCreateGroup
              ? () {
                  controller.createNewGroup(this.context);
                }
              : null,
          appBar: null,
          showDisconnectedWidget: false,
          controller: controller.vRoomController,
        ),
      ),
    );
  }
}
