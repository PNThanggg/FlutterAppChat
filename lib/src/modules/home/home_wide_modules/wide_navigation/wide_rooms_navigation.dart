import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_room_page/chat_room_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_v2/translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../../../constant.dart';
import '../../../../core/app_config/app_config_controller.dart';
import '../../../app/controller/app_controller.dart';
import 'no_animation_page_route.dart';

class WideRoomsNavigation extends StatefulWidget {
  final VoidCallback onShowSettings;
  final VoidCallback onNewChat;
  final VoidCallback onOpenStory;
  final VoidCallback onCreateNewBroadcast;
  final VoidCallback onCreateNewGroup;
  final VoidCallback onSearchClicked;
  final VRoomController vRoomController;

  final Function(VRoom room)? onRoomItemPress;

  const WideRoomsNavigation({
    super.key,
    required this.onShowSettings,
    required this.onNewChat,
    required this.onCreateNewBroadcast,
    required this.onCreateNewGroup,
    required this.onOpenStory,
    required this.onSearchClicked,
    required this.vRoomController,
    this.onRoomItemPress,
  });

  static final navKey = GlobalKey<NavigatorState>();

  @override
  State<WideRoomsNavigation> createState() => _WideRoomsNavigationState();
}

class _WideRoomsNavigationState extends State<WideRoomsNavigation>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  final sizer = GetIt.I.get<AppSizeHelper>();
  final config = VAppConfigController.appConfig;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: WideRoomsNavigation.navKey,
      initialRoute: 'chats',
      onGenerateRoute: (settings) {
        return NoAnimationPageRoute(
          builder: (context) {
            final isSmall = sizer.isSmall(context);

            return Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      VChatPage(
                        key: const PageStorageKey('tab2'),
                        appBar: CupertinoListTile(
                          padding: EdgeInsets.zero,
                          title: VCircleAvatar(
                            vFileSource: VPlatformFile.fromUrl(
                              networkUrl: AppAuth.myProfile.baseUser.userImage,
                            ),
                            radius: 20,
                          ),
                          trailing: Row(
                            children: [
                              CupertinoButton(
                                onPressed: widget.onShowSettings,
                                child: const Icon(CupertinoIcons.settings),
                              ),
                            ],
                          ),
                        ),
                        emptyWidget: Lottie.asset(
                          ClientAppConstant.lottieEmptyList,
                        ),
                        onCreateNewBroadcast:
                            config.allowCreateBroadcast ? widget.onCreateNewBroadcast : null,
                        onCreateNewGroup: config.allowCreateGroup ? widget.onCreateNewGroup : null,
                        isAdmin: true,
                        isShowMember: GetIt.I.get<AppController>().isAdmin,
                        language: vRoomLanguageModel(context),
                        controller: widget.vRoomController,
                        useIconForRoomItem: isSmall,
                        onRoomItemPress: widget.onRoomItemPress,
                        onSearchClicked: widget.onSearchClicked,
                      ),
                      VChatPage(
                        key: const PageStorageKey('tab1'),
                        appBar: CupertinoListTile(
                          padding: EdgeInsets.zero,
                          title: VCircleAvatar(
                            vFileSource: VPlatformFile.fromUrl(
                              networkUrl: AppAuth.myProfile.baseUser.userImage,
                            ),
                            radius: 21,
                          ),
                          trailing: Row(
                            children: [
                              CupertinoButton(
                                onPressed: widget.onShowSettings,
                                child: const Icon(CupertinoIcons.settings),
                              ),
                              CupertinoButton(
                                onPressed: widget.onNewChat,
                                child: const Icon(CupertinoIcons.chat_bubble_text),
                              ),
                            ],
                          ),
                        ),
                        emptyWidget: Lottie.asset(
                          ClientAppConstant.lottieEmptyList,
                        ),
                        onSearchClicked: widget.onSearchClicked,
                        language: vRoomLanguageModel(context),
                        onCreateNewBroadcast:
                            config.allowCreateBroadcast ? widget.onCreateNewBroadcast : null,
                        onCreateNewGroup: config.allowCreateGroup ? widget.onCreateNewGroup : null,
                        controller: widget.vRoomController,
                        useIconForRoomItem: isSmall,
                        onRoomItemPress: widget.onRoomItemPress,
                      ),
                    ],
                  ),
                ),
                TabBar(
                  indicatorColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.blue,
                  tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.work_rounded,
                      ),
                      text: 'Workspaces',
                    ),
                    Tab(
                      icon: Icon(Icons.chat_rounded),
                      text: 'Chats',
                    ),
                  ],
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
