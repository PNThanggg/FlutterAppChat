import 'package:chat_sdk_core/chat_sdk_core.dart';

abstract class BaseLocalRoomRepo {
  Future<int> insert(VInsertRoomEvent event);

  Future<int> updateName(VUpdateRoomNameEvent event);

  Future<int> updateTransTo(VUpdateTransToEvent event);

  Future<int> insertMany(List<VRoom> rooms);

  Future<int> updateImage(VUpdateRoomImageEvent event);

  Future<int> updateCountByOne(VUpdateRoomUnReadCountByOneEvent event);
  Future<int> updateNickName(VUpdateLocalRoomNickNameEvent event);
  Future<int> updateCountToZero(VUpdateRoomUnReadCountToZeroEvent event);

  Future<int> updateIsMuted(VUpdateRoomMuteEvent event);
  Future<int> updateOneSeen(VUpdateRoomOneSeenEvent event);

  Future<int> delete(VDeleteRoomEvent event);

  Future<void> reCreate();

  Future<VRoom?> getOneByPeerId(String roomId);

  Future<String?> getRoomIdByPeerId(String peerId);

  Future<bool> isRoomExist(String roomId);

  Future<VRoom?> getOneWithLastMessageByRoomId(String roomId);

  Future<List<VRoom>> search(String text, int limit, VRoomType? roomType);

  Future<List<VRoom>> getRoomsWithLastMessage({int limit = 300});

  Future<int> getUnReadMessagesCount();
  Future<int> getUnReadRoomsCount();
}
