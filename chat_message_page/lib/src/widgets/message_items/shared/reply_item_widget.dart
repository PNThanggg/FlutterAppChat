import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_message_page/src/v_chat/platform_cache_image_widget.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../core/types.dart';

class ReplyItemWidget extends StatelessWidget {
  final VBaseMessage? rToMessage;
  final VMessageCallback? onHighlightMessage;
  final bool isMeSender;
  final String repliedToYourSelf;

  const ReplyItemWidget({
    super.key,
    required this.rToMessage,
    required this.onHighlightMessage,
    required this.isMeSender,
    required this.repliedToYourSelf,
  });

  @override
  Widget build(BuildContext context) {
    if (rToMessage == null) {
      return const SizedBox.shrink();
    }
    final method = context.vMessageTheme.vMessageItemTheme.replyMessageItemBuilder;
    if (method != null) {
      return method(context, isMeSender, rToMessage!);
    }

    return InkWell(
      onLongPress: null,
      onTap: onHighlightMessage == null ? null : () => onHighlightMessage!(rToMessage!),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300, minWidth: 150),
        decoration: BoxDecoration(
          color: isMeSender ? Colors.blueAccent.withOpacity(0.2) : context.vMessageTheme.receiverReplyColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 1,
                ),
                VerticalDivider(
                  color: isMeSender ? const Color.fromARGB(255, 255, 123, 7) : Colors.blueAccent,
                  thickness: 2,
                  width: 2,
                  indent: 4,
                  endIndent: 2,
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTitle(context).text.color(Colors.blueAccent).size(14),
                      const SizedBox(
                        height: 3,
                      ),
                      rToMessage!.realContentMentionParsedWithAt.text
                          .maxLine(5)
                          .size(12)
                          .overflowEllipsis
                          .color(isMeSender ? Colors.white : Colors.black),
                    ],
                  ),
                ),
                _getImage()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(BuildContext context) {
    if (rToMessage!.isMeSender && isMeSender) {
      return repliedToYourSelf;
    }
    return rToMessage!.senderName;
  }

  Widget _getImage() {
    if (rToMessage! is VImageMessage) {
      final msg = rToMessage! as VImageMessage;
      return VPlatformCacheImageWidget(
        source: msg.data.fileSource,
        borderRadius: BorderRadius.circular(9),
        size: const Size(40, 40),
      );
    }
    return const SizedBox.shrink();
  }
}
