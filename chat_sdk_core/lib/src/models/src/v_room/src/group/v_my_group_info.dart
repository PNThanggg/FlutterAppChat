import 'package:chat_sdk_core/chat_sdk_core.dart';

class VMyGroupInfo {
  final bool isMeOut;
  final int membersCount;
  final int totalOnline;
  final VGroupMemberRole myRole;
  //it will be null if you not user of this group
  final VMyGroupSettings? groupSettings;

  const VMyGroupInfo({
    required this.isMeOut,
    required this.membersCount,
    required this.totalOnline,
    required this.myRole,
    required this.groupSettings,
  });

  bool get isMeMember => myRole == VGroupMemberRole.member;

  bool get isMeAdmin => myRole == VGroupMemberRole.admin;

  bool get isMeSuperAdmin => myRole == VGroupMemberRole.superAdmin;

  bool get isMeAdminOrSuperAdmin => isMeAdmin || isMeSuperAdmin;

  VMyGroupInfo.empty()
      : membersCount = 0,
        totalOnline = 0,
        myRole = VGroupMemberRole.member,
        groupSettings = VMyGroupSettings.empty(),
        isMeOut = false;

  @override
  String toString() {
    return 'VMyGroupInfo{isMeOut: $isMeOut, totalOnline:$totalOnline,membersCount: $membersCount, myRole: $myRole, groupSettings: $groupSettings}';
  }

  Map<String, dynamic> toMap() {
    return {
      'isMeOut': isMeOut,
      'membersCount': membersCount,
      'totalOnline': totalOnline,
      'myRole': myRole.name,
      'groupSettings': groupSettings?.toMap(),
    };
  }

  factory VMyGroupInfo.fromMap(Map<String, dynamic> map) {
    return VMyGroupInfo(
      isMeOut: map['isMeOut'] as bool,
      membersCount: map['membersCount'] as int,
      totalOnline: map['totalOnline'] as int,
      groupSettings: (map['groupSettings'] as Map<String, dynamic>?) == null
          ? null
          : VMyGroupSettings.fromMap(
              map['groupSettings'] as Map<String, dynamic>,
            ),
      myRole: VGroupMemberRole.values.byName(map['myRole'] as String),
    );
  }

  VMyGroupInfo copyWith({
    bool? isMeOut,
    int? membersCount,
    int? totalOnline,
    VGroupMemberRole? myRole,
    VMyGroupSettings? groupSettings,
  }) {
    return VMyGroupInfo(
      isMeOut: isMeOut ?? this.isMeOut,
      membersCount: membersCount ?? this.membersCount,
      totalOnline: totalOnline ?? this.totalOnline,
      myRole: myRole ?? this.myRole,
      groupSettings: groupSettings ?? this.groupSettings,
    );
  }
}
