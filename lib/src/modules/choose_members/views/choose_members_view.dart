import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loadmore/loadmore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../core/api_service/profile/profile_api_service.dart';
import '../controllers/choose_members_controller.dart';
import '../widgets/cupertino_checkbox_list_tile.dart';

class ChooseMembersView extends StatefulWidget {
  final VoidCallback onCloseSheet;
  final Function(List<BaseUser> selectedUsers) onDone;
  final String? groupId;
  final String? broadcastId;
  final int maxCount;

  const ChooseMembersView({
    super.key,
    required this.onCloseSheet,
    required this.onDone,
    this.groupId,
    this.broadcastId,
    required this.maxCount,
  });

  @override
  State<ChooseMembersView> createState() => _ChooseMembersViewState();
}

class _ChooseMembersViewState extends State<ChooseMembersView> {
  late final ChooseMembersController controller;

  @override
  void initState() {
    super.initState();
    controller = ChooseMembersController(
      GetIt.I.get<ProfileApiService>(),
      widget.onDone,
      widget.groupId,
      widget.broadcastId,
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
      backgroundColor: context.theme.cardColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: context.theme.highlightColor,
        leading: TextButton(
          onPressed: widget.onCloseSheet,
          child: Text(S.of(context).close),
        ),
        trailing: ValueListenableBuilder<LoadingState<List<SelectableUser>>>(
          valueListenable: controller,
          builder: (_, value, ___) {
            return TextButton(
              onPressed: controller.isThereSelection ? () => controller.onNext(context) : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).next,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "(${controller.selectedUsers.length}/${widget.maxCount})",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
        middle: Text(S.of(context).appMembers, style: TextStyle(color: context.theme.textTheme.bodyMedium?.color)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: CupertinoSearchTextField(
                  controller: controller.txtController,
                  onChanged: controller.onSearchChanged,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, child) => VConditionalBuilder(
                  condition: controller.isThereSelection,
                  thenBuilder: () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  VCircleAvatar(
                                    vFileSource: VPlatformFile.fromUrl(
                                      networkUrl: controller.selectedUsers[index].searchUser.baseUser.userImage,
                                    ),
                                    radius: 25,
                                  ),
                                  PositionedDirectional(
                                    end: 0,
                                    child: GestureDetector(
                                      onTap: () => controller.unSelectUser(controller.selectedUsers[index]),
                                      child: Container(
                                        decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                        child: const Icon(
                                          CupertinoIcons.clear_circled,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              controller.selectedUsers[index].searchUser.baseUser.fullName
                                  .split(" ")
                                  .first
                                  .h6
                                  .size(12)
                                  .color(Colors.grey)
                            ],
                          );
                        },
                        itemCount: controller.selectedUsers.length,
                      ),
                    ),
                  ),
                  elseBuilder: () => const SizedBox.shrink(),
                ),
              ),
              ValueListenableBuilder<LoadingState<List<SelectableUser>>>(
                valueListenable: controller,
                builder: (_, value, ___) => VAsyncWidgetsBuilder(
                  loadingState: value.loadingState,
                  onRefresh: controller.getData,
                  successWidget: () {
                    return Expanded(
                      child: LoadMore(
                        onLoadMore: controller.onLoadMore,
                        isFinish: controller.isFinishLoadMore,
                        textBuilder: (status) => "",
                        child: ListView.separated(
                          controller: ModalScrollController.of(context),
                          padding: const EdgeInsets.all(5),
                          separatorBuilder: (context, index) => Divider(
                            height: 10,
                            thickness: 1,
                            color: Colors.grey.withOpacity(.2),
                          ),
                          itemBuilder: (context, index) {
                            final item = value.data[index];
                            return CupertinoCheckboxListTile(
                              onItemPressed: () {
                                if (item.isSelected == false) {
                                  controller.selectUser(item);
                                } else {
                                  controller.unSelectUser(item);
                                }
                              },
                              onChanged: (value) {
                                if (value == true) {
                                  controller.selectUser(item);
                                } else {
                                  controller.unSelectUser(item);
                                }
                              },
                              value: item.isSelected,
                              title: Row(
                                children: [
                                  VCircleAvatar(
                                    vFileSource: VPlatformFile.fromUrl(
                                      networkUrl: item.searchUser.baseUser.userImage,
                                    ),
                                    radius: 20,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  item.searchUser.baseUser.fullName.h6.medium.size(16),
                                ],
                              ),
                            );
                          },
                          itemCount: value.data.length,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
