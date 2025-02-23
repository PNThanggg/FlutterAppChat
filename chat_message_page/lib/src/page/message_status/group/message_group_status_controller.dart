import 'dart:async';

import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_voice_player/chat_voice_player.dart';
import 'package:flutter/material.dart';

class MessageStatusState {
  final List<VMessageStatusModel> seen = [];
  final List<VMessageStatusModel> deliver = [];

  @override
  String toString() {
    return 'MessageStatusState{seen: $seen, deliver: $deliver}';
  }
}

class MessageGroupStatusController extends ValueNotifier<MessageStatusState> {
  final VBaseMessage message;
  Timer? _timer;

  MessageGroupStatusController(this.message) : super(MessageStatusState()) {
    getData();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) => getData(),
    );
  }

  ChatLoadingState state = ChatLoadingState.ideal;
  VoiceMessageController? voiceMessageController;

  void close() {
    voiceMessageController?.dispose();
    _timer?.cancel();
    dispose();
  }

  VoiceMessageController? getVoiceController(VBaseMessage message) {
    if (message is VVoiceMessage && voiceMessageController == null) {
      voiceMessageController = VoiceMessageController(
        id: message.localId,
        audioSrc: message.data.fileSource,
        maxDuration: message.data.durationObj,
      );
      return voiceMessageController;
    } else if (message is VVoiceMessage && voiceMessageController != null) {
      return voiceMessageController;
    }
    return null;
  }

  void getData() async {
    await vSafeApiCall<MessageStatusState>(
      onLoading: () {
        if (state != ChatLoadingState.success) {
          state = ChatLoadingState.loading;
          notifyListeners();
        }
      },
      request: () async {
        final newState = MessageStatusState();
        newState.seen.addAll(await VChatController.I.roomApi.getMessageStatusForGroup(
          roomId: message.roomId,
          messageId: message.id,
          isSeen: true,
        ));
        newState.deliver.addAll(await VChatController.I.roomApi.getMessageStatusForGroup(
          roomId: message.roomId,
          messageId: message.id,
          isSeen: false,
        ));

        return newState;
      },
      onSuccess: (response) {
        value = response;
        state = ChatLoadingState.success;
        notifyListeners();
      },
      onError: (exception, trace) {
        state = ChatLoadingState.error;
        notifyListeners();
      },
    );
  }
}
