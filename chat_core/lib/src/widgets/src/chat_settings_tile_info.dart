import 'package:chat_core/chat_core.dart';
import 'package:flutter/cupertino.dart';

class ChatSettingsTileInfo extends StatelessWidget {
  const ChatSettingsTileInfo({
    super.key,
    required this.title,
    this.trailing,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.onPressed,
  });

  final Widget title;
  final EdgeInsets? padding;
  final EdgeInsets margin;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      hasLeading: false,
      dividerMargin: 0,
      topMargin: 0,
      additionalDividerMargin: 0,
      margin: margin,
      children: [
        CupertinoListTile(
          backgroundColor: context.theme.cardColor,
          onTap: onPressed,
          padding: padding,
          leadingSize: 0,
          title: title,
          trailing: trailing,
        ),
      ],
    );
  }
}
