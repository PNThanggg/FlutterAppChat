import 'package:chat_sdk_core/chat_sdk_core.dart';

class MessageAppBarStateModel {
  DateTime? lastSeenAt;
  String roomTitle;
  String roomId;
  String? peerId;
  String roomImage;
  VSocketRoomTypingModel typingModel;
  VRoomType roomType;
  bool isOnline;
  bool isSearching;
  int? memberCount;
  int? totalOnline;

  MessageAppBarStateModel._({
    required this.roomTitle,
    required this.roomId,
    required this.peerId,
    required this.roomImage,
    required this.typingModel,
    required this.roomType,
    required this.isOnline,
    required this.isSearching,
  });

  factory MessageAppBarStateModel.fromVRoom(VRoom room) {
    return MessageAppBarStateModel._(
      roomId: room.id,
      typingModel: room.typingStatus,
      isOnline: room.isOnline,
      roomImage: room.thumbImage,
      roomTitle: room.realTitle,
      roomType: room.roomType,
      isSearching: false,
      peerId: room.peerId,
    );
  }
}
