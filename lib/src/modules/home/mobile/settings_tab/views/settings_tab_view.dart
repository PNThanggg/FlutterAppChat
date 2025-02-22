import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../chat_settings/chat_star_messages/views/chat_star_messages_page.dart';
import '../../../home_controller/widgets/chat_un_read_counter.dart';
import '../../../settings_modules/blocked_contacts/views/blocked_contacts_page.dart';
import '../../../settings_modules/devices/linked_devices/views/linked_devices_page.dart';
import '../../../settings_modules/my_account/views/my_account_page.dart';
import '../controllers/settings_tab_controller.dart';
import '../states/setting_state.dart';
import '../widgets/settings_list_item_tile.dart';

class SettingsTabView extends StatefulWidget {
  const SettingsTabView({super.key});

  @override
  State<SettingsTabView> createState() => _SettingsTabViewState();
}

class _SettingsTabViewState extends State<SettingsTabView> {
  final SettingsTabController controller = SettingsTabController();

  @override
  void initState() {
    super.initState();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: CupertinoPageScaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CupertinoSliverNavigationBar(
              largeTitle: S.of(context).settings.h3.bold.color(context.theme.textTheme.bodyLarge!.color!).size(32),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(bottom: BorderSide.none),
            )
          ],
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: VPlatforms.isMobile ? 15 : 0),
            child: ValueListenableBuilder<LoadingState<SettingState>>(
              valueListenable: controller,
              builder: (_, value, ___) {
                return Column(
                  children: [
                    CupertinoListSection(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.theme.cardColor,
                      ),
                      additionalDividerMargin: 0,
                      dividerMargin: 0,
                      hasLeading: false,
                      separatorColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      children: [
                        CustomListTile(
                          //add is verified to image
                          title: AppAuth.myProfile.baseUser.fullName,
                          padding: const EdgeInsets.all(16),
                          leading: AppAuth.myProfile.isPrime
                              ? VCircleVerifiedAvatar(
                                  vFileSource: VPlatformFile.fromUrl(
                                    networkUrl: AppAuth.myProfile.baseUser.userImage,
                                  ),
                                )
                              : VCircleAvatar(
                                  vFileSource: VPlatformFile.fromUrl(
                                    networkUrl: AppAuth.myProfile.baseUser.userImage,
                                  ),
                                ),
                          subtitle: AppAuth.myProfile.bio,
                          trailing: GestureDetector(
                            onTap: () {
                              controller.onThemeChange(context);
                            },
                            child: Icon(
                              controller.data.isDarkMode ? CupertinoIcons.sun_min : CupertinoIcons.moon_fill,
                              color: controller.data.isDarkMode ? Colors.amberAccent : Colors.grey,
                            ),
                          ),
                        ),
                        SettingsListItemTile(
                          color: Colors.blue,
                          title: S.of(context).account,
                          onTap: () async {
                            await context.toPage(const MyAccountPage());
                            controller.update();
                          },
                          icon: CupertinoIcons.profile_circled,
                          textColor: context.theme.textTheme.bodyMedium?.color,
                        )
                      ],
                    ),
                    CupertinoListSection(
                      dividerMargin: 0,
                      separatorColor: Colors.transparent,
                      topMargin: 10,
                      hasLeading: false,
                      backgroundColor: Colors.transparent,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.theme.cardColor,
                      ),
                      children: [
                        SettingsListItemTile(
                          color: Colors.amber,
                          title: S.of(context).starredMessages,
                          onTap: () => context.toPage(const ChatStarMessagesPage()),
                          icon: CupertinoIcons.star_fill,
                          textColor: context.theme.textTheme.bodyMedium?.color,
                        ),
                        SettingsListItemTile(
                          color: Colors.grey,
                          title: S.of(context).linkedDevices,
                          onTap: () => context.toPage(const LinkedDevicesPage()),
                          icon: CupertinoIcons.device_laptop,
                          textColor: context.theme.textTheme.bodyMedium?.color,
                        ),
                        // SettingsListItemTile(
                        //   color: Colors.deepOrange,
                        //   title: S.of(context).language,
                        //   onTap: () => controller.onLanguageChange(context),
                        //   additionalInfo: value.data.language.text,
                        //   icon: Icons.language,
                        //   textColor: context.theme.textTheme.bodyMedium?.color,
                        // ),
                        // SettingsListItemTile(
                        //   color: Colors.amber,
                        //   title: S.of(context).adminNotification,
                        //   onTap: () => context.toPage(const AdminNotificationPage()),
                        //   icon: CupertinoIcons.app_badge_fill,
                        //   textColor: context.theme.textTheme.bodyMedium?.color,
                        // ),
                      ],
                    ),
                    CupertinoListSection(
                      dividerMargin: 0,
                      topMargin: 10,
                      hasLeading: false,
                      backgroundColor: Colors.transparent,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.theme.cardColor,
                      ),
                      separatorColor: Colors.transparent,
                      children: [
                        // SettingsListItemTile(
                        //   color: Colors.indigo,
                        //   title: S.of(context).myPrivacy,
                        //   onTap: () => context.toPage(const MyPrivacyPage()),
                        //   icon: Icons.privacy_tip_outlined,
                        //   textColor: context.theme.textTheme.bodyMedium?.color,
                        // ),
                        SettingsListItemTile(
                          color: Colors.red,
                          title: S.of(context).blockedUsers,
                          onTap: () => context.toPage(const BlockedContactsPage()),
                          icon: CupertinoIcons.ant,
                          textColor: context.theme.textTheme.bodyMedium?.color,
                        ),
                        SettingsListItemTile(
                          color: Colors.grey,
                          title: S.of(context).inAppAlerts,
                          onTap: () => controller.onChangeAppNotifications(context),
                          icon: CupertinoIcons.app_badge,
                          additionalInfo: value.data.inAppAlerts
                              ? Text(S.of(context).on, style: context.theme.textTheme.bodyMedium)
                              : Text(
                                  S.of(context).off,
                                  style: context.theme.textTheme.bodyMedium,
                                ),
                          textColor: context.theme.textTheme.bodyMedium?.color,
                        ),
                        if (VPlatforms.isMobile)
                          SettingsListItemTile(
                            color: Colors.green,
                            title: S.of(context).storageAndData,
                            onTap: () => controller.onStorageClick(context),
                            icon: CupertinoIcons.wifi,
                            textColor: context.theme.textTheme.bodyMedium?.color,
                          ),
                      ],
                    ),
                    CupertinoListSection(
                      dividerMargin: 0,
                      separatorColor: Colors.transparent,
                      topMargin: 10,
                      hasLeading: false,
                      backgroundColor: Colors.transparent,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.theme.cardColor,
                      ),
                      children: [
                        // SettingsListItemTile(
                        //   color: Colors.blue,
                        //   title: S.of(context).help,
                        //   onTap: () => context.toPage(const HelpPage()),
                        //   icon: CupertinoIcons.question,
                        //   textColor: context.theme.textTheme.bodyMedium?.color,
                        // ),
                        // SettingsListItemTile(
                        //   color: Colors.grey,
                        //   title: S.of(context).tellAFriend,
                        //   onTap: () => controller.tellAFriend(context),
                        //   icon: CupertinoIcons.heart_fill,
                        //   textColor: context.theme.textTheme.bodyMedium?.color,
                        // ),
                        SettingsListItemTile(
                          color: Colors.blueAccent,
                          title: "Test notification",
                          onTap: () => controller.testNotification(context),
                          icon: Icons.notifications_none_rounded,
                          trailing: Icon(context.isRtl ? CupertinoIcons.chevron_back : CupertinoIcons.chevron_forward),
                          textColor: context.theme.textTheme.bodyMedium?.color,
                        ),
                        SettingsListItemTile(
                          color: Colors.green,
                          title: S.of(context).checkForUpdates,
                          onTap: () => controller.checkForUpdates(context),
                          icon: CupertinoIcons.refresh_thick,
                          trailing: controller.versionCheckerController.value.isNeedUpdates
                              ? Row(
                                  children: [
                                    const ChatUnReadWidget(
                                      unReadCount: 1,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(context.isRtl ? CupertinoIcons.chevron_back : CupertinoIcons.chevron_forward),
                                  ],
                                )
                              : null,
                          textColor: context.theme.textTheme.bodyMedium?.color,
                        ),
                        SettingsListItemTile(
                          color: Colors.grey,
                          title: "Clear cache",
                          onTap: () => controller.clearDatabase(),
                          icon: Icons.cleaning_services_rounded,
                          textColor: context.theme.textTheme.bodyMedium?.color,
                        ),
                        SettingsListItemTile(
                          color: Colors.red,
                          title: S.of(context).logOut,
                          onTap: () => controller.logout(context),
                          icon: PhosphorIconsLight.arrowsOut,
                          textColor: context.theme.textTheme.bodyMedium?.color,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
