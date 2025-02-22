import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class CallItem extends StatelessWidget {
  final VCallHistory callHistory;
  final VoidCallback onPress;
  final VoidCallback onLongPress;

  const CallItem({
    super.key,
    required this.callHistory,
    required this.onPress,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      onLongPress: onLongPress,
      child: CupertinoListTile(
        leadingSize: 40,
        leading: VCircleAvatar(
          vFileSource: VPlatformFile.fromUrl(url: callHistory.peerUser.userImage),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          child: callHistory.withVideo
              ? const Icon(
                  PhosphorIcons.videoCameraFill,
                )
              : const Icon(
                  CupertinoIcons.phone_fill,
                ),
        ),
        padding: EdgeInsets.zero,
        additionalInfo: Text(
          format(
            callHistory.startAtDate,
            locale: Localizations.localeOf(context).languageCode,
          ),
          style: const TextStyle(fontSize: 12),
        ),
        title: callHistory.peerUser.fullName.text,
        subtitle: transCallStatus(callHistory, context).text,
      ),
    );
  }

  String transCallStatus(VCallHistory call, BuildContext context) {
    switch (call.callStatus) {
      case VMessageCallStatus.ring:
        return S.of(context).ring;
      case VMessageCallStatus.canceled:
        return S.of(context).canceled;
      case VMessageCallStatus.timeout:
        return S.of(context).timeout;
      case VMessageCallStatus.rejected:
        return S.of(context).rejected;
      case VMessageCallStatus.finished:
        return "${call.duration}  ${S.of(context).minutes}" ?? "";
      case VMessageCallStatus.sessionEnd:
        return S.of(context).finished;
      case VMessageCallStatus.inCall:
        return S.of(context).inCall;
    }
  }
}
