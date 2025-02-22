import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:flutter/material.dart';

class UserIconWidget extends StatelessWidget {
  final String url;
  final String userName;
  final Widget subTitle;
  final bool isVisible;

  const UserIconWidget({
    super.key,
    required this.url,
    required this.userName,
    required this.subTitle,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [
          VCircleAvatar(
            vFileSource: VPlatformFile.fromUrl(
              networkUrl: url,
            ),
            radius: 60,
          ),
          const SizedBox(
            height: 20,
          ),
          userName.h5.color(Colors.white),
          const SizedBox(
            height: 5,
          ),
          subTitle
        ],
      ),
    );
  }
}
