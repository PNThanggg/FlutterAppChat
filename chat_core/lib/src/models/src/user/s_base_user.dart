import 'package:chat_core/chat_core.dart';

class SBaseUser {
  final String id;
  final String userImage;
  final String fullName;

  const SBaseUser({
    required this.id,
    required this.fullName,
    required this.userImage,
  });

  bool get isMe => id == AppAuth.myId;

  String get userImageS3 => SConstants.baseMediaUrl + userImage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SBaseUser && runtimeType == other.runtimeType && id == other.id;

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

  static const myUser = SBaseUser(
    id: "1",
    fullName: "user 1",
    userImage:
        "https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png",
  );

  SBaseUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? userImage,
  }) {
    return SBaseUser(
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

  factory SBaseUser.fromMap(Map<String, dynamic> map) {
    return SBaseUser(
      id: map['_id'] as String,
      fullName: map['fullName'] as String,
      userImage: map['userImage'] as String,
    );
  }
}
