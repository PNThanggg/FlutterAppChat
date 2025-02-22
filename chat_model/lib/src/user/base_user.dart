import 'package:chat_config/chat_constants.dart';
import 'package:chat_model/model.dart';

class BaseUser {
  final String id;
  final String userImage;
  final String fullName;

  const BaseUser({
    required this.id,
    required this.fullName,
    required this.userImage,
  });

  bool get isMe => id == AppAuth.myId;

  String get userImageS3 => ChatConstants.baseMediaUrl + userImage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BaseUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User{'
        ' id: $id,'
        ' fullName: $fullName,'
        ' userImage: $userImage,'
        '}';
  }

  static const myUser = BaseUser(
    id: "1",
    fullName: "user 1",
    userImage: "https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png",
  );

  BaseUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? userImage,
  }) {
    return BaseUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      userImage: userImage ?? this.userImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'fullName': fullName,
      'userImage': userImage,
    };
  }

  factory BaseUser.fromMap(Map<String, dynamic> map) {
    return BaseUser(
      id: map['_id'] as String,
      fullName: map['fullName'] as String,
      userImage: map['userImage'] as String,
    );
  }
}
