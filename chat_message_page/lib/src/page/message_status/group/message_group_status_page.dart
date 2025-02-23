import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message_group_status_controller.dart';

class MessageGroupStatusPage extends StatefulWidget {
  final VBaseMessage message;
  final String messageInfoLabel;
  final String readLabel;
  final String deliveredLabel;
  final VMessageLocalization vMessageLocalization;

  const MessageGroupStatusPage({
    super.key,
    required this.message,
    required this.messageInfoLabel,
    required this.readLabel,
    required this.deliveredLabel,
    required this.vMessageLocalization,
  });

  @override
  State<MessageGroupStatusPage> createState() => _MessageGroupStatusPageState();
}

class _MessageGroupStatusPageState extends State<MessageGroupStatusPage> {
  late final MessageGroupStatusController controller;

  @override
  void initState() {
    controller = MessageGroupStatusController(widget.message);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.isDark ? null : CupertinoColors.systemGrey6,
      navigationBar: CupertinoNavigationBar(
        middle: widget.messageInfoLabel.text,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: VMessageItem(
                  language: widget.vMessageLocalization,
                  voiceController: controller.getVoiceController,
                  message: widget.message,
                  roomType: VRoomType.g,
                  onSwipe: null,
                  onReSend: (message) {},
                  onHighlightMessage: (message) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    MessageStatusIcon(
                      model: MessageStatusIconDataModel(
                        isDeliver: false,
                        isSeen: true,
                        emitStatus: widget.message.emitStatus,
                        isMeSender: widget.message.isMeSender,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    widget.readLabel.text,
                  ],
                ),
              ),
              ValueListenableBuilder<MessageStatusState>(
                  valueListenable: controller,
                  builder: (__, value, _) {
                    return VAsyncWidgetsBuilder(
                      loadingState: controller.state,
                      onRefresh: controller.getData,
                      successWidget: () {
                        final seen = value.seen;
                        if (seen.isEmpty) {
                          return const ChatSettingsTileInfo(
                            title: Center(
                              child: Text("---"),
                            ),
                          );
                        }
                        return Container(
                          color: context.isDark ? CupertinoColors.secondaryLabel : Colors.white,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) => CupertinoListTile(
                              padding: EdgeInsets.zero,
                              onTap: () {
                                VChatController.I.vNavigator.messageNavigator.toUserProfilePage!(
                                  context,
                                  seen[index].peerUser.id,
                                );
                              },
                              leadingSize: 40,
                              leading: VCircleAvatar(
                                radius: 20,
                                vFileSource: VPlatformFile.fromUrl(
                                  networkUrl: value.seen[index].peerUser.userImage,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.readLabel.text,
                                      format(value.seen[index].seen!).text.color(Colors.grey),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.deliveredLabel.text,
                                      format(value.seen[index].delivered).text.color(Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                              title: value.seen[index].peerUser.fullName.text,
                            ),
                            separatorBuilder: (context, index) => const Divider(),
                            itemCount: value.seen.length,
                          ),
                        );
                      },
                    );
                  }),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    MessageStatusIcon(
                      model: MessageStatusIconDataModel(
                        isDeliver: true,
                        isSeen: false,
                        emitStatus: widget.message.emitStatus,
                        isMeSender: widget.message.isMeSender,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    widget.deliveredLabel.text,
                  ],
                ),
              ),
              ValueListenableBuilder<MessageStatusState>(
                  valueListenable: controller,
                  builder: (__, value, _) {
                    return VAsyncWidgetsBuilder(
                      loadingState: controller.state,
                      successWidget: () {
                        final deliver = value.deliver;
                        if (deliver.isEmpty) {
                          return const ChatSettingsTileInfo(
                            title: Center(
                              child: Text("---"),
                            ),
                          );
                        }

                        return Container(
                          color: context.isDark ? CupertinoColors.secondaryLabel : Colors.white,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) => CupertinoListTile(
                              padding: EdgeInsets.zero,
                              onTap: () {
                                VChatController.I.vNavigator.messageNavigator.toUserProfilePage!(
                                  context,
                                  deliver[index].peerUser.id,
                                );
                              },
                              leadingSize: 40,
                              subtitle: format(value.deliver[index].delivered).text.color(Colors.grey),
                              leading: VCircleAvatar(
                                radius: 20,
                                vFileSource: VPlatformFile.fromUrl(
                                  networkUrl: value.deliver[index].peerUser.userImage,
                                ),
                              ),
                              title: value.deliver[index].peerUser.fullName.text,
                            ),
                            separatorBuilder: (context, index) => const Divider(),
                            itemCount: value.deliver.length,
                          ),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
