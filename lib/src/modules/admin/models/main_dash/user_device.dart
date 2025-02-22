class UserDevices {
  final int all;
  final int web;
  final int ios;
  final int mac;
  final int windows;
  final int linux;
  final int android;
  final int other;

  UserDevices({
    required this.all,
    required this.web,
    required this.ios,
    required this.mac,
    required this.windows,
    required this.linux,
    required this.android,
    required this.other,
  });

  UserDevices.empty()
      : all = 0,
        web = 0,
        ios = 0,
        mac = 0,
        windows = 0,
        linux = 0,
        android = 0,
        other = 0;

  Map<String, dynamic> toMap() {
    return {
      'all': all,
      'web': web,
      'ios': ios,
      'mac': mac,
      'windows': windows,
      'linux': linux,
      'android': android,
      'other': other,
    };
  }

  factory UserDevices.fromMap(Map<String, dynamic> map) {
    return UserDevices(
      all: map['all'],
      web: map['web'],
      ios: map['ios'],
      mac: map['mac'],
      windows: map['windows'],
      linux: map['linux'],
      android: map['android'],
      other: map['other'],
    );
  }
}
