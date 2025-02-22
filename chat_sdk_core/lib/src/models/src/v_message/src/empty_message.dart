import 'package:chat_sdk_core/chat_sdk_core.dart';

/// Empty message used to insert new room without mess
class VEmptyMessage extends VBaseMessage {
  VEmptyMessage()
      : super(
          id: "EmptyMessage",
          senderId: "EmptyMessage",
          senderName: "EmptyMessage",
          senderImageThumb: "Empty.url",
          isEncrypted: false,
          linkAtt: null,
          contentTr: null,
          platform: "EmptyMessage",
          roomId: "EmptyMessage",
          content: "",
          messageType: VMessageType.text,
          localId: "EmptyMessage",
          createdAt: DateTime.now().toLocal().toIso8601String(),
          updatedAt: DateTime.now().toLocal().toIso8601String(),
          replyTo: null,
          seenAt: null,
          isStared: false,
          deliveredAt: null,
          telegramName: null,
          emitStatus: VMessageEmitStatus.serverConfirm,
          forwardId: null,
          allDeletedAt: null,
          parentBroadcastId: null,
        );
}
