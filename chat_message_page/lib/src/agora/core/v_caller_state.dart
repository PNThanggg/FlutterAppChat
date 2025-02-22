import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

class VRtcState {
  Duration time;
  CallStatus status;
  VAgoraConnect? agoraConnect;

  VRtcState({
    this.time = Duration.zero,
    this.status = CallStatus.connecting,
  });

  @override
  String toString() {
    return '{time: $time, status: $status}';
  }
}
