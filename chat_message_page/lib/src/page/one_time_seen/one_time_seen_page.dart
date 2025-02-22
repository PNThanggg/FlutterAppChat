import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

class OneTimeSeenPage extends StatefulWidget {
  final VBaseMessage message;
  final VMessageLocalization language;

  const OneTimeSeenPage({
    super.key,
    required this.message,
    required this.language,
  });

  @override
  State<OneTimeSeenPage> createState() => _OneTimeSeenPageState();
}

class _OneTimeSeenPageState extends State<OneTimeSeenPage> {
  final VVoicePlayerController voiceControllers = VVoicePlayerController(
    (localId) {
      return null;
    },
  );

  @override
  void initState() {
    _seenMessage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    voiceControllers.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.vMessageTheme.scaffoldDecoration,
      child: CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: CupertinoNavigationBar(
          middle: S.of(context).oneSeenMessage.text,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: VMessageItem(
                forceSeen: true,
                message: widget.message,
                roomType: VRoomType.s,
                language: widget.language,
                voiceController: (message) {
                  if (message is VVoiceMessage) {
                    return voiceControllers.getVoiceController(message);
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _seenMessage() async {
    vSafeApiCall(
      request: () async {
        await VChatController.I.nativeApi.local.message.addOneSeen(
          roomId: widget.message.roomId,
          localId: widget.message.localId,
        );
        await VChatController.I.nativeApi.remote.message.addOneSeen(
          roomId: widget.message.roomId,
          messageId: widget.message.id,
        );
      },
      onSuccess: (response) {},
    );
  }
}
