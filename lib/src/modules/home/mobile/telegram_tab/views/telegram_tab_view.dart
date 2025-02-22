import 'package:chat_core/chat_core.dart';
import 'package:chat_room_page/chat_room_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constant.dart';
import '../../../../../core/app_config/app_config_controller.dart';
import '../controllers/telegram_tab_controller.dart';

class TelegramTabView extends StatefulWidget {
  const TelegramTabView({super.key});

  @override
  State<TelegramTabView> createState() => _TelegramTabViewState();
}

class _TelegramTabViewState extends State<TelegramTabView> {
  late final TelegramTabController controller;
  final config = VAppConfigController.appConfig;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<TelegramTabController>();
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
              largeTitle: "Workplace".h3.bold.color(Theme.of(context).textTheme.bodyLarge!.color!).size(32),
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
                        return "Workplace".h3.semiBold.color(CupertinoColors.black).size(16);
                      }
                      return const SizedBox.shrink();
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CupertinoActivityIndicator(),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          S.of(context).connecting,
                          style: context.textTheme.bodyMedium,
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
          showDisconnectedWidget: false,
          controller: controller.vRoomController,
          // onRoomItemPress: (room) {
          //   print("ITEM_ROOM_PRESS: ${room.toString()}");
          //
          //   // showModalBottomSheet(
          //   //   context: context,
          //   //   isDismissible: true,
          //   //   builder: (context) => _bottomSheet(
          //   //     context,
          //   //     room,
          //   //   ),
          //   // );
          // },
          emptyWidget: Lottie.asset(
            ClientAppConstant.lottieEmptyList,
            fit: BoxFit.contain,
          ),
          isAdmin: true,
          onSearchClicked: () {
            controller.onSearchClicked(context);
          },
          onCreateNewBroadcast: () {},
          onCreateNewGroup: () {},
        ),
      ),
    );
  }
}
