import 'package:chat_model/model.dart';

/// A model class that represents a new call.<br />
class VNewCallModel {
  /// The ID of the room for the call.<br />
  final String roomId;

  /// The ID of the meeting for the call.<br />
  final String meetId;

  /// A boolean that indicates whether the call has video or not.<br />
  final bool withVideo;

  /// An object that represents the peerId user of the call.<br />
  final BaseUser peerUser;

  /// A map that represents the payload of the call.<br />
  final Map<String, dynamic>? payload;

  /// Creates a new instance of [VNewCallModel].<br />
  const VNewCallModel({
    required this.roomId,
    required this.meetId,
    required this.withVideo,
    required this.peerUser,
    required this.payload,
  });

  int get getAgoraUserId {
    final concatenatedNumber = int.parse(peerUser.id.replaceAll(RegExp(r'\D'), ''), radix: 10);
    return concatenatedNumber;
  }

  /// Converts the [VNewCallModel] object to a map.<br />
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'meetId': meetId,
      'withVideo': withVideo,
      'payload': payload,
      'userData': peerUser.toMap(),
    };
  }

  /// Creates a new instance of [VNewCallModel] from the given map.<br />
  factory VNewCallModel.fromMap(Map<String, dynamic> map) {
    return VNewCallModel(
      roomId: map['roomId'] as String,
      meetId: map['meetId'] as String,
      withVideo: map['withVideo'] as bool,
      payload: map['payload'] as Map<String, dynamic>?,
      peerUser: BaseUser.fromMap(
        map['userData'] as Map<String, dynamic>,
      ),
    );
  }
}
