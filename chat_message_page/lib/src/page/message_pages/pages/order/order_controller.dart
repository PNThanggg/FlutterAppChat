import 'dart:async';

import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_model/model.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';

import 'order_app_bar_controller.dart';

class OrderController extends VBaseMessageController {
  final OrderAppBarController orderAppBarController;
  final VMessageLocalization language;

  OrderController({
    required super.vRoom,
    required super.vMessageConfig,
    required super.messageProvider,
    required super.scrollController,
    required super.inputStateController,
    required super.itemController,
    required this.orderAppBarController,
    required this.language,
  });

  @override
  void close() {
    orderAppBarController.close();
    super.close();
  }

  @override
  void onOpenSearch() {
    orderAppBarController.onOpenSearch();
    super.onOpenSearch();
  }

  @override
  void onCloseSearch() {
    orderAppBarController.onCloseSearch();
    super.onCloseSearch();
  }

  @override
  void onTitlePress(BuildContext context) {
    final toSingleSettings = VChatController.I.vNavigator.messageNavigator.toSingleSettings;
    if (toSingleSettings == null) return;
    toSingleSettings(
      context,
      VToChatSettingsModel(
        title: vRoom.realTitle,
        image: vRoom.thumbImage,
        roomId: roomId,
        room: vRoom,
      ),
      vRoom.peerId!,
    );
  }

  void onCreateCall(bool isVideo) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: language.makeCall,
      content: isVideo ? language.areYouWantToMakeVideoCall : language.areYouWantToMakeVoiceCall,
    );
    if (res != 1) return;
    VChatController.I.vNavigator.callNavigator.toCall(
      context,
      VCallDto(
        isVideoEnable: isVideo,
        roomId: vRoom.id,
        isCaller: true,
        peerUser: BaseUser(
          userImage: vRoom.thumbImage,
          fullName: vRoom.realTitle,
          id: vRoom.peerId!,
        ),
      ),
    );
  }

  Future onUpdateBlock(bool isBlocked) async {
    vSafeApiCall(
      request: () async {
        if (isBlocked) {
          return VChatController.I.blockApi.blockUser(peerId: vRoom.peerId!);
        } else {
          return VChatController.I.blockApi.unBlockUser(peerId: vRoom.peerId!);
        }
      },
      onSuccess: (response) {},
    );
  }

  @override
  Future<List<MentionModel>> onMentionRequireSearch(BuildContext context, String query) {
    return Future(() => []);
  }
}
