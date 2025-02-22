import 'package:chat_sdk_core/chat_sdk_core.dart';

class VMyGroupSettings {
  final String creatorId;
  final Map<String, dynamic>? pinMsg;
  final Map<String, dynamic>? extraData;
  final String? desc;
  final String? targetTelegramGroup;
  final String createdAt;

  const VMyGroupSettings({
    required this.creatorId,
    this.pinMsg,
    this.extraData,
    this.desc,
    this.targetTelegramGroup,
    required this.createdAt,
  });

  DateTime get createAtDate => DateTime.parse(createdAt).toLocal();

  bool get isMeCreator => VAppConstants.myId == creatorId;

  VMyGroupSettings.empty()
      : creatorId = "",
        desc = null,
        extraData = null,
        createdAt = DateTime.now().toIso8601String(),
        targetTelegramGroup = null,
        pinMsg = null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMyGroupSettings &&
          runtimeType == other.runtimeType &&
          creatorId == other.creatorId &&
          pinMsg == other.pinMsg &&
          targetTelegramGroup == other.targetTelegramGroup &&
          desc == other.desc);

  @override
  int get hashCode => creatorId.hashCode ^ pinMsg.hashCode ^ targetTelegramGroup.hashCode ^ desc.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'cId': creatorId,
      'pinMsg': pinMsg,
      'extraData': extraData,
      'desc': desc,
      'targetTelegramGroup': targetTelegramGroup,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'VMyGroupSettings{creatorId: $creatorId, pinMsg: $pinMsg, extraData: $extraData, targetTelegramGroup: $targetTelegramGroup, desc: $desc createdAt $createdAt}';
  }

  factory VMyGroupSettings.fromMap(Map<String, dynamic> map) {
    return VMyGroupSettings(
      creatorId: map['cId'] as String,
      pinMsg: map['pinMsg'] as Map<String, dynamic>?,
      extraData: map['extraData'] as Map<String, dynamic>?,
      desc: map['desc'] as String?,
      targetTelegramGroup: map['targetTelegramGroup'] as String?,
      createdAt: map['createdAt'] as String,
    );
  }

  VMyGroupSettings copyWith({
    String? creatorId,
    Map<String, dynamic>? pinMsg,
    Map<String, dynamic>? extraData,
    String? desc,
    String? createdAt,
    String? targetTelegramGroup,
  }) {
    return VMyGroupSettings(
      creatorId: creatorId ?? this.creatorId,
      pinMsg: pinMsg ?? this.pinMsg,
      extraData: extraData ?? this.extraData,
      desc: desc ?? this.desc,
      targetTelegramGroup: targetTelegramGroup ?? this.targetTelegramGroup,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
