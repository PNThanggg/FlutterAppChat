import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../admin.dart';
import 'dashboard_controller.dart';
import 'models/dash_grid_item_model.dart';
import 'widgets/animated_item_widget.dart';
import 'widgets/custom_card_statistics.dart';
import 'widgets/dashboard_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final DashboardController controller = DashboardController();
  final AppSizeHelper sizer = GetIt.I.get<AppSizeHelper>();

  @override
  void initState() {
    controller.onInit();
    super.initState();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  SliverGridDelegateWithFixedCrossAxisCount get gridDelegate => SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height * 0.25),
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      );

  SliverGridDelegateWithFixedCrossAxisCount get wideGridDelegate => SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      );

  Widget _getDivider({required String title, required int number, required IconData icon}) {
    // final formattedNumber = number.numeral();

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: const Color(0xFFD1D3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: primaryColor,
          ),
          const SizedBox(
            width: 12,
          ),
          // ("$title $formattedNumber").text.medium.color(Colors.white70).alignStart,
          title.text.medium.color(primaryColor).alignStart,
        ],
      ),
    );
  }

  Widget _buildRowButton(
    BuildContext context, {
    required String title,
    required Function onPress,
  }) {
    return InkWell(
      onTap: () {
        onPress.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF282A4D),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.verified_rounded,
              size: 24,
              color: primaryColor,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: title.text.medium.color(Colors.white70).alignStart,
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowGridView(List<DashGridItemModel> data) {
    return LiveGrid(
      shrinkWrap: true,
      padding: EdgeInsets.zero.copyWith(
        bottom: 12,
      ),
      showItemDuration: const Duration(milliseconds: 100),
      showItemInterval: const Duration(milliseconds: 100),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate: VPlatforms.isMobile ? gridDelegate : wideGridDelegate,
      itemBuilder: (context, index, animation) => AnimatedItemWidget(
        index: index,
        animation: animation,
        data: data,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) {
          if (value.loadingState == VChatLoadingState.loading) {
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

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 125 * 3,
                  toolbarHeight: 80,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  pinned: true,
                  titleSpacing: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shadowColor: Colors.black.withOpacity(0.8),
                  surfaceTintColor: Colors.white,
                  title: Container(
                    margin: const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      0,
                    ),
                    child: "Dashboard".h6.size(24).semiBold.color(primaryColor),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      margin: EdgeInsets.only(
                        left: 16,
                        top: MediaQuery.of(context).padding.top + 80,
                        right: 16,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: DashboardCard(
                                  cardColor: const Color(0xFFF29B38),
                                  label: S.current.audioCall,
                                  value: "${controller.data.messagesCounter.voiceCallMessages}",
                                  iconData: Icons.phone_rounded,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: DashboardCard(
                                  cardColor: const Color(0xFFE15141),
                                  label: S.current.videoCallMessages,
                                  value: "${controller.data.messagesCounter.videoCallMessages}",
                                  iconData: Icons.video_call_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: DashboardCard(
                                  cardColor: const Color(0xFF67AC5B),
                                  label: S.current.android,
                                  value: "${controller.data.usersDevices.android}",
                                  iconData: Icons.android_rounded,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: DashboardCard(
                                  cardColor: const Color(0xff49a6ef),
                                  label: S.current.ios,
                                  value: "${controller.data.usersDevices.ios}",
                                  iconData: Icons.phone_iphone_rounded,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: DashboardCard(
                                  cardColor: const Color(0xFF9737B3),
                                  label: S.current.web,
                                  value: "${controller.data.usersDevices.web}",
                                  iconData: Icons.desktop_mac_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: DashboardCard(
                                  cardColor: const Color(0xFFD147AD),
                                  label: S.of(context).users,
                                  value: "${controller.data.usersData.totalUsersCount}",
                                  iconData: Icons.people_rounded,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: DashboardCard(
                                  cardColor: const Color(0xFF7A52E0),
                                  label: 'Media',
                                  value: "${controller.data.messagesCounter.imageMessages}",
                                  iconData: Icons.folder_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: ScrollConfiguration(
              behavior: DisableGlowBehavior(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16).copyWith(
                  top: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCardStatistics(
                      context: context,
                      cardColor: const Color(0xFF282A4D),
                      cardColorInner: const Color(0xFF2D325A),
                      l: "${controller.data.usersData.totalUsersCount}",
                      lbase: '${S.current.total} ${S.current.users}',
                      r1: '${controller.data.usersData.userStatusCounter['accepted']}',
                      r1base: S.current.accepted,
                      r2: '${controller.data.usersData.banned}',
                      r2base: S.current.blocked,
                    ),
                    _buildRowButton(
                      context,
                      title: "Staffs",
                      onPress: () {
                        context.toPage(
                          const AllStaffScreen(),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildRowButton(
                      context,
                      title: "Violations",
                      onPress: () {
                        context.toPage(
                          const ViolationScreen(),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _getDivider(
                      title: S.of(context).users,
                      number: controller.data.usersData.totalUsersCount,
                      icon: Icons.person_rounded,
                    ),
                    _buildRowGridView(controller.usersListItem),
                    _getDivider(
                      title: S.of(context).devices,
                      number: controller.data.usersDevices.all,
                      icon: Icons.devices_rounded,
                    ),
                    _buildRowGridView(controller.devicesListItem),
                    _getDivider(
                      title: S.of(context).visits,
                      number: controller.data.usersCountries.length,
                      icon: Icons.devices_rounded,
                    ),
                    _buildRowGridView(controller.statistics),
                    _getDivider(
                      title: S.of(context).messageCounter,
                      number: controller.data.messagesCounter.messages,
                      icon: Icons.message_rounded,
                    ),
                    _buildRowGridView(controller.messagesCounter),
                    _getDivider(
                      title: S.of(context).roomCounter,
                      number: controller.data.roomCounter.total,
                      icon: Icons.chat_bubble_outline_rounded,
                    ),
                    _buildRowGridView(controller.roomCounter),
                    const SizedBox(
                      height: 60,
                    )
                    // getDivider(S.of(context).countries, controller.data.usersCountries.length),
                    // LiveGrid(
                    //   shrinkWrap: true,
                    //   padding: EdgeInsets.zero,
                    //   showItemDuration: const Duration(milliseconds: 100),
                    //   showItemInterval: const Duration(milliseconds: 100),
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: controller.countryListItem.length,
                    //   gridDelegate: gridDelegate,
                    //   itemBuilder: (context, index, animation) => _buildAnimatedItem(
                    //     context,
                    //     index,
                    //     animation,
                    //     controller.countryListItem,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
