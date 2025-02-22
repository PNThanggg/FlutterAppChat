import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../../app/controller/app_controller.dart';
import '../../home_wide_modules/home/view/home_wide_view.dart';
import '../../mobile/admin_tab/admin_tab.dart';
import '../../mobile/calls_tab/views/calls_tab_view.dart';
import '../../mobile/rooms_tab/views/rooms_tab_view.dart';
import '../../mobile/settings_tab/views/settings_tab_view.dart';
import '../../mobile/telegram_tab/views/telegram_tab_view.dart';
import '../../mobile/users_tab/views/users_tab_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/chat_un_read_counter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final HomeController controller;
  final AppController appController = GetIt.I.get<AppController>();
  final AppSizeHelper sizer = GetIt.I.get<AppSizeHelper>();

  List<Widget> listTab = [
    const TelegramTabView(),
    const RoomsTabView(),
    const CallsTabView(),
    const UsersTabView(),
    const SettingsTabView(),
  ];

  List<Widget> listTabAdmin = [
    const TelegramTabView(),
    const RoomsTabView(),
    const AdminTab(),
    const SettingsTabView(),
  ];

  List<BottomNavigationBarItem> listBottomItem(BuildContext context, HomeController controller) =>
      <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(LineAwesomeIcons.telegram),
          label: "Workplace",
          tooltip: "Workplace",
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.chat_bubble_2),
          // label: S.of(context).chats,
          label: "Chats",
          tooltip: S.of(context).chats,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.phone),
          label: S.of(context).phone,
          tooltip: S.of(context).phone,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.person_2),
          label: S.of(context).users,
          tooltip: S.of(context).users,
        ),
        BottomNavigationBarItem(
          icon: ValueListenableBuilder<SVersion>(
            valueListenable: controller.versionCheckerController,
            builder: (context, value, child) {
              return Stack(
                children: [
                  const Icon(CupertinoIcons.settings),
                  PositionedDirectional(
                    end: 0,
                    child: ChatUnReadWidget(
                      unReadCount: value.isNeedUpdates ? 1 : 0,
                      width: 15,
                      height: 15,
                    ),
                  )
                ],
              );
            },
          ),
          label: S.of(context).settings,
          tooltip: S.of(context).settings,
        ),
      ];

  List<BottomNavigationBarItem> listBottomItemAdmin(BuildContext context, HomeController controller) {
    return [
      listBottomItem(context, controller)[0],
      listBottomItem(context, controller)[1],
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.admin_panel_settings_rounded,
        ),
        label: S.of(context).admin,
        tooltip: S.of(context).admin,
      ),
      listBottomItem(context, controller).last,
    ];
  }

  @override
  void initState() {
    super.initState();
    controller = HomeController(
      GetIt.I.get<ProfileApiService>(),
      context,
    );

    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (sizer.isWide(context)) {
      return const HomeWideView();
    }

    return ValueListenableBuilder<LoadingState<int>>(
      valueListenable: controller,
      builder: (_, value, __) {
        return ValueListenableBuilder(
          valueListenable: appController,
          builder: (context, value, child) {
            return CupertinoTabScaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              resizeToAvoidBottomInset: true,
              tabBar: CupertinoTabBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                items: appController.value.data.isAdmin
                    ? listBottomItemAdmin(context, controller)
                    : listBottomItem(context, controller),
              ),
              tabBuilder: (context, index) {
                if (appController.value.data.isAdmin) {
                  return listTabAdmin[index];
                } else {
                  return listTab[index];
                }
              },
            );
          },
        );
      },
    );
  }
}
