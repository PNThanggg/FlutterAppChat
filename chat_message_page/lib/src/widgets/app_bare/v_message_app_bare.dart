import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/core/core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../message_items/shared/message_typing_widget.dart';

class VMessageAppBare extends StatelessWidget {
  final Function(BuildContext context) onTitlePress;

  final Function(bool isVideo)? onCreateCall;
  final Function(bool isBlocked)? onUpdateBlock;
  final VRoom room;
  final VMessageLocalization language;
  final int? memberCount;
  final int? totalOnline;
  final DateTime? lastSeenAt;
  final String? Function(BuildContext context) inTypingText;
  final bool isCallAllowed;

  const VMessageAppBare({
    super.key,
    required this.onTitlePress,
    required this.room,
    required this.language,
    required this.inTypingText,
    this.onCreateCall,
    this.memberCount,
    required this.isCallAllowed,
    this.totalOnline,
    this.lastSeenAt,
    this.onUpdateBlock,
  });

  @override
  Widget build(BuildContext context) {
    int? count;

    return CupertinoNavigationBar(
      backgroundColor: context.theme.cardColor,
      border: const Border.fromBorderSide(BorderSide.none),
      middle: ChatListTile(
        title: room.realTitle,
        leading: VCircleAvatar(
          vFileSource: VPlatformFile.fromUrl(url: room.thumbImage),
          radius: 18,
        ),
        onTap: () => onTitlePress.call(context),
        subtitle: inTypingText(context) != null
            ? MessageTypingWidget(
                text: inTypingText(context)!,
              )
            : _getSubTitle(context)
                ?.text
                .color(CupertinoColors.systemGreen)
                .size(12)
                .maxLine(1)
                .overflowEllipsis,
      ),
      padding: const EdgeInsetsDirectional.all(0),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getCallIcon,
        ],
      ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 5,
          ),
          StreamBuilder<VTotalUnReadRoomsCount>(
              stream: VChatController.I.nativeApi.streams.totalUnreadRoomsCountStream,
              builder: (context, snapshot) {
                if (snapshot.data?.count != null) {
                  count = snapshot.data?.count;
                }
                final sizer = GetIt.I.get<AppSizeHelper>();
                if (sizer.isWide(context)) {
                  return const SizedBox();
                }
                return CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  onPressed: context.pop,
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.back,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      if (snapshot.data?.count == 0)
                        const Text("   ")
                      else
                        Text(
                          "${snapshot.data?.count ?? "${count ?? "   "}"}",
                          style: const TextStyle(color: Colors.blueAccent),
                        )
                    ],
                  ),
                );
              }),
          const SizedBox(
            width: 0,
          ),
        ],
      ),
    );
  }

  String? _getSubTitle(BuildContext context) {
    if (room.roomType.isSingleOrOrder) {
      if (room.isOnline) {
        return language.online;
      }
      if (lastSeenAt == null) {
        return null;
      } else {
        return format(
          lastSeenAt!.toLocal(),
          locale: Localizations.localeOf(context).languageCode,
        );
      }
    } else if (memberCount != null) {
      if (totalOnline != null) {
        return "${language.members} $memberCount";
      }
      return "${language.members} $memberCount";
    }
    return null;
  }

  Widget get _getCallIcon {
    if (isCallAllowed) {
      return Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              PhosphorIcons.videoCamera,
              size: 30,
              color: isCallAllowed ? null : Colors.grey,
            ),
            onPressed: () {
              if (!isCallAllowed) return;
              onCreateCall?.call(true);
            },
          ),
          const SizedBox(
            width: 5,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              CupertinoIcons.phone,
              size: 28,
              color: isCallAllowed ? null : Colors.grey,
            ),
            onPressed: () {
              if (!isCallAllowed) return;
              onCreateCall?.call(false);
            },
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
