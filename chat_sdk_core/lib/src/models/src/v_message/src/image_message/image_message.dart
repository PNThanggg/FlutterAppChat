import 'dart:convert';

import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chopper/chopper.dart';

class VImageMessage extends VBaseMessage implements VDownloadableMessage, VUploadMessage {
  final VMessageImageData data;

  VImageMessage({
    required super.id,
    required super.senderId,
    required super.linkAtt,
    required super.contentTr,
    required super.senderName,
    required super.isEncrypted,
    required super.emitStatus,
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

  String get downloadedFileLocalPath => VFileUtils.getLocalPath(localId + data.fileSource.extension);

  VImageMessage.fromRemoteMap(super.map)
      : data = VMessageImageData.fromMap(
          map['msgAtt'] as Map<String, dynamic>,
        ),
        super.fromRemoteMap();

  VImageMessage.fromLocalMap(super.map)
      : data = VMessageImageData.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String) as Map<String, dynamic>,
        ),
        super.fromLocalMap();

  @override
  Map<String, dynamic> toRemoteMap() {
    return {
      ...super.toRemoteMap(),
      'msgAtt': data.toMap(),
    };
  }

  VImageMessage.buildMessage({
    required super.roomId,
    required this.data,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(
          isEncrypted: false,
          linkAtt: null,
          content: VMessageConstants.thisContentIsImage,
          messageType: VMessageType.image,
        );

  @override
  List<PartValue> toListOfPartValue() {
    return [
      PartValue(
        'attachment',
        jsonEncode(data.toMap()),
      ),
      ...super.toListOfPartValue(),
    ];
  }

  @override
  String toString() {
    return 'ImageMessage{fileSource: $data, content: $content';
  }

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

  @override
  VPlatformFile get fileSource => data.fileSource;

  @override
  bool get isFileDownloaded => VFileUtils.isFileExists(localFilePathWithExt);

  @override
  String get localFilePathWithExt => fileSource.fileHash + fileSource.extension;
}
