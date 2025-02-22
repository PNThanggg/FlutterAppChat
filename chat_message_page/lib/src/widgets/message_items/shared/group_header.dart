import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  final bool isGroup;
  final String senderName;
  final String senderImage;
  final VoidCallback onTab;

  const GroupHeader({
    super.key,
    required this.isGroup,
    required this.senderName,
    required this.senderImage,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    if (!isGroup) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: onTab,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VCircleAvatar(
              vFileSource: VPlatformFile.fromUrl(
                networkUrl: senderImage,
              ),
              radius: 10,
            ),
            const SizedBox(
              width: 5,
            ),
            senderName.h6.size(12).color(Colors.blue).black,
          ],
        ),
      ),
    );
  }
}
