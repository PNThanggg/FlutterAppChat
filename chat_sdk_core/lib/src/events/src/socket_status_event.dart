import 'package:chat_sdk_core/chat_sdk_core.dart';

class VSocketStatusEvent extends VAppEvent {
  final bool isConnected;
  final int connectTimes;

  const VSocketStatusEvent({
    required this.isConnected,
    required this.connectTimes,
  });

  @override
  List<Object?> get props => [isConnected, connectTimes];
}
