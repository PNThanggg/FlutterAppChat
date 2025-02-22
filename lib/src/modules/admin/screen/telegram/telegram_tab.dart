import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../admin.dart';
import 'tab/all_chat_tab.dart';
import 'tab/free_chat_tab.dart';

class TelegramTab extends StatefulWidget {
  const TelegramTab({super.key});

  @override
  State<TelegramTab> createState() => _TelegramTabState();
}

class _TelegramTabState extends State<TelegramTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: "Workplace".h6.size(20).semiBold.color(Colors.black),
        backgroundColor: headerColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ).copyWith(
              bottom: 12,
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return states.contains(WidgetState.focused) ? null : Colors.transparent;
                },
              ),
              labelStyle: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8,
                ),
                color: primaryColor,
              ),
              tabs: const [
                Tab(text: 'Free Chat'),
                Tab(text: 'All Chat'),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabController,
        children: const [
          FreeChatTab(),
          AllChatTab(),
        ],
      ),
    );
  }
}
