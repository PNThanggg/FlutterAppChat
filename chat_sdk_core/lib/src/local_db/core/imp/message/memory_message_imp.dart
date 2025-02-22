import 'package:collection/collection.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

extension CSortById on List<VBaseMessage> {
  List<VBaseMessage> sortById() {
    sort((a, b) {
      return b.id.compareTo(a.id);
    });
    return this;
  }
}

class MemoryMessageImp extends BaseLocalMessageRepo {
  final _messages = <VBaseMessage>[];

  @override
  Future<int> delete(VDeleteMessageEvent event) {
    _messages.removeWhere((e) => event.localId == e.localId);
    return Future.value(1);
  }

  @override
  Future<VBaseMessage?> findByLocalId(String localId) {
    return Future.value(
      _messages.singleWhereOrNull((e) => e.localId == localId),
    );
  }

  @override
  Future<int> insert(VInsertMessageEvent event) async {
    final old = await findByLocalId(event.localId);
    if (old != null) {
      throw VChatDartException(
        exception: "message already exist $old in web db",
      );
    }
    _messages.add(event.messageModel);
    return Future.value(1);
  }

  @override
  Future<List<VBaseMessage>> search({
    required String text,
    required String roomId,
    int limit = 150,
  }) {
    return Future.value(
      _messages
          .where(
            (e) =>
                e.roomId == roomId &&
                e.realContent.toLowerCase().startsWith(text.toLowerCase()),
          )
          .toList()
          .sortById()
          .take(limit)
          .toList(),
    );
  }

  @override
  Future<int> updateMessageStatus(VUpdateMessageStatusEvent event) async {
    final msg = await findByLocalId(event.localId);
    if (msg == null) return 0;
    msg.emitStatus = event.emitState;
    return Future.value(1);
  }

  @override
  Future<int> updateMessageToAllDeleted(
    VUpdateMessageAllDeletedEvent event,
  ) async {
    final msg = await findByLocalId(event.localId);

    if (msg == null) return 0;
    final i = _messages.indexOf(msg);
    _messages[i].allDeletedAt = event.message.allDeletedAt;
    return Future.value(1);
  }

  @override
  Future<int> updateMessagesToDeliver(
    VUpdateMessageDeliverEvent event,
  ) async {
    for (final m in _messages) {
      if (m.roomId == event.roomId &&
          m.senderId == event.model.userId &&
          m.deliveredAt == null) {
        m.deliveredAt = event.model.date;
      }
    }
    return Future.value(1);
  }

  @override
  Future<int> updateMessagesToSeen(VUpdateMessageSeenEvent event) async {
    for (final m in _messages) {
      if (m.roomId == event.roomId &&
          m.senderId == event.model.userId &&
          m.seenAt == null) {
        m.seenAt = event.model.date;
        m.deliveredAt ??= event.model.date;
      }
    }
    return Future.value(1);
  }

  @override
  Future<List<VBaseMessage>> getMessagesByStatus({
    required VMessageEmitStatus status,
    int limit = 50,
  }) {
    return Future.value(
      _messages.where((e) => e.emitStatus == status).take(limit).toList(),
    );
  }

  @override
  Future<VBaseMessage?> findOneMessageBeforeThis(
    String createdAt,
    String roomId,
  ) async {
    return Future.value();
  }

  @override
  Future<List<VBaseMessage>> getRoomMessages({
    required String roomId,
    required VRoomMessagesDto filter,
  }) async {
    if (filter.lastId != null) {
      return Future.value([]);
    }
    return Future.value(
      _messages
          .where((e) => e.roomId == roomId)
          .toList()
          .sortById()
          .take(filter.limit)
          .toList(),
    );
  }

  @override
  Future<int> updateMessagesFromSendingToError() {
    // for (final e in _messages) {
    //   e.messageStatus = MessageSendingStatusEnum.error;
    // }
    return Future.value(1);
  }

  @override
  Future<int> reCreate() {
    _messages.clear();
    return Future.value(1);
  }

  @override
  Future<int> deleteAllMessagesByRoomId(String roomId) {
    _messages.removeWhere((e) => e.roomId == roomId);
    return Future.value(1);
  }

  @override
  Future<int> insertMany(List<VBaseMessage> messages) {
    if (messages.isEmpty) {
      return Future.value(1);
    }
    _messages.removeWhere((e) => e.roomId == messages.first.roomId);
    _messages.addAll(messages);
    return Future.value(1);
  }

  @override
  Future<int> updateFullMessage({
    required VBaseMessage baseMessage,
  }) async {
    final msgIndex = _messages.indexOf(baseMessage);
    if (msgIndex != -1) {
      _messages[msgIndex] = baseMessage;
    }
    return 1;
  }

  @override
  Future<int> updateMessageStar(VUpdateMessageStarEvent event) async {
    final m = _messages.singleWhereOrNull((e) => e.localId == event.localId);
    if (m == null) return 0;
    m.isStared = event.isStar;
    return Future.value(1);
  }

  @override
  Future<int> updateMessageOneSeenByMe(VUpdateMessageOneSeenEvent event) async {
    final msg = await findByLocalId(event.localId);
    if (msg == null) return 0;
    msg.isOneSeenByMe = true;
    return Future.value(1);
  }

  @override
  Future<int> updateIsDownloadingMessage(
    VUpdateIsDownloadMessageEvent event,
  ) async {
    final msg = await findByLocalId(event.localId);
    if (msg == null) return 0;
    msg.isDownloading = event.isDownloading;
    return Future.value(1);
  }
}
