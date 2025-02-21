import 'package:super_up_core/super_up_core.dart';

class SSelectableUser {
  final SSearchUser searchUser;
  bool isSelected = false;

  SSelectableUser({
    required this.searchUser,
    this.isSelected = false,
  });
}
