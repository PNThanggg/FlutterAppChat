import 'package:chat_sdk_core/chat_sdk_core.dart';

class GroupRoomSettingState {
  final VToChatSettingsModel settingsModel;
  bool isUpdatingMute = false;
  bool isUpdatingOneSeen = false;
  bool isUpdatingExitGroup = false;
  VMyGroupInfo? groupInfo;

  GroupRoomSettingState(this.settingsModel);
}
