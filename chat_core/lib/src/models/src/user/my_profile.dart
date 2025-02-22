import 'dart:ui';

import 'package:chat_core/chat_core.dart';
import 'package:chat_translation/generated/l10n.dart';

class SMyProfile {
  final SBaseUser baseUser;
  final RegisterStatus registerStatus;
  final Locale language;
  final String deviceId;
  final String? bio;
  final String email;

  final List<UserRoles> roles;
  final String registerMethod;
  final UserPrivacy userPrivacy;

  ///getters
  // bool get isPrime => roles.contains(UserRoles.prime);
  bool get isPrime => true;

  bool get hasBadge => roles.contains(UserRoles.hasBadge);

  const SMyProfile({
    required this.baseUser,
    required this.registerStatus,
    required this.language,
    required this.deviceId,
    required this.bio,
    required this.roles,
    required this.userPrivacy,
    required this.email,
    required this.registerMethod,
  });

  String get userBio {
    if (bio == null) return "${S.current.hiIamUse} ${SConstants.appName}";
    return bio!;
  }

  @override
  String toString() {
    return 'SMyProfile{baseUser: $baseUser, registerStatus: $registerStatus, language: $language, deviceId: $deviceId, bio: $bio, '
        'email: $email, roles: $roles, registerMethod: $registerMethod}';
  }

  Map<String, dynamic> toMap() {
    return {
      'me': {
        ...baseUser.toMap(),
        'registerStatus': registerStatus.name,
        'bio': bio,
        'email': email,
        'registerMethod': registerMethod,
        'roles': roles.map((e) => e.name).toList(),
        'isPrime': isPrime,
        'hasBadge': hasBadge,
        'userPrivacy': userPrivacy.toMap(),
      },
      'currentDevice': {
        "_id": deviceId,
        "language": language.toString(),
      },
    };
  }

  factory SMyProfile.fromMap(Map<String, dynamic> map) {
    return SMyProfile(
      baseUser: SBaseUser.fromMap(map['me'] as Map<String, dynamic>),
      bio: map['me']['bio'] as String?,
      userPrivacy: (map['me']['userPrivacy'] as Map<String, dynamic>?) == null
          ? UserPrivacy.defaults()
          : UserPrivacy.fromMap(map['me']['userPrivacy']),
      registerMethod: map['me']['registerMethod'] as String,
      email: map['me']['email'] as String,
      roles: (map['me']['roles'] as List?)
              ?.map(
                (e) => UserRoles.values.byName(e.toString()),
              )
              .toList() ??
          [],
      language: Locale(
        (map['currentDevice'] as Map<String, dynamic>)['language'] as String,
      ),
      deviceId: (map['currentDevice'] as Map<String, dynamic>)['_id'] as String,
      registerStatus: RegisterStatus.values.byName(map['me']['registerStatus'] as String),
    );
  }

  SMyProfile copyWith({
    SBaseUser? baseUser,
    RegisterStatus? registerStatus,
    Locale? language,
    String? deviceId,
    List<UserRoles>? roles,
    String? bio,
    String? email,
    UserPrivacy? userPrivacy,
    String? registerMethod,
  }) {
    return SMyProfile(
      baseUser: baseUser ?? this.baseUser,
      registerStatus: registerStatus ?? this.registerStatus,
      language: language ?? this.language,
      deviceId: deviceId ?? this.deviceId,
      userPrivacy: userPrivacy ?? this.userPrivacy,
      roles: roles ?? this.roles,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      registerMethod: registerMethod ?? this.registerMethod,
    );
  }
}
