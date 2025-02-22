import 'package:flutter/cupertino.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../chat_settings/widgets/chat_settings_list_section.dart';

class PeerProfileChatRow extends StatelessWidget {
  const PeerProfileChatRow({
    super.key,
    required this.openChatLoading,
    required this.blockLoading,
    required this.isThereBan,
    required this.isMeBanner,
    required this.createGroupWith,
    required this.openChatWith,
    required this.updateBlock,
  });

  final bool openChatLoading;
  final bool blockLoading;
  final bool isThereBan;
  final bool isMeBanner;
  final VoidCallback createGroupWith;
  final VoidCallback openChatWith;
  final VoidCallback updateBlock;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ChatSettingsListSection(
          icon: CupertinoIcons.chat_bubble_2,
          iconWidget: openChatLoading ? const CupertinoActivityIndicator() : null,
          title: S.of(context).chat,
          onPressed: isThereBan == true ? null : openChatWith,
        ),
        ChatSettingsListSection(
          icon: CupertinoIcons.add_circled,
          title: S.of(context).groupWith,
          onPressed: isThereBan == true ? null : createGroupWith,
        ),
        ChatSettingsListSection(
          icon: PhosphorIcons.bug,
          iconWidget: blockLoading ? const CupertinoActivityIndicator() : null,
          title: _getBlockTitle(context),
          onPressed: updateBlock,
        ),
      ],
    );
  }

  String _getBlockTitle(BuildContext context) {
    if (isMeBanner) {
      return S.of(context).unBlock;
    } else {
      return S.of(context).block;
    }
  }
}
