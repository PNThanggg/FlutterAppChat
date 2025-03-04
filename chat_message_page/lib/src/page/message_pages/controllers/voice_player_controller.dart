import 'package:collection/collection.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_voice_player/chat_voice_player.dart';

class VoicePlayerController {
  final _voiceControllers = <VoiceMessageController>[];
  final String? Function(String localId) onVoiceNeedToPlayNext;

  VoicePlayerController(this.onVoiceNeedToPlayNext);

  VoiceMessageController? getById(String id) =>
      _voiceControllers.firstWhereOrNull((e) => e.id == id);

  VoiceMessageController getVoiceController(VVoiceMessage voiceMessage) {
    final oldController = getById(voiceMessage.localId);

    if (oldController != null) return oldController;

    final controller = VoiceMessageController(
      id: voiceMessage.localId,
      audioSrc: voiceMessage.data.fileSource,
      onComplete: (String localId) {
        final nextId = onVoiceNeedToPlayNext(localId);
        if (nextId != null) {
          getById(nextId)?.initAndPlay();
        }
      },
      maxDuration: voiceMessage.data.durationObj,
      onPlaying: _onPlaying,
    );
    _voiceControllers.add(controller);
    return controller;
  }

  void _onPlaying(String id) {
    for (final controller in _voiceControllers) {
      if (controller.id != id) {
        controller.pausePlaying();
      }
    }
  }

  void pauseAll() {
    for (final c in _voiceControllers) {
      c.pausePlaying();
    }
  }

  void close() {
    for (final c in _voiceControllers) {
      c.dispose();
    }
  }
}
