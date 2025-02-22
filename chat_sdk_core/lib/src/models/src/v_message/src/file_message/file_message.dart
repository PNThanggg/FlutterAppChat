import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_platform/v_platform.dart';

class VFileMessage extends VBaseMessage implements VDownloadableMessage, VUploadMessage {
  final VMessageFileData data;

  VFileMessage({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.senderImageThumb,
    required super.contentTr,
    required super.platform,
    required super.roomId,
    required super.content,
    required super.linkAtt,
    required super.emitStatus,
    required super.messageType,
    required super.localId,
    required super.isEncrypted,
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

  VFileMessage.fromRemoteMap(super.map)
      : data = VMessageFileData(
          fileSource: VPlatformFile.fromMap(
            map['msgAtt'] as Map<String, dynamic>,
          ),
        ),
        super.fromRemoteMap();

  VFileMessage.fromLocalMap(super.map)
      : data = VMessageFileData(
          fileSource: VPlatformFile.fromMap(
            jsonDecode(map[MessageTable.columnAttachment] as String) as Map<String, dynamic>,
          ),
        ),
        super.fromLocalMap();

  // @override
  // Map<String, dynamic> toRemoteMap() {
  //   return {...super.toRemoteMap(), 'msgAtt': fileUrlAttachment.toMap()};
  // }

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
  List<PartValue> toListOfPartValue() {
    return [
      ...super.toListOfPartValue(),
    ];
  }

  VFileMessage.buildMessage({
    required super.roomId,
    required this.data,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(
          content: VMessageConstants.thisContentIsFile,
          messageType: VMessageType.file,
          isEncrypted: false,
          linkAtt: null,
        );

  @override
  VPlatformFile get fileSource => data.fileSource;

  @override
  bool get isFileDownloaded => VFileUtils.isFileExists(localFilePathWithExt);

  @override
  String get localFilePathWithExt => fileSource.fileHash + fileSource.extension;
}
