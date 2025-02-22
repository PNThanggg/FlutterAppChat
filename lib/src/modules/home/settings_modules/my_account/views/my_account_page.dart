import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../core/api_service/profile/profile_api_service.dart';
import '../../../mobile/settings_tab/widgets/settings_list_item_tile.dart';
import '../controllers/my_account_controller.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late final MyAccountController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        border: Border.all(color: Colors.transparent),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        middle: Text(
          AppAuth.myProfile.baseUser.fullName,
          style: TextStyle(
            color: context.theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: VPlatforms.isMobile ? 15 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ChatSettingsTileInfo(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        CupertinoListTile(
                          title: S
                              .of(context)
                              .updateYourProfile
                              .h6
                              .maxLine(2)
                              .size(14)
                              .color(Colors.grey),
                          leadingSize: 56,
                          padding: EdgeInsets.zero,
                          leading: GestureDetector(
                            onTap: () => controller.updateUserImage(context),
                            child: VCircleAvatar(
                              vFileSource: VPlatformFile.fromUrl(
                                url: AppAuth.myProfile.baseUser.userImage,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Divider(
                          color: Colors.grey.shade100,
                          height: 1,
                        ),
                        SettingsListItemTile(
                          title: AppAuth.myProfile.baseUser.fullName,
                          trailing: const Icon(Icons.edit),
                          onTap: () => controller.updateUserName(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  S.of(context).email.toUpperCase().h6.color(Colors.grey).size(12),
                  const SizedBox(
                    height: 8,
                  ),
                  ChatSettingsTileInfo(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    title: Text(
                      AppAuth.myProfile.email,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  S.of(context).about.toUpperCase().h6.color(Colors.grey).size(12),
                  const SizedBox(
                    height: 8,
                  ),
                  ChatSettingsTileInfo(
                    title: Text(
                      AppAuth.myProfile.userBio,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    trailing: const Icon(Icons.edit),
                    onPressed: () => controller.updateUserBio(context),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  S.of(context).password.toUpperCase().h6.color(Colors.grey).size(12),
                  const SizedBox(
                    height: 8,
                  ),
                  ChatSettingsTileInfo(
                    title: Text(
                      S.of(context).updateYourPassword,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    trailing: const Icon(Icons.edit),
                    onPressed: () => controller.updateUserPassword(context),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ChatSettingsTileInfo(
                    title: Text(
                      S.of(context).deleteMyAccount,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    trailing: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    onPressed: () => controller.deleteMyAccount(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = MyAccountController(GetIt.I.get<ProfileApiService>());
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
