import 'package:chat_core/chat_core.dart';

class SSelectableUser {
  final SSearchUser searchUser;
  bool isSelected = false;

  SSelectableUser({
    required this.searchUser,
    this.isSelected = false,
  });
}
