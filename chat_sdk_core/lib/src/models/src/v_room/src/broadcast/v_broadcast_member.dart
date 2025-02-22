import 'package:chat_model/model.dart';

class VBroadcastMember {
  final BaseUser userData;
  final String createdAt;

  const VBroadcastMember({
    required this.userData,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'VBroadcastMember{userData: $userData, createdAt: $createdAt}';
  }

  DateTime get createdAtLocal => DateTime.parse(createdAt).toLocal();
  VBroadcastMember copyWith({
    BaseUser? user,
    String? createdAt,
  }) {
    return VBroadcastMember(
      userData: user ?? userData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userData': userData,
      'createdAt': createdAt,
    };
  }

  factory VBroadcastMember.fromMap(Map<String, dynamic> map) {
    return VBroadcastMember(
      userData: BaseUser.fromMap(map['userData'] as Map<String, dynamic>),
      createdAt: map['createdAt'] as String,
    );
  }
}
