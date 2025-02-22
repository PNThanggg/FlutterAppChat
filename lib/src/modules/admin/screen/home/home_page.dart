import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../color_schemes.g.dart';
import '../dashboard/dashboard_page.dart';
import '../notifications/notifications_page.dart';
import '../settings/settings_page.dart';
import '../telegram/telegram_tab.dart';
import '../users/users_page.dart';

GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();

  var listTab = [
    const DashboardPage(),
    const UsersTabNavigation(),
    const TelegramTab(),
    const NotificationsPage(),
    const SettingsPage(),
  ];

  int _currentIndex = 0;

  void _onPressTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  BottomNavigationBarItem _itemBottomNavigationBar({
    required IconData icon,
    required String content,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Icon(
          icon,
          size: 25,
          color: const Color(0xFF61729B),
        ),
      ),
      label: content,
      activeIcon: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Icon(
          icon,
          size: 25,
          color: primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _key,
        // body: listTab[_currentIndex],
        body: IndexedStack(
          index: _currentIndex,
          children: listTab,
        ),
        bottomNavigationBar: BottomNavigationBar(
          key: navBarGlobalKey,
          selectedItemColor: primaryColor,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11.0,
          unselectedFontSize: 11,
          unselectedItemColor: const Color(0xFF61729B),
          currentIndex: _currentIndex,
          onTap: _onPressTab,
          items: [
            _itemBottomNavigationBar(
              icon: LineAwesomeIcons.dashcube,
              content: S.current.dashboard,
            ),
            _itemBottomNavigationBar(
              icon: LineAwesomeIcons.user,
              content: S.current.users,
            ),
            _itemBottomNavigationBar(
              icon: LineAwesomeIcons.telegram,
              content: 'Telegram',
            ),
            _itemBottomNavigationBar(
              icon: LineAwesomeIcons.bell,
              content: S.current.notification,
            ),
            _itemBottomNavigationBar(
              icon: LineAwesomeIcons.discord,
              content: S.current.settings,
            ),
          ],
        ),
      ),
    );
  }
}
