import 'dart:async';

import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_voice_player/chat_voice_player.dart';
import 'package:flutter/material.dart';

import '../group/message_group_status_controller.dart';

class MessageBroadcastStatusController extends ValueNotifier<MessageStatusState> {
  Timer? _timer;

  MessageBroadcastStatusController(this.message)
      : super(
          MessageStatusState(),
        ) {
    getData();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) => getData(),
    );
  }

  final VBaseMessage message;

  ChatLoadingState state = ChatLoadingState.ideal;
  VVoiceMessageController? voiceMessageController;

  VVoiceMessageController? getVoiceController(VBaseMessage message) {
    if (message is VVoiceMessage && voiceMessageController == null) {
      voiceMessageController = VVoiceMessageController(
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
        final x = MessageStatusState();
        x.seen.addAll(await VChatController.I.roomApi.getMessageStatusForBroadcast(
          roomId: message.roomId,
          messageId: message.id,
          isSeen: true,
        ));
        x.deliver.addAll(await VChatController.I.roomApi.getMessageStatusForBroadcast(
          roomId: message.roomId,
          messageId: message.id,
          isSeen: false,
        ));
        return x;
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

  void close() {
    voiceMessageController?.dispose();
    _timer?.cancel();
    dispose();
  }
}
