import 'dart:convert';

import 'package:chat_sdk_core/chat_sdk_core.dart';

class VCustomMessage extends VBaseMessage {
  final VCustomMsgData data;

  VCustomMessage({
    required super.id,
    required super.linkAtt,
    required super.senderId,
    required super.senderName,
    required super.contentTr,
    required super.emitStatus,
    required super.isEncrypted,
    required super.senderImageThumb,
    required super.platform,
    required super.roomId,
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

  VCustomMessage.buildMessage({
    required super.roomId,
    required this.data,
    required super.content,
    super.replyTo,
  }) : super.buildMessage(
          messageType: VMessageType.custom,
          isEncrypted: false,
          linkAtt: null,
        );

  VCustomMessage.fromRemoteMap(super.map)
      : data = VCustomMsgData.fromMap(map['msgAtt'] as Map<String, dynamic>),
        super.fromRemoteMap();

  VCustomMessage.fromLocalMap(super.map)
      : data = VCustomMsgData.fromMap(
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
