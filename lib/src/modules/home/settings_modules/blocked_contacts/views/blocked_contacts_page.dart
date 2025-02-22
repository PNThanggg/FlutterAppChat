import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

import '../../../../peer_profile/views/peer_profile_view.dart';
import '../controllers/blocked_contacts_controller.dart';

class BlockedContactsPage extends StatefulWidget {
  const BlockedContactsPage({super.key});

  @override
  State<BlockedContactsPage> createState() => _BlockedContactsPageState();
}

class _BlockedContactsPageState extends State<BlockedContactsPage> {
  late final BlockedContactsController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        middle: S.of(context).blockedUsers.h6.medium.size(20),
        border: Border.all(color: Colors.transparent),
      ),
      child: SafeArea(
        bottom: false,
        child: ValueListenableBuilder<LoadingState<List<BaseUser>>>(
          valueListenable: controller,
          builder: (_, value, ___) => VAsyncWidgetsBuilder(
            loadingState: value.loadingState,
            onRefresh: controller.getData,
            successWidget: () {
              return LoadMore(
                onLoadMore: controller.onLoadMore,
                isFinish: controller.isFinishLoadMore,
                textBuilder: (status) => "",
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return CupertinoListTile.notched(
                      padding: EdgeInsets.zero,
                      trailing: const Icon(CupertinoIcons.chevron_forward),
                      title: Text(value.data[index].fullName),
                      leadingSize: 40,
                      onTap: () {
                        context.toPage(
                          PeerProfileView(
                            peerId: value.data[index].id,
                          ),
                        );
                      },
                      leading: GestureDetector(
                        child: VCircleAvatar(
                          vFileSource: VPlatformFile.fromUrl(networkUrl: value.data[index].userImage),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: .7,
                      color: Colors.grey.withOpacity(.5),
                      height: 15,
                    );
                  },
                  itemCount: value.data.length,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = BlockedContactsController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
