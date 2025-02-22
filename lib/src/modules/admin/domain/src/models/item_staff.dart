class ItemStaff {
  final int id;
  final String userUid;
  final String deviceToken;
  final bool isAdmin;
  final String adminUid;

  ItemStaff({
    required this.id,
    required this.userUid,
    required this.deviceToken,
    required this.isAdmin,
    required this.adminUid,
  });

  ItemStaff.empty()
      : id = -1,
        userUid = "------",
        deviceToken = "------",
        isAdmin = false,
        adminUid = "------";

  factory ItemStaff.fromJson(Map<String, dynamic> json) {
    return ItemStaff(
      id: json['id'],
      userUid: json['userUid'],
      deviceToken: json['deviceToken'],
      isAdmin: json['isAdmin'],
      adminUid: json['adminUid'] ?? "",
    );
  }
}
