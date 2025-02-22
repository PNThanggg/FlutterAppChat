import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../home/mobile/settings_tab/widgets/settings_list_item_tile.dart';
import '../../widgets/chat_settings_navigation_bar.dart';
import '../controllers/group_room_settings_controller.dart';
import '../states/group_room_setting_state.dart';

class GroupRoomSettingsView extends StatefulWidget {
  final VToChatSettingsModel settingsModel;

  const GroupRoomSettingsView({super.key, required this.settingsModel});

  @override
  State<GroupRoomSettingsView> createState() => _GroupRoomSettingsViewState();
}

class _GroupRoomSettingsViewState extends State<GroupRoomSettingsView> {
  late final GroupRoomSettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = GroupRoomSettingsController(widget.settingsModel);
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
      navigationBar: ChatSettingsNavigationBar(
        middle: S.of(context).groupInfo,
        previousPageTitle: S.of(context).back,
      ),
      child: SafeArea(
        child: ValueListenableBuilder<LoadingState<GroupRoomSettingState>>(
          valueListenable: controller,
          builder: (context, value, child) => SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => controller.openFullImage(context),
                  child: ValueListenableBuilder<LoadingState<GroupRoomSettingState>>(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      if (value.loadingState != ChatLoadingState.success) {
                        return VCircleAvatar(
                          vFileSource: VPlatformFile.fromUrl(
                            networkUrl: controller.settingsModel.image,
                          ),
                          radius: 90,
                        );
                      }
                      if (controller.groupInfo!.isMeOut) {
                        return VCircleAvatar(
                          vFileSource: VPlatformFile.fromUrl(
                            networkUrl: controller.settingsModel.image,
                          ),
                          radius: 90,
                        );
                      }
                      return Stack(
                        children: [
                          VCircleAvatar(
                            vFileSource: VPlatformFile.fromUrl(
                              networkUrl: controller.settingsModel.image,
                            ),
                            radius: 80,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => controller.openEditImage(context),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: context.isDark ? Theme.of(context).cardColor : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  CupertinoIcons.camera,
                                  color: Colors.blueAccent,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if (value.loadingState != ChatLoadingState.success) {
                      return Text(
                        controller.settingsModel.room.title,
                        style: TextStyle(
                            color: context.theme.textTheme.bodyMedium!.color, fontSize: 25),
                      );
                    }
                    if (controller.groupInfo!.isMeOut) {
                      return Text(
                        controller.settingsModel.room.title,
                        style: context.cupertinoTextTheme.navLargeTitleTextStyle,
                      );
                    }
                    return GestureDetector(
                      onTap: () => controller.openEditTitle(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: controller.settingsModel.room.title.text.medium
                                .size(20)
                                .color(context.theme.textTheme.bodyMedium!.color!)
                                .alignCenter,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ValueListenableBuilder<LoadingState<GroupRoomSettingState>>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    return VAsyncWidgetsBuilder(
                      loadingState: value.loadingState,
                      onRefresh: controller.getData,
                      successWidget: () {
                        final isMeAdminOrSuper = controller.isMeAdminOrSuper;
                        if (value.data.groupInfo!.isMeOut) {
                          return ChatSettingsTileInfo(
                            title: Text(
                              S.of(context).youNotParticipantInThisGroup,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: GestureDetector(
                                  onTap: () => controller.onChangeGroupDescriptionClicked(context),
                                  child: _getGroupBio(context, controller.getGroupDesc),
                                ),
                              ),
                              CupertinoListSection.insetGrouped(
                                backgroundColor: context.theme.scaffoldBackgroundColor,
                                separatorColor: Colors.transparent,
                                hasLeading: false,
                                margin: const EdgeInsets.all(10),
                                dividerMargin: 0,
                                topMargin: 0,
                                children: [
                                  SettingsListItemTile(
                                    color: Colors.lightGreen,
                                    icon: CupertinoIcons.search,
                                    title: S.of(context).search,
                                    onTap: () {
                                      controller.openSearch(context);
                                    },
                                  ),
                                  SettingsListItemTile(
                                    color: Colors.cyan,
                                    icon: CupertinoIcons.person_2,
                                    title: S.of(context).members,
                                    onTap: () {
                                      controller.onGoShowMembers(context);
                                    },
                                    additionalInfo:
                                        Text(controller.groupInfo!.membersCount.toString()),
                                  ),
                                  SettingsListItemTile(
                                    color: Colors.green,
                                    icon: CupertinoIcons.eye,
                                    isLoading: value.data.isUpdatingOneSeen,
                                    title: "One time seen",
                                    onTap: () {
                                      controller.updateOneTimeSeen(context);
                                    },
                                    additionalInfo: value.data.settingsModel.room.isOneSeen
                                        ? Text(S.of(context).yes)
                                        : Text(S.of(context).no),
                                  ),
                                  if (isMeAdminOrSuper)
                                    SettingsListItemTile(
                                      color: Colors.green,
                                      onTap: () {
                                        controller.addParticipantsToGroup(context);
                                      },
                                      icon: CupertinoIcons.add,
                                      title: S.of(context).addMembers,
                                    ),
                                ],
                              ),
                              CupertinoListSection.insetGrouped(
                                backgroundColor: context.theme.scaffoldBackgroundColor,
                                separatorColor: Colors.transparent,
                                hasLeading: false,
                                margin: const EdgeInsets.all(10),
                                dividerMargin: 0,
                                topMargin: 0,
                                children: [
                                  SettingsListItemTile(
                                    color: Colors.blue,
                                    icon: CupertinoIcons.photo,
                                    onTap: () {
                                      controller.openChatMedia(context);
                                    },
                                    title: S.of(context).mediaLinksAndDocs,
                                  ),
                                  SettingsListItemTile(
                                    color: Colors.amber,
                                    icon: CupertinoIcons.star_fill,
                                    title: S.of(context).starredMessage,
                                    onTap: () {
                                      controller.openStarredMessages(context);
                                    },
                                  ),
                                  SettingsListItemTile(
                                    color: Colors.deepOrangeAccent,
                                    icon: CupertinoIcons.person,
                                    title: S.of(context).nickname,
                                    onTap: () {
                                      controller.toUpdateNickName(context);
                                    },
                                    additionalInfo: value.data.settingsModel.room.nickName == null
                                        ? Text(S.of(context).none)
                                        : Text(
                                            value.data.settingsModel.room.nickName!,
                                          ),
                                  ),
                                ],
                              ),
                              CupertinoListSection.insetGrouped(
                                backgroundColor: context.theme.scaffoldBackgroundColor,
                                separatorColor: Colors.transparent,
                                hasLeading: false,
                                margin: const EdgeInsets.all(10),
                                dividerMargin: 0,
                                topMargin: 0,
                                children: [
                                  SettingsListItemTile(
                                    color: Colors.green,
                                    isLoading: value.data.isUpdatingMute,
                                    icon: CupertinoIcons.speaker_2,
                                    title: S.of(context).mute,
                                    onTap: () {
                                      controller.updateMute(context);
                                    },
                                    additionalInfo: value.data.settingsModel.room.isMuted
                                        ? Text(S.of(context).yes)
                                        : Text(S.of(context).no),
                                  ),
                                  SettingsListItemTile(
                                    color: Colors.red,
                                    isLoading: value.data.isUpdatingExitGroup,
                                    textColor: Colors.red,
                                    onTap: () => controller.leaveGroup(context),
                                    title: S.of(context).exitGroup,
                                    icon: PhosphorIconsLight.bug,
                                  ),
                                  // SettingsListItemTile(
                                  //   color: Colors.red,
                                  //   textColor: Colors.red,
                                  //   onTap: () => controller.reportGroup(context),
                                  //   title: "Report Group",
                                  //   icon: PhosphorIcons.bug,
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getGroupBio(BuildContext context, String? desc) {
    if (desc == null) {
      return ChatSettingsTileInfo(
        title: Text(
          S.of(context).clickToAddGroupDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blueAccent,
              ),
        ),
      );
    }
    return ChatSettingsTileInfo(
      title: Text(desc),
    );
  }
}
