import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/waiting_list_controller.dart';

class WaitingListPage extends StatefulWidget {
  final MyProfile profile;

  const WaitingListPage({super.key, required this.profile});

  @override
  State<WaitingListPage> createState() => _WaitingListPageState();
}

class _WaitingListPageState extends State<WaitingListPage> {
  late final WaitingListController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).waitingList),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                VCircleAvatar(
                  vFileSource: VPlatformFile.fromUrl(
                    networkUrl: widget.profile.baseUser.userImage,
                  ),
                  radius: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${S.of(context).welcome} ${widget.profile.baseUser.fullName}",
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  S.of(context).yourAccountIsUnderReview,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    controller.refreshProfile(context);
                  },
                  child: Text(S.of(context).retry),
                ),
                TextButton(
                  onPressed: () {
                    controller.logout(context);
                  },
                  child: Text(
                    S.of(context).logOut,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = WaitingListController();
    controller.onInit();
    controller.refreshProfile(context);
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
