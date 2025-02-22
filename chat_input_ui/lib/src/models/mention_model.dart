import 'package:chat_config/chat_constants.dart';

class MentionModel {
  final String peerId;
  final String name;
  final String image;

  MentionModel({
    required this.peerId,
    required this.name,
    required this.image,
  });

  String get imageS3 => ChatConstants.baseMediaUrl + image;

  Map<String, dynamic> toMap() {
    return {
      'peerId': peerId,
      'name': name,
      'image': image,
    };
  }

  factory MentionModel.fromMap(Map<String, dynamic> map) {
    return MentionModel(
      peerId: map['peerId'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }
}
