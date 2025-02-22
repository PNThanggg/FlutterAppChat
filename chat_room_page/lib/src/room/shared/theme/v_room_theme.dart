import 'package:chat_room_page/chat_room_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef VChatImageBuilderWidget = Widget Function({
  required String imageUrl,
  required String chatTitle,
  required bool isOnline,
  required int size,
});

class VRoomTheme extends ThemeExtension<VRoomTheme> {
  final BoxDecoration scaffoldDecoration;
  final Widget Function(String title) getChatTitle;
  final Color selectedRoomColor;
  final VChatImageBuilderWidget getChatAvatar;
  final VMsgStatusTheme lastMessageStatus;
  final Widget muteIcon;
  final TextStyle seenLastMessageTextStyle;
  final TextStyle unSeenLastMessageTextStyle;

  VRoomTheme._({
    required this.scaffoldDecoration,
    required this.getChatTitle,
    required this.lastMessageStatus,
    required this.muteIcon,
    required this.unSeenLastMessageTextStyle,
    required this.seenLastMessageTextStyle,
    required this.getChatAvatar,
    required this.selectedRoomColor,
  });

  factory VRoomTheme.light() {
    return VRoomTheme._(
      scaffoldDecoration: const BoxDecoration(color: Colors.white),
      getChatTitle: (title) {
        return Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          overflow: TextOverflow.ellipsis,
        );
      },
      getChatAvatar: ({
        required chatTitle,
        required imageUrl,
        required isOnline,
        required size,
      }) {
        return VChatAvatarImage(
          imageUrl: imageUrl,
          isOnline: isOnline,
          size: size,
          chatTitle: chatTitle,
        );
      },
      muteIcon: const Icon(Icons.notifications_off, size: 18),
      selectedRoomColor: Colors.blue.withOpacity(.2),
      unSeenLastMessageTextStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        color: Colors.blueAccent,
      ),
      seenLastMessageTextStyle: const TextStyle(overflow: TextOverflow.ellipsis, color: Colors.grey),
      lastMessageStatus: const VMsgStatusTheme.light(),
    );
  }

  factory VRoomTheme.dark() {
    return VRoomTheme._(
      scaffoldDecoration: const BoxDecoration(),
      muteIcon: const Icon(
        CupertinoIcons.bell_slash,
        size: 20,
      ),
      selectedRoomColor: Colors.white.withOpacity(.2),
      getChatTitle: (title) {
        return Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          overflow: TextOverflow.ellipsis,
        );
      },
      getChatAvatar: ({
        required chatTitle,
        required imageUrl,
        required isOnline,
        required size,
      }) {
        return VChatAvatarImage(
          imageUrl: imageUrl,
          isOnline: isOnline,
          size: size,
          chatTitle: chatTitle,
        );
      },
      unSeenLastMessageTextStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        color: Colors.blueAccent,
      ),
      seenLastMessageTextStyle: const TextStyle(overflow: TextOverflow.ellipsis, color: Colors.grey),
      lastMessageStatus: const VMsgStatusTheme.dark(),
    );
  }

  @override
  ThemeExtension<VRoomTheme> lerp(ThemeExtension<VRoomTheme>? other, double t) {
    if (other is! VRoomTheme) {
      return this;
    }
    return this;
  }

  @override
  VRoomTheme copyWith({
    BoxDecoration? scaffoldDecoration,
    Widget Function(String title)? getChatTitle,
    Color? selectedRoomColor,
    VChatImageBuilderWidget? getChatAvatar,
    VMsgStatusTheme? lastMessageStatus,
    Widget? muteIcon,
    TextStyle? seenLastMessageTextStyle,
    TextStyle? unSeenLastMessageTextStyle,
  }) {
    return VRoomTheme._(
      scaffoldDecoration: scaffoldDecoration ?? this.scaffoldDecoration,
      getChatTitle: getChatTitle ?? this.getChatTitle,
      selectedRoomColor: selectedRoomColor ?? this.selectedRoomColor,
      getChatAvatar: getChatAvatar ?? this.getChatAvatar,
      lastMessageStatus: lastMessageStatus ?? this.lastMessageStatus,
      muteIcon: muteIcon ?? this.muteIcon,
      seenLastMessageTextStyle: seenLastMessageTextStyle ?? this.seenLastMessageTextStyle,
      unSeenLastMessageTextStyle: unSeenLastMessageTextStyle ?? this.unSeenLastMessageTextStyle,
    );
  }
}

extension VRoomThemeExt on BuildContext {
  VRoomTheme get vRoomTheme {
    return Theme.of(this).extension<VRoomTheme>() ?? VRoomTheme.light();
  }
}
