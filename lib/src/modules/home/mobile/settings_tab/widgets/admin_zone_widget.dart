import 'package:chat_core/chat_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../admin/admin.dart';
import '../../../../app/controller/app_controller.dart';
import 'settings_list_item_tile.dart';

class AdminZoneWidget extends StatefulWidget {
  const AdminZoneWidget({super.key});

  @override
  State<AdminZoneWidget> createState() => _AdminZoneWidgetState();
}

class _AdminZoneWidgetState extends State<AdminZoneWidget> {
  late final AppController appController;

  @override
  void initState() {
    super.initState();

    appController = GetIt.I.get<AppController>();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appController,
      builder: (context, value, child) {
        if (!value.data.isAdmin) {
          return const SizedBox.shrink();
        }

        return CupertinoListSection(
          dividerMargin: 0,
          topMargin: 30,
          hasLeading: false,
          children: [
            SettingsListItemTile(
              color: Colors.blue,
              title: "Admin Dashboard",
              onTap: () => context.toPage(const DashboardPage()),
              icon: CupertinoIcons.question,
            ),
            SettingsListItemTile(
              color: Colors.blue,
              title: "Manager User",
              onTap: () => context.toPage(const UsersPage()),
              icon: CupertinoIcons.question,
            ),
            SettingsListItemTile(
              color: Colors.blue,
              title: "Workplace",
              onTap: () => context.toPage(const TelegramTab()),
              icon: CupertinoIcons.question,
            ),
            SettingsListItemTile(
              color: Colors.blue,
              title: "Notification",
              onTap: () => context.toPage(const NotificationsPage()),
              icon: CupertinoIcons.question,
            ),
            SettingsListItemTile(
              color: Colors.blue,
              title: "Admin Setting",
              onTap: () => context.toPage(const SettingsPage()),
              icon: CupertinoIcons.question,
            ),
          ],
        );
      },
    );
  }
}
