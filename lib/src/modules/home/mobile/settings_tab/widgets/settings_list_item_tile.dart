import 'dart:async';

import 'package:chat_core/chat_core.dart';
import 'package:flutter/cupertino.dart';

class SettingsListItemTile extends StatelessWidget {
  const SettingsListItemTile({
    super.key,
    required this.title,
    this.color,
    this.icon,
    this.additionalInfo,
    this.trailing,
    this.onTap,
    this.isLoading = false,
    this.textColor,
    this.subtitle,
    this.hide = false,
  });

  final Color? color;
  final Color? textColor;
  final bool hide;
  final String title;
  final bool isLoading;
  final IconData? icon;
  final Widget? subtitle;
  final Widget? additionalInfo;
  final Widget? trailing;
  final FutureOr<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (hide) {
      return const SizedBox();
    }

    return CupertinoListTile.notched(
      backgroundColor: context.theme.cardColor,
      onTap: onTap,
      subtitle: subtitle,
      leadingSize: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      leading: isLoading
          ? const CupertinoActivityIndicator()
          : color == null
              ? null
              : Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: CupertinoColors.white,
                  ),
                ),
      additionalInfo: additionalInfo,
      title: Text(
        title,
        maxLines: 3,
        style: context.theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: trailing ??
          Icon(context.isRtl ? CupertinoIcons.chevron_back : CupertinoIcons.chevron_forward),
    );
  }
}
