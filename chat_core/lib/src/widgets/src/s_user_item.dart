import 'package:flutter/cupertino.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class SUserItem extends StatelessWidget {
  final SBaseUser baseUser;
  final String? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final bool hasBadge;

  const SUserItem({
    super.key,
    required this.baseUser,
    this.onLongPress,
    this.hasBadge = false,
    this.trailing,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      onTap: onTap,
      // onLongPress: onLongPress,
      title: baseUser.fullName.h6.color(context.theme.textTheme.bodyMedium!.color!).size(16),
      subtitle: subtitle?.h6.color(context.theme.textTheme.bodyMedium!.color!).size(12),
      padding: EdgeInsets.zero,
      leadingSize: 50,
      leading: _getLeading(),
      additionalInfo: trailing ??
          Icon(
            context.isRtl ? CupertinoIcons.chevron_back : CupertinoIcons.chevron_forward,
          ),
    );
  }

  Widget _getLeading() {
    if (!hasBadge) {
      return VCircleAvatar(
        vFileSource: VPlatformFile.fromUrl(url: baseUser.userImage),
        radius: 50,
      );
    }

    return VCircleVerifiedAvatar(
      vFileSource: VPlatformFile.fromUrl(url: baseUser.userImage),
      radius: 50,
    );
  }
}
