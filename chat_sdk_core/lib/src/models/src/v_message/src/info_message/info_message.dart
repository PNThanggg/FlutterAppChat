import 'dart:convert';

import 'package:chat_sdk_core/chat_sdk_core.dart';

class VInfoMessage extends VBaseMessage {
  final VMsgInfoAtt data;

  VInfoMessage({
    required super.id,
    required super.senderId,
    required super.linkAtt,
    required super.senderName,
    required super.emitStatus,
    required super.isEncrypted,
    required super.senderImageThumb,
    required super.platform,
    required super.roomId,
    required super.contentTr,
    required super.content,
    required super.messageType,
    required super.localId,
    required super.createdAt,
    required super.updatedAt,
    required super.replyTo,
    required super.seenAt,
    required super.deliveredAt,
    required super.forwardId,
    required super.allDeletedAt,
    required super.parentBroadcastId,
    required super.isStared,
    required super.telegramName,
    required this.data,
  });

  VInfoMessage.fromRemoteMap(super.map)
      : data = VMsgInfoAtt.fromMap(map['msgAtt'] as Map<String, dynamic>),
        super.fromRemoteMap();

  VInfoMessage.fromLocalMap(super.map)
      : data = VMsgInfoAtt.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String) as Map<String, dynamic>,
        ),
        super.fromLocalMap();

  @override
  Map<String, dynamic> toLocalMap({
    bool withOutConTr = false,
    bool withOutIsDownload = false,
  }) {
    return {
      ...super.toLocalMap(),
      MessageTable.columnAttachment: jsonEncode(data.toMap()),
    };
  }
}
