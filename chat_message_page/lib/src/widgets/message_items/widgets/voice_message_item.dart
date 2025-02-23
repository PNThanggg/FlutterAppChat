import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoiceMessageItem extends StatelessWidget {
  final VVoiceMessage message;
  final VoiceMessageController? Function(VBaseMessage message) voiceController;

  const VoiceMessageItem({
    super.key,
    required this.message,
    required this.voiceController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.transparent,
        child: VoiceMessageView(
          controller: voiceController(message)!,
          notActiveSliderColor: context
              .getMessageItemHolderColor(
                message.isMeSender,
                context,
              )
              .withOpacity(.3),
          activeSliderColor: context.isDark ? CupertinoColors.systemGreen : Colors.red,
        ),
      ),
    );
  }
}
