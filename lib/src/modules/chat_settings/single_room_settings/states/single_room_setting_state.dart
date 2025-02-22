import 'package:chat_sdk_core/chat_sdk_core.dart';

import '../../../peer_profile/states/peer_profile_state.dart';

class SingleRoomSettingState {
  final VToChatSettingsModel settingsModel;
  PeerProfileModel? user;
  bool isUpdatingMute = false;
  bool isUpdatingOneSeen = false;
  bool isUpdatingBlock = false;

  SingleRoomSettingState(this.settingsModel);
}
