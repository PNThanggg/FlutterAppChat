import 'dart:async';

import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_model/model.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';

import 'single_app_bar_controller.dart';

class SingleController extends BaseMessageController with StreamMix {
  final SingleAppBarController singleAppBarController;
  final VMessageLocalization language;
  StreamSubscription? _subscription;

  SingleController({
    required super.vRoom,
    required super.messageProvider,
    required super.scrollController,
    required super.inputStateController,
    required super.itemController,
    required this.singleAppBarController,
    required super.vMessageConfig,
    required this.language,
  }) {
    _initStreams();
    _getFromCache();
    _checkBanRemote();
    _subscription = chatInfoSearchStream.stream.listen((event) {
      onOpenSearch();
    });
  }

  @override
  void close() {
    singleAppBarController.close();
    _subscription?.cancel();
    closeStreamMix();
    super.close();
  }

  @override
  void onOpenSearch() {
    singleAppBarController.onOpenSearch();
    super.onOpenSearch();
  }

  @override
  void onCloseSearch() {
    singleAppBarController.onCloseSearch();
    super.onCloseSearch();
  }

  @override
  void onTitlePress(BuildContext context) async {
    final x = await VChatController.I.vNavigator.messageNavigator.toSingleSettings!(
      context,
      VToChatSettingsModel(
        title: vRoom.realTitle,
        image: vRoom.thumbImage,
        roomId: roomId,
        room: vRoom,
      ),
      vRoom.peerId!,
    );
    if (x == "search") {
      onOpenSearch();
    }
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

  void _initStreams() {
    streamsMix.add(VEventBusSingleton.vEventBus
        .on<VSingleBlockEvent>()
        .where(
          (e) => e.roomId == vRoom.id,
        )
        .listen(_handleBlockEvent));
  }

  void _handleBlockEvent(VSingleBlockEvent event) async {
    await updateValue(event.banModel);
    if (event.banModel.isThereBan) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  Future<void> _getFromCache() async {
    final res = ChatPreferences.getMap("ban-${vRoom.id}");
    if (res == null) return;
    updateValue(VSingleBlockModel.fromMap(res));
  }

  Future<void> updateValue(VSingleBlockModel value) async {
    await ChatPreferences.setMap("ban-${vRoom.id}", value.toMap());
    if (value.isThereBan) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  Future<void> _checkBanRemote() async {
    if (vRoom.roomType.isSingleOrOrder) {
      await vSafeApiCall<VSingleBlockModel>(
        request: () {
          return VChatController.I.blockApi.checkIfThereBan(peerId: vRoom.peerId!);
        },
        onSuccess: (response) async {
          await updateValue(response);
        },
      );
    }
  }
}
