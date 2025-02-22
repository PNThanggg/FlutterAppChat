import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../controllers/group_members_controller.dart';

class GroupMembersView extends StatefulWidget {
  const GroupMembersView({
    super.key,
    required this.roomId,
    required this.myGroupInfo,
    required this.settingsModel,
  });

  final String roomId;
  final VMyGroupInfo myGroupInfo;
  final VToChatSettingsModel settingsModel;

  @override
  State<GroupMembersView> createState() => _GroupMembersViewState();
}

class _GroupMembersViewState extends State<GroupMembersView> {
  late final GroupMembersController controller;

  @override
  void initState() {
    super.initState();
    controller = GroupMembersController(
      widget.roomId,
      widget.myGroupInfo,
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
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: context.theme.cardColor,
        middle: Text(S.of(context).groupMembers, style: context.theme.textTheme.bodyLarge),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ValueListenableBuilder<SLoadingState<List<VGroupMember>>>(
            valueListenable: controller,
            builder: (_, value, __) {
              return VAsyncWidgetsBuilder(
                loadingState: value.loadingState,
                onRefresh: controller.getData,
                successWidget: () {
                  return LoadMore(
                    onLoadMore: controller.onLoadMore,
                    isFinish: controller.isFinishLoadMore,
                    textBuilder: (status) => "",
                    child: value.data.isEmpty
                        ? "No Member".h3.medium.size(14)
                        : ListView.separated(
                            padding: const EdgeInsets.all(10),
                            separatorBuilder: (context, index) => Divider(
                              height: 10,
                              thickness: 1,
                              color: Colors.grey.withOpacity(.2),
                            ),
                            itemBuilder: (context, index) => SUserItem(
                              baseUser: value.data[index].userData,
                              subtitle: format(
                                value.data[index].createdAtLocal,
                                locale: Localizations.localeOf(context).languageCode,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _getTr(value.data[index].role)
                                      .h6
                                      .color(Colors.red)
                                      .semiBold
                                      .size(15),
                                  Icon(
                                    context.isRtl
                                        ? CupertinoIcons.chevron_back
                                        : CupertinoIcons.chevron_forward,
                                  ),
                                ],
                              ),
                              onTap: () => controller.onUserTab(
                                context,
                                value.data[index],
                              ),
                              onLongPress: () => controller.onUserTab(
                                context,
                                value.data[index],
                              ),
                            ),
                            itemCount: value.data.length,
                          ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _getTr(VGroupMemberRole role) {
    switch (role) {
      case VGroupMemberRole.admin:
        return S.of(context).admin;
      case VGroupMemberRole.member:
        return S.of(context).member;
      case VGroupMemberRole.superAdmin:
        return S.of(context).creator;
    }
  }
}
