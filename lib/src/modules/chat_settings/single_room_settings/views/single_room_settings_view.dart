import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../home/mobile/settings_tab/widgets/settings_list_item_tile.dart';
import '../../widgets/chat_settings_list_section.dart';
import '../../widgets/chat_settings_navigation_bar.dart';
import '../controllers/single_room_settings_controller.dart';
import '../states/single_room_setting_state.dart';

class SingleRoomSettingsView extends StatefulWidget {
  const SingleRoomSettingsView({
    super.key,
    required this.settingsModel,
  });

  final VToChatSettingsModel settingsModel;

  @override
  State<SingleRoomSettingsView> createState() => _SingleRoomSettingsViewState();
}

class _SingleRoomSettingsViewState extends State<SingleRoomSettingsView> {
  late final SingleRoomSettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = SingleRoomSettingsController(widget.settingsModel);
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
      navigationBar: ChatSettingsNavigationBar(
        middle: S.of(context).contactInfo,
        previousPageTitle: S.of(context).back,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder<SLoadingState<SingleRoomSettingState>>(
            valueListenable: controller,
            builder: (context, value, child) {
              return Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () => controller.openFullImage(context),
                    child: VCircleAvatar(
                      vFileSource: VPlatformFile.fromUrl(
                        url: controller.data.settingsModel.image,
                      ),
                      radius: 90,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  value.data.settingsModel.room.realTitle.h6
                      .size(24)
                      .medium
                      .color(context.textTheme.bodyLarge!.color!),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChatSettingsListSection(
                        icon: CupertinoIcons.phone_fill,
                        title: S.of(context).audio,
                        onPressed: !controller.isCallAllowed
                            ? null
                            : () {
                                controller.voiceCall(context);
                              },
                      ),
                      ChatSettingsListSection(
                        icon: CupertinoIcons.videocam_fill,
                        title: S.of(context).video,
                        onPressed: !controller.isCallAllowed
                            ? null
                            : () {
                                controller.videoCall(context);
                              },
                      ),
                      ChatSettingsListSection(
                        icon: CupertinoIcons.search,
                        title: S.of(context).search,
                        onPressed: () {
                          controller.openSearch(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      bottom: 24,
                    ),
                    child: Column(
                      children: [
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          dividerMargin: 0,
                          topMargin: 0,
                          margin: const EdgeInsets.all(10),
                          children: [
                            ValueListenableBuilder(
                              valueListenable: controller,
                              builder: (context, value, child) {
                                if (value.data.user == null) {
                                  return const CupertinoListTile.notched(
                                    title: CupertinoActivityIndicator(),
                                  );
                                }

                                return CupertinoListTile.notched(
                                  title: (value.data.user!.searchUser.bio ??
                                          "${S.of(context).hiIamUse} ${SConstants.appName}")
                                      .h6
                                      .medium
                                      .color(context.textTheme.bodyLarge!.color!)
                                      .size(16),
                                );
                              },
                            )
                          ],
                        ),
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          margin: const EdgeInsets.all(10),
                          dividerMargin: 0,
                          topMargin: 0,
                          children: [
                            SettingsListItemTile(
                              color: Colors.blue,
                              icon: CupertinoIcons.photo,
                              onTap: () {
                                controller.onShowMedia(context);
                              },
                              title: S.of(context).mediaLinksAndDocs,
                            ),
                            SettingsListItemTile(
                              color: Colors.amber,
                              onTap: () {
                                controller.starMessage(context);
                              },
                              icon: CupertinoIcons.star_fill,
                              title: S.of(context).starredMessages,
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
                          ],
                        ),
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          margin: const EdgeInsets.all(10),
                          dividerMargin: 0,
                          topMargin: 0,
                          children: [
                            SettingsListItemTile(
                              color: Colors.green,
                              icon: CupertinoIcons.speaker_2,
                              title: S.of(context).mute,
                              isLoading: value.data.isUpdatingMute,
                              additionalInfo: value.data.settingsModel.room.isMuted
                                  ? Text(S.of(context).on)
                                  : Text(S.of(context).off),
                              onTap: () {
                                controller.updateMute(context);
                              },
                            ),
                            SettingsListItemTile(
                              color: Colors.deepOrangeAccent,
                              icon: CupertinoIcons.person,
                              onTap: () {
                                controller.toUpdateNickName(context);
                              },
                              title: S.of(context).nickname,
                              additionalInfo: value.data.settingsModel.room.nickName == null
                                  ? Text(S.of(context).none)
                                  : Text(
                                      value.data.settingsModel.room.nickName!,
                                    ),
                            ),
                          ],
                        ),
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          margin: const EdgeInsets.all(10),
                          dividerMargin: 0,
                          topMargin: 0,
                          children: [
                            SettingsListItemTile(
                              color: Colors.red,
                              icon: PhosphorIcons.bugDroid,
                              isLoading: value.data.isUpdatingBlock,
                              onTap: () {
                                controller.onBlockUser(context);
                              },
                              textColor: Colors.red,
                              title: value.loadingState == VChatLoadingState.success
                                  ? value.data.user!.isMeBanner
                                      ? S.of(context).unBlock
                                      : S.of(context).block
                                  : S.of(context).loading,
                            ),
                            SettingsListItemTile(
                              color: Colors.red,
                              icon: PhosphorIcons.bugBeetle,
                              title: S.of(context).report,
                              textColor: Colors.red,
                              onTap: () {
                                controller.onReportUser(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
