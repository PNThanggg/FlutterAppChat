import 'package:chat_model/model.dart';

class SelectableUser {
  final SearchUser searchUser;
  bool isSelected = false;

  SelectableUser({
    required this.searchUser,
    this.isSelected = false,
  });
}
