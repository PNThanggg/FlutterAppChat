import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VoiceMessageItem extends StatelessWidget {
  final VVoiceMessage message;
  final VVoiceMessageController? Function(VBaseMessage message) voiceController;

  const VoiceMessageItem({
    super.key,
    required this.message,
    required this.voiceController,
  });

  @override
  Widget build(BuildContext context) {
    //   print(message.data.fileSource.url);
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.transparent,
        child: VVoiceMessageView(
          controller: voiceController(message)!,
          notActiveSliderColor: context
              .getMessageItemHolderColor(
                message.isMeSender,
                context,
              )
              .withOpacity(.3),
          activeSliderColor:
              context.isDark ? CupertinoColors.systemGreen : Colors.red,
        ),
      ),
    );
  }
}
