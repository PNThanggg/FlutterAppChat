import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../choose_members/views/choose_members_view.dart';

class SheetForAddMembersToGroup extends StatelessWidget {
  final String groupId;

  const SheetForAddMembersToGroup({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    if (VPlatforms.isIOS) {
      return Navigator(
        onGenerateRoute: (___) => CupertinoPageRoute(
          builder: (__) => ChooseMembersView(
            maxCount: VChatController.I.vChatConfig.maxGroupMembers,
            groupId: groupId,
            onCloseSheet: () {
              Navigator.of(context).pop();
            },
            onDone: (selectedUsers) {
              Navigator.of(context).pop(selectedUsers);
            },
          ),
        ),
      );
    }
    return Navigator(
      onGenerateRoute: (___) => MaterialPageRoute(
        builder: (__) => ChooseMembersView(
          maxCount: VChatController.I.vChatConfig.maxGroupMembers,
          groupId: groupId,
          onCloseSheet: () {
            Navigator.of(context).pop();
          },
          onDone: (selectedUsers) {
            Navigator.of(context).pop(selectedUsers);
          },
        ),
      ),
    );
  }
}
