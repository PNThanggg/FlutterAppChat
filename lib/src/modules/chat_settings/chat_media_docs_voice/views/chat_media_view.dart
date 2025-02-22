import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/chat_media_controller.dart';

class ChatMediaView extends StatefulWidget {
  const ChatMediaView({super.key, required this.roomId});

  final String roomId;

  @override
  State<ChatMediaView> createState() => _ChatMediaViewState();
}

class _ChatMediaViewState extends State<ChatMediaView> {
  late final ChatMediaController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatMediaController(widget.roomId);
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  int sharedValue = 0;

  Map<int, Widget> logoWidgets(BuildContext context) => <int, Widget>{
        0: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: S.current.media.h6.semiBold
              .size(12)
              .color(Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
        1: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: S.current.docs.h6.semiBold
              .size(12)
              .color(Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
        2: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: S.current.links.h6.semiBold
              .size(12)
              .color(Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
      };

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: context.theme.cardColor,
        middle: CupertinoSegmentedControl<int>(
          unselectedColor: Theme.of(context).brightness == Brightness.dark
              ? context.theme.scaffoldBackgroundColor
              : Colors.grey.shade200,
          selectedColor: Theme.of(context).brightness == Brightness.dark ? Colors.blue.shade900 : Colors.blueAccent,
          borderColor: Theme.of(context).brightness == Brightness.dark ? Colors.transparent : Colors.transparent,
          children: logoWidgets(context),
          onValueChanged: (int val) {
            setState(() {
              sharedValue = val;
            });
          },
          groupValue: sharedValue,
        ),
        leading: CupertinoNavigationBarBackButton(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.blueAccent,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) => VAsyncWidgetsBuilder(
            loadingState: controller.loadingState,
            successWidget: () {
              if (sharedValue == 0) {
                //create grid view builder
                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: controller.data.media.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    if (controller.data.media[index].messageType.isImage) {
                      return ImageMessageItem(
                        message: controller.data.media[index] as VImageMessage,
                        fit: BoxFit.cover,
                      );
                    }
                    return VideoMessageItem(
                      message: controller.data.media[index] as VVideoMessage,
                    );
                  },
                );
              } else if (sharedValue == 1) {
                return ListView.separated(
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    return FileMessageItem(
                      message: controller.data.files[index] as VFileMessage,
                      backgroundColor: controller.data.files[index].isMeSender
                          ? context.vMessageTheme.senderBubbleColor
                          : context.vMessageTheme.receiverBubbleColor,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200),
                  itemCount: controller.data.files.length,
                );
              } else {
                return ListView.separated(
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    return LinkViewerWidget(
                      data: controller.data.links[index].linkAtt,
                      isMeSender: controller.data.links[index].isMeSender,
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(color: Colors.grey),
                  itemCount: controller.data.links.length,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
