import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_voice_player/chat_voice_player.dart';

class MessageSingleStatusController {
  VVoiceMessageController? voiceMessageController;

  void close() {
    voiceMessageController?.dispose();
  }

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
}
