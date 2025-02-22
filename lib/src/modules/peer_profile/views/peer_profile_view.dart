import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../app/controller/app_controller.dart';
import '../../home/mobile/settings_tab/widgets/settings_list_item_tile.dart';
import '../controllers/peer_profile_controller.dart';
import 'widgets/peer_profile_chat_row.dart';

class PeerProfileView extends StatefulWidget {
  final String peerId;
  final bool isStaff;

  const PeerProfileView({
    super.key,
    required this.peerId,
    this.isStaff = false,
  });

  @override
  State<PeerProfileView> createState() => _PeerProfileViewState();
}

class _PeerProfileViewState extends State<PeerProfileView> {
  late final PeerProfileController controller;
  late final AppController appController;

  bool isStaff = false;

  @override
  void initState() {
    super.initState();
    controller = PeerProfileController(widget.peerId);
    controller.onInit();

    appController = GetIt.I.get<AppController>();

    isStaff = widget.isStaff;
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
        border: Border.all(color: Colors.transparent),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        middle: S
            .of(context)
            .contactInfo
            .h3
            .semiBold
            .color(context.theme.textTheme.bodyLarge!.color!)
            .size(22),
      ),
      child: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            return VAsyncWidgetsBuilder(
              loadingState: controller.loadingState,
              successWidget: () {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () => controller.openFullImage(context),
                          child: controller.data!.searchUser.hasBadge
                              ? VCircleVerifiedAvatar(
                                  vFileSource: VPlatformFile.fromUrl(
                                    url: controller.data!.searchUser.baseUser.userImage,
                                  ),
                                  radius: 90,
                                )
                              : VCircleAvatar(
                                  vFileSource: VPlatformFile.fromUrl(
                                    url: controller.data!.searchUser.baseUser.userImage,
                                  ),
                                  radius: 90,
                                ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          controller.data!.searchUser.baseUser.fullName,
                          style: context.textTheme.bodyLarge,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        (controller.data!.searchUser.bio ??
                                "${S.of(context).hiIamUse} ${SConstants.appName}")
                            .h6
                            .size(16)
                            .color(CupertinoColors.systemGrey),
                        const SizedBox(
                          height: 16,
                        ),
                        PeerProfileChatRow(
                          openChatLoading: controller.isOpeningChat,
                          blockLoading: controller.isBlockingChat,
                          createGroupWith: () => controller.createGroupWith(context),
                          openChatWith: () => controller.openChatWith(context),
                          isMeBanner: controller.data!.isMeBanner,
                          isThereBan: value.data!.getIsThereBan,
                          updateBlock: () => controller.updateBlock(context),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          dividerMargin: 0,
                          topMargin: 0,
                          margin: const EdgeInsets.all(10),
                          children: [
                            CupertinoListTile.notched(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: value.data!.isOnline ? Colors.green : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    value.data!.isOnline
                                        ? S.of(context).online
                                        : S.of(context).offline,
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      color: value.data!.isOnline ? Colors.green : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
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
                              color: Colors.red,
                              icon: CupertinoIcons.ant_circle_fill,
                              onTap: () {
                                controller.reportToAdmin(context);
                              },
                              title: S.of(context).reportUser,
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: appController,
                          builder: (context, value, child) {
                            if (appController.isAdmin) {
                              return Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                margin: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 34,
                                      width: 34,
                                      margin: const EdgeInsets.only(right: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.star_circle_fill,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: "Staff"
                                          .text
                                          .medium
                                          .color(Theme.of(context).textTheme.bodyLarge!.color!),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: controller,
                                      builder: (context, value, child) {
                                        if (controller.isTogglingStaff) {
                                          return const CupertinoActivityIndicator();
                                        }

                                        return CupertinoSwitch(
                                          value: isStaff,
                                          onChanged: (bool value) async {
                                            debugPrint('switched to: $value');
                                            bool result = await controller.toggleStaff();

                                            if (result) {
                                              setState(() {
                                                isStaff = value;
                                              });
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
              onRefresh: controller.getProfileData,
            );
          },
        ),
      ),
    );
  }
}
