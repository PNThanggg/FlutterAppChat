import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';

class GroupAppBarController extends ValueNotifier<GroupAppBarStateModel> with StreamMix {
  final VRoom vRoom;
  final MessageProvider messageProvider;

  GroupAppBarController({
    required this.vRoom,
    required this.messageProvider,
  }) : super(GroupAppBarStateModel.fromVRoom(vRoom)) {
    streamsMix.addAll(
      [
        VEventBusSingleton.vEventBus.on<VUpdateRoomImageEvent>().listen((event) {
          value.roomImage = event.image;
        }),
        VEventBusSingleton.vEventBus.on<VUpdateRoomNameEvent>().listen((event) {
          value.roomTitle = event.name;
        }),
        VEventBusSingleton.vEventBus.on<VUpdateRoomTypingEvent>().where((e) => e.roomId == value.roomId).listen(
              (event) => updateTyping(event.typingModel),
            ),
      ],
    );
  }

  void close() {
    dispose();
    closeStreamMix();
  }

  void onOpenSearch() {
    value.isSearching = true;
    notifyListeners();
  }

  void onCloseSearch() {
    value.isSearching = false;
    notifyListeners();
  }

  void updateRoomImage(String value) {
    this.value.roomImage = value;
    notifyListeners();
  }

  void updateValue(VMyGroupInfo value) {
    this.value.myGroupInfo = value;
    notifyListeners();
  }

  void updateTyping(VSocketRoomTypingModel typingModel) {
    value.typingModel = typingModel;
    notifyListeners();
  }
}

class GroupAppBarStateModel {
  String roomTitle;
  final String roomId;
  String roomImage;
  bool isSearching;
  VMyGroupInfo myGroupInfo;
  VSocketRoomTypingModel typingModel;

  GroupAppBarStateModel._({
    required this.roomTitle,
    required this.roomId,
    required this.roomImage,
    required this.myGroupInfo,
    required this.typingModel,
    required this.isSearching,
  });

  factory GroupAppBarStateModel.fromVRoom(VRoom room) {
    return GroupAppBarStateModel._(
      roomId: room.id,
      typingModel: room.typingStatus,
      roomImage: room.thumbImage,
      myGroupInfo: VMyGroupInfo.empty(),
      roomTitle: room.realTitle,
      isSearching: false,
    );
  }
}
