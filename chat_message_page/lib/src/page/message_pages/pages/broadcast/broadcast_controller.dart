import 'dart:async';

import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';

import 'broadcast_app_bar_controller.dart';

class BroadcastController extends VBaseMessageController {
  final BroadcastAppBarController broadcastAppBarController;

  BroadcastController({
    required super.vRoom,
    required super.messageProvider,
    required super.scrollController,
    required super.inputStateController,
    required super.itemController,
    required super.vMessageConfig,
    required this.broadcastAppBarController,
  });

  @override
  void close() {
    super.close();
    broadcastAppBarController.close();
  }

  @override
  void onOpenSearch() {
    broadcastAppBarController.onOpenSearch();
    super.onOpenSearch();
  }

  @override
  void onCloseSearch() {
    broadcastAppBarController.onCloseSearch();
    super.onCloseSearch();
  }

  @override
  void onTitlePress(BuildContext context) {
    final toBroadcastSettings = VChatController.I.vNavigator.messageNavigator.toBroadcastSettings;
    if (toBroadcastSettings == null) return;
    toBroadcastSettings(
      context,
      VToChatSettingsModel(
        title: vRoom.realTitle,
        image: vRoom.thumbImage,
        roomId: roomId,
        room: vRoom,
      ),
    );
  }

  @override
  Future<List<MentionModel>> onMentionRequireSearch(BuildContext context, String query) async {
    return <MentionModel>[];
  }
}
