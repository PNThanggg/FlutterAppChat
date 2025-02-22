import 'package:chat_config/chat_constants.dart';
import 'package:chat_model/model.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:enum_to_string/enum_to_string.dart';

class SearchUser {
  final BaseUser baseUser;
  final String? bio;
  final String createdAt;
  final List<UserRole> roles;

  const SearchUser({
    required this.baseUser,
    required this.bio,
    required this.roles,
    required this.createdAt,
  });

  bool get isPrime => roles.contains(UserRole.prime);

  bool get isStaff => roles.contains(UserRole.staff);

  bool get hasBadge => roles.contains(UserRole.hasBadge);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchUser &&
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
    if (bio == null) return "${S.current.hiIamUse} ${ChatConstants.appName}";
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

  factory SearchUser.fromMap(Map<String, dynamic> map) {
    return SearchUser(
      baseUser: BaseUser.fromMap(map),
      bio: map['bio'] as String?,
      roles: map['roles'] == null
          ? []
          : (map['roles'] as List)
              .map(
                (e) => EnumToString.fromString(UserRole.values, e) ?? UserRole.bug,
              )
              .toList(),
      createdAt: map['createdAt'] as String,
    );
  }
}
