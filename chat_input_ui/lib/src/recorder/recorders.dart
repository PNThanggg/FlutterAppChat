import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:record/record.dart';

abstract class AppRecorder {
  Future<void> start([String? path]);

  Future<String?> stop();

  Future pause();

  Future<bool> isRecording();

  Future<void> close();
}

class MobileRecorder extends AppRecorder {
  final recorder = RecorderController();

  @override
  Future<void> start([String? path]) async {
    await recorder.record(path: path);
  }

  @override
  Future<String?> stop() async {
    final path = await recorder.stop();
    if (path != null) {
      return Uri.parse(path).path;
    }
    return null;
  }

  @override
  Future pause() async {
    await recorder.pause();
  }

  @override
  Future close() async {
    recorder.dispose();
  }

  @override
  Future<bool> isRecording() async {
    return recorder.isRecording;
  }
}

class PlatformRecorder extends AppRecorder {
  final AudioRecorder record = AudioRecorder();

  @override
  Future close() async {
    await record.dispose();
  }

  @override
  Future pause() async {
    await record.pause();
  }

  @override
  Future<void> start([String? path]) async {
    var encoder = const RecordConfig(encoder: AudioEncoder.aacLc);
    if (VPlatforms.isWeb) {
      encoder = const RecordConfig(encoder: AudioEncoder.opus);
    }
    await record.start(
      encoder,
      path: path ?? "",
    );
  }

  @override
  Future<bool> isRecording() async {
    return record.isRecording();
  }

  @override
  Future<String?> stop() async {
    return record.stop();
  }
}
