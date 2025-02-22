import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';

import '../../providers/message_provider.dart';

class BroadcastAppBarController extends ValueNotifier<BroadcastAppBarStateModel> {
  final VRoom vRoom;
  final MessageProvider messageProvider;
  final String _cacheKey = "broadcast-info-";

  BroadcastAppBarController({
    required this.vRoom,
    required this.messageProvider,
  }) : super(BroadcastAppBarStateModel.fromVRoom(vRoom)) {
    _getFromCache();
    updateFromRemote();
  }

  void close() {
    dispose();
  }

  void onOpenSearch() {
    value.isSearching = true;
    notifyListeners();
  }

  void onCloseSearch() {
    value.isSearching = false;
    notifyListeners();
  }

  void updateValue(VMyBroadcastInfo value) {
    this.value.members = value.totalUsers;
    notifyListeners();
  }

  Future<void> _getFromCache() async {
    final res = ChatPreferences.getMap("$_cacheKey${vRoom.id}");
    if (res == null) return;
    updateValue(VMyBroadcastInfo.fromMap(res));
  }

  Future<void> updateFromRemote() async {
    await vSafeApiCall<VMyBroadcastInfo>(
      request: () {
        return VChatController.I.roomApi.getBroadcastMyInfo(roomId: vRoom.id);
      },
      onSuccess: (response) async {
        updateValue(response);
        await ChatPreferences.setMap("$_cacheKey${vRoom.id}", response.toMap());
      },
    );
  }
}

class BroadcastAppBarStateModel {
  final String roomTitle;
  final String roomId;
  final String roomImage;
  bool isSearching;
  int members;

  BroadcastAppBarStateModel._({
    required this.roomTitle,
    required this.roomId,
    required this.roomImage,
    required this.members,
    required this.isSearching,
  });

  factory BroadcastAppBarStateModel.fromVRoom(VRoom room) {
    return BroadcastAppBarStateModel._(
      roomId: room.id,
      roomImage: room.thumbImage,
      members: 0,
      roomTitle: room.realTitle,
      isSearching: false,
    );
  }
}
