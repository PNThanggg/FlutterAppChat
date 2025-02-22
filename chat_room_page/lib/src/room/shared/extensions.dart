import 'package:chat_sdk_core/chat_sdk_core.dart';

extension VSortRoomByMsgId on List<VRoom> {
  List<VRoom> sortByMsgId() {
    sort((a, b) {
      return b.lastMessage.id.compareTo(a.lastMessage.id);
    });
    return this;
  }
}
