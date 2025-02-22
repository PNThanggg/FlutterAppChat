import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../color_schemes.g.dart';
import 'user_profile_controller.dart';

class UserProfile extends StatefulWidget {
  final String id;

  const UserProfile({
    super.key,
    required this.id,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late final UserProfileController controller;
  final sizer = GetIt.I.get<AppSizeHelper>();

  @override
  void initState() {
    controller = UserProfileController(widget.id);
    controller.onInit();
    super.initState();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: S.of(context).userProfile.h6.size(20).semiBold.color(Colors.black),
        backgroundColor: headerColor,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (_, __, ___) {
          final loadingState = controller.loadingState;

          if (loadingState == VChatLoadingState.loading) {
            return const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  color: Colors.black,
                ),
              ),
            );
          }

          final countries = controller.data.userCountries;
          final reports = controller.data.userReports;
          final roomCounter = controller.data.roomCounter;
          final userDevices = controller.data.userDevices;
          final messagesCounter = controller.data.messagesCounter;

          return Center(
            child: Container(
              alignment: Alignment.topCenter,
              constraints: sizer.isWide(context) ? BoxConstraints(maxWidth: context.width * .6) : null,
              child: ScrollConfiguration(
                behavior: DisableGlowBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top + 12),
                      VCircleAvatar(
                        vFileSource: VPlatformFile.fromUrl(
                          url: controller.data.user.userImage,
                        ),
                        radius: 100,
                      ),
                      const SizedBox(height: 5),
                      controller.data.user.fullName.h4.color(Colors.black),
                      const SizedBox(height: 5),
                      (controller.data.user.isOnline ? S.of(context).online : S.of(context).offline,).toString().b1.color(Colors.black),
                      const SizedBox(height: 5),
                      ExpansionTile(
                        title: S.of(context).userInfo.text.color(Colors.black),
                        subtitle: S.of(context).clickToSeeAllUserInformations.b2.color(Colors.black),
                        children: [
                          ListTile(
                            title: S.of(context).email.b1.color(Colors.black),
                            subtitle: controller.data.user.email.b2.color(Colors.black),
                          ),
                          ListTile(
                            title: S.of(context).fullName.b1.color(Colors.black),
                            subtitle: controller.data.user.fullName.b2.color(Colors.black),
                          ),
                          ListTile(
                            title: S.of(context).bio.b1.color(Colors.black),
                            subtitle: (controller.data.user.bio ?? S.of(context).noBio).b2.color(Colors.black),
                          ),
                          ListTile(
                            title: S.of(context).verifiedAt.b1.color(Colors.black),
                            subtitle: controller.data.user.verifiedAt.toString().b2.color(Colors.black),
                          ),
                          ListTile(
                            title: S.of(context).registerStatus.b1.color(Colors.black),
                            subtitle: controller.data.user.registerStatus.b2.color(Colors.black),
                            onTap: controller.data.user.registerStatus == RegisterStatus.pending.name ? () => controller.acceptUser(context) : null,
                            trailing: controller.data.user.registerStatus == RegisterStatus.pending.name
                                ? const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  )
                                : null,
                          ),
                          ListTile(
                            title: S.of(context).registerMethod.b1.color(Colors.black),
                            subtitle: controller.data.user.registerMethod.b2.color(Colors.black),
                          ),
                          ListTile(
                            onTap: () => controller.blockUser(context),
                            title: S.of(context).banTo.b1.color(Colors.black),
                            subtitle: controller.data.user.banTo.toString().b2.color(Colors.black),
                            trailing: const Icon(Icons.edit),
                          ),
                          ListTile(
                            onTap: () => controller.deleteUser(context),
                            title: S.of(context).deletedAt.b1.color(Colors.black),
                            subtitle: controller.data.user.deletedAt.toString().b2.color(Colors.black),
                            trailing: const Icon(Icons.edit),
                          ),
                          ListTile(
                            onTap: () => controller.primeUser(context),
                            //todo trans
                            title: "Is prime".b1.color(Colors.black),
                            subtitle: controller.data.user.isPrime.toString().b2.color(Colors.black),
                            trailing: const Icon(Icons.edit),
                          ),
                          ListTile(
                            onTap: () => controller.hasBadgeUser(context),
                            title: S.of(context).verified.b1.color(Colors.black),
                            subtitle: controller.data.user.hasBadge.toString().b2.color(Colors.black),
                            trailing: const Icon(Icons.edit),
                          ),
                          ListTile(
                            title: S.of(context).createdAt.b1.color(Colors.black),
                            subtitle: DateFormat.yMd(
                              Localizations.localeOf(context).languageCode,
                            ).format(controller.data.user.createdAt).toString().b2.color(Colors.black),
                          ),
                          ListTile(
                              title: S.of(context).updatedAt.b1.color(Colors.black),
                              subtitle: DateFormat.yMd(
                                Localizations.localeOf(context).languageCode,
                              ).format(controller.data.user.updatedAt).toString().b2.color(Colors.black)),
                        ],
                      ),
                      ExpansionTile(
                        title: "${S.of(context).country} ${countries.length}".b1.color(Colors.black),
                        subtitle: S.of(context).clickToSeeAllUserCountries.b2.color(Colors.black),
                        children: controller.data.userCountries
                            .map(
                              (e) => ListTile(
                                leading: Text(e.emoji),
                                title: e.name.b1.color(Colors.black),
                                subtitle: e.code.b2.color(Colors.black),
                              ),
                            )
                            .toList(),
                      ),
                      ExpansionTile(
                        title: "${S.of(context).messages} ${messagesCounter.messages}".b1.color(Colors.black),
                        subtitle: S.of(context).clickToSeeAllUserMessagesDetails.b2.color(Colors.black),
                        children: controller.messages
                            .map(
                              (e) => ListTile(
                                title: e.title.text.color(Colors.black),
                                subtitle: e.value.text.color(Colors.black),
                              ),
                            )
                            .toList(),
                      ),
                      ExpansionTile(
                        title: "${S.of(context).chats} ${roomCounter.total}".b1.color(Colors.black),
                        subtitle: S.of(context).clickToSeeAllUserRoomsDetails.b2.color(Colors.black),
                        children: controller.rooms
                            .map(
                              (e) => ListTile(
                                title: e.title.text.color(Colors.black),
                                subtitle: e.value.text.color(Colors.black),
                              ),
                            )
                            .toList(),
                      ),
                      ExpansionTile(
                        title: "${S.of(context).devices} ${userDevices.length}".b1.color(Colors.black),
                        subtitle: S.of(context).clickToSeeAllUserDevicesDetails.b2.color(Colors.black),
                        children: userDevices
                            .map(
                              (e) => ListTile(
                                title: e.platform.text.color(Colors.black),
                                subtitle: format(
                                  e.lastSeenAt,
                                  locale: Localizations.localeOf(context).countryCode,
                                ).text.color(Colors.black),
                                trailing: "${S.of(context).visits} ${e.visits}".text.color(Colors.black),
                              ),
                            )
                            .toList(),
                      ),
                      ExpansionTile(
                        title: "${S.of(context).reports} ${reports.length}".b1.color(Colors.black),
                        subtitle: S.of(context).clickToSeeAllUserReports.b2.color(Colors.black),
                        children: reports
                            .map(
                              (e) => ListTile(
                                dense: false,
                                leading: VCircleAvatar(
                                  vFileSource: VPlatformFile.fromUrl(
                                    url: e.reporter.userImage,
                                  ),
                                  radius: 20,
                                ),
                                title: e.reporter.fullName.b1.color(Colors.black),
                                subtitle: e.content.b2.color(Colors.black),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
