import 'package:enum_to_string/enum_to_string.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:chat_core/chat_core.dart';

class SSearchUser {
  final SBaseUser baseUser;
  final String? bio;
  final String createdAt;
  final List<SUserRole> roles;

  const SSearchUser({
    required this.baseUser,
    required this.bio,
    required this.roles,
    required this.createdAt,
  });

  bool get isPrime => roles.contains(SUserRole.prime);

  bool get isStaff => roles.contains(SUserRole.staff);

  bool get hasBadge => roles.contains(SUserRole.hasBadge);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SSearchUser &&
          runtimeType == other.runtimeType &&
          baseUser == other.baseUser &&
          bio == other.bio &&
          createdAt == other.createdAt);

  @override
  int get hashCode => baseUser.hashCode ^ bio.hashCode ^ createdAt.hashCode;

  @override
  String toString() {
    return 'SSearchUser{baseUser: $baseUser, roles: ${roles.toString()}, bio: $bio, createdAt: $createdAt}';
  }

  String get getUserBio {
    if (bio == null) return "${S.current.hiIamUse} ${SConstants.appName}";
    return bio!;
  }

  Map<String, dynamic> toMap() {
    return {
      ...baseUser.toMap(),
      'bio': bio,
      'createdAt': createdAt,
      'roles': roles.map((e) => e.name).toList(),
    };
  }

  factory SSearchUser.fromMap(Map<String, dynamic> map) {
    return SSearchUser(
      baseUser: SBaseUser.fromMap(map),
      bio: map['bio'] as String?,
      roles: map['roles'] == null
          ? []
          : (map['roles'] as List)
              .map(
                (e) => EnumToString.fromString(SUserRole.values, e) ?? SUserRole.bug,
              )
              .toList(),
      createdAt: map['createdAt'] as String,
    );
  }
}
