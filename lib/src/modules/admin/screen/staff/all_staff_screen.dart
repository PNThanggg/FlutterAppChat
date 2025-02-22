import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'all_staff_controller.dart';

class AllStaffScreen extends StatefulWidget {
  const AllStaffScreen({super.key});

  @override
  State<AllStaffScreen> createState() => _AllStaffScreeState();
}

class _AllStaffScreeState extends State<AllStaffScreen> {
  late AllStaffController controller;

  @override
  void initState() {
    super.initState();

    controller = GetIt.I.get<AllStaffController>();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          title: "List Staff".text.medium,
          centerTitle: true,
        ),
        body: ValueListenableBuilder<LoadingState<List<SearchUser>>>(
          valueListenable: controller,
          builder: (_, value, __) {
            return VAsyncWidgetsBuilder(
              loadingState: value.loadingState,
              onRefresh: controller.getData,
              successWidget: () {
                return RefreshIndicator(
                  onRefresh: controller.getData,
                  child: ListView.separated(
                    cacheExtent: 300,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.data[index];
                      return SUserItem(
                        onTap: () {
                          controller.onItemPress(item, context);
                        },
                        baseUser: item.baseUser,
                        hasBadge: item.hasBadge,
                        subtitle: item.getUserBio,
                        trailing: const Icon(CupertinoIcons.forward),
                      );
                    },
                    itemCount: controller.data.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.grey.withOpacity(.2),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
