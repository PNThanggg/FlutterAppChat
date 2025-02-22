class UserData {
  final int totalUsersCount;
  final int deleted;
  final int banned;
  final int allVerifiedUsersCount;
  final Map<String, int> userStatusCounter;
  final int online;

  UserData({
    required this.totalUsersCount,
    required this.deleted,
    required this.banned,
    required this.allVerifiedUsersCount,
    required this.userStatusCounter,
    required this.online,
  });

  UserData.empty()
      : totalUsersCount = 0,
        deleted = 0,
        banned = 0,
        allVerifiedUsersCount = 0,
        userStatusCounter = {},
        online = 0;

  Map<String, dynamic> toMap() {
    return {
      'totalUsersCount': totalUsersCount,
      'deleted': deleted,
      'banned': banned,
      'allVerifiedUsersCount': allVerifiedUsersCount,
      'userStatusCounter': userStatusCounter,
      'online': online,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      totalUsersCount: map['totalUsersCount'],
      deleted: map['deleted'],
      banned: map['banned'],
      allVerifiedUsersCount: map['allVerifiedUsersCount'],
      userStatusCounter: Map<String, int>.from(map['userStatusCounter']),
      online: map['online'],
    );
  }
}
