import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';

class VChatAvatarImage extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;
  final String chatTitle;
  final int size;

  const VChatAvatarImage({
    super.key,
    required this.imageUrl,
    required this.isOnline,
    required this.chatTitle,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedAvatar(
      size: size.toDouble(),
      statusColor: isOnline ? CupertinoColors.systemGreen : null,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      foregroundDecoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      name: chatTitle,
      child: VCircleAvatar(
        vFileSource: VPlatformFile.fromUrl(networkUrl: imageUrl),
      ),
    );
  }
}
