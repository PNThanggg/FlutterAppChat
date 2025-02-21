import 'package:enum_to_string/enum_to_string.dart';
import 'package:super_up_core/super_up_core.dart';

class UserPrivacy {
  final UserPrivacyType startChat;
  final UserPrivacyType showStory;
  final bool publicSearch;
  final bool lastSeen;

  const UserPrivacy({
    required this.startChat,
    required this.showStory,
    required this.publicSearch,
    required this.lastSeen,
  });

  const UserPrivacy.defaults()
      : startChat = UserPrivacyType.forReq,
        showStory = UserPrivacyType.forReq,
        publicSearch = true,
        lastSeen = true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPrivacy &&
          runtimeType == other.runtimeType &&
          startChat == other.startChat &&
          showStory == other.showStory &&
          publicSearch == other.publicSearch &&
          lastSeen == other.lastSeen);

  @override
  int get hashCode => startChat.hashCode ^ showStory.hashCode ^ publicSearch.hashCode ^ lastSeen.hashCode;

  @override
  String toString() {
    return 'UserPrivacy{ startChat: $startChat, showStory: $showStory, publicSearch: $publicSearch, lastSeen: $lastSeen}';
  }

  UserPrivacy copyWith({
    UserPrivacyType? startChat,
    UserPrivacyType? showStory,
    bool? publicSearch,
    bool? lastSeen,
  }) {
    return UserPrivacy(
      startChat: startChat ?? this.startChat,
      showStory: showStory ?? this.showStory,
      publicSearch: publicSearch ?? this.publicSearch,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startChat': startChat.name,
      'showStory': showStory.name,
      'publicSearch': publicSearch,
      'lastSeen': lastSeen,
    };
  }

  factory UserPrivacy.fromMap(Map<String, dynamic> map) {
    return UserPrivacy(
      startChat: EnumToString.fromString(UserPrivacyType.values, map['startChat'] as String) ?? UserPrivacyType.none,
      showStory: EnumToString.fromString(UserPrivacyType.values, map['showStory'] as String) ?? UserPrivacyType.none,
      publicSearch: map['publicSearch'] as bool,
      lastSeen: map['lastSeen'] as bool,
    );
  }
}
