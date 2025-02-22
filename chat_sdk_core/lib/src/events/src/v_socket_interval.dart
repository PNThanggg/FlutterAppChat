import 'package:chat_sdk_core/chat_sdk_core.dart';

class VSocketIntervalEvent extends VAppEvent {
  @override
  List<Object?> get props => [
        DateTime.now().microsecondsSinceEpoch,
      ];
}
