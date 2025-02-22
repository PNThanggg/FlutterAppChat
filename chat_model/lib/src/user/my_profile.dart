import 'dart:ui';

import 'package:chat_config/chat_constants.dart';
import 'package:chat_model/model.dart';
import 'package:chat_translation/generated/l10n.dart';

class MyProfile {
  final BaseUser baseUser;
  final RegisterStatus registerStatus;
  final Locale language;
  final String deviceId;
  final String? bio;
  final String email;

  final List<UserRole> roles;
  final String registerMethod;
  final UserPrivacy userPrivacy;

  ///getters
  // bool get isPrime => roles.contains(UserRoles.prime);
  bool get isPrime => true;

  bool get hasBadge => roles.contains(UserRole.hasBadge);

  const MyProfile({
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
    if (bio == null) return "${S.current.hiIamUse} ${ChatConstants.appName}";
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

  factory MyProfile.fromMap(Map<String, dynamic> map) {
    return MyProfile(
      baseUser: BaseUser.fromMap(map['me'] as Map<String, dynamic>),
      bio: map['me']['bio'] as String?,
      userPrivacy: (map['me']['userPrivacy'] as Map<String, dynamic>?) == null
          ? UserPrivacy.defaults()
          : UserPrivacy.fromMap(map['me']['userPrivacy']),
      registerMethod: map['me']['registerMethod'] as String,
      email: map['me']['email'] as String,
      roles: (map['me']['roles'] as List?)
              ?.map(
                (e) => UserRole.values.byName(e.toString()),
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

  MyProfile copyWith({
    BaseUser? baseUser,
    RegisterStatus? registerStatus,
    Locale? language,
    String? deviceId,
    List<UserRole>? roles,
    String? bio,
    String? email,
    UserPrivacy? userPrivacy,
    String? registerMethod,
  }) {
    return MyProfile(
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
