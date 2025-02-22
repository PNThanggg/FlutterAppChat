import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallMessageItem extends StatelessWidget {
  final VCallMessage message;
  final String audioCallLabel;
  final String callStatusLabel;

  const CallMessageItem({
    super.key,
    required this.message,
    required this.audioCallLabel,
    required this.callStatusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(5),
      child: CupertinoListTile(
        onTap: () {
          if (message.data.callStatus == VMessageCallStatus.ring) {
            VChatController.I.vNavigator.callNavigator.toCall(
              context,
              VCallDto(
                isVideoEnable: message.data.withVideo,
                roomId: message.roomId,
                peerUser: SBaseUser(
                  id: message.roomId,
                  fullName: S.of(context).group,
                  userImage: "default_group_image.png",
                ),
                isCaller: message.isMeSender,
              ),
            );
          }
        },
        title: "${message.senderName}       ".text.size(16),
        subtitle: Row(
          children: [
            _getSub(context),
            if (message.data.callStatus == VMessageCallStatus.ring)
              const SizedBox(
                width: 5,
              ),
            "Click to join".cap
          ],
        ),
        leading: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Icon(
            message.data.withVideo ? PhosphorIconsLight.videoCamera : PhosphorIconsLight.phoneCall,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _getSub(BuildContext context) {
    if (message.data.duration != null) {
      return "${message.data.duration.toString()} S".text.maxLine(2).overflowEllipsis;
    }

    return callStatusLabel.toString().text.maxLine(2).overflowEllipsis;
  }
}
