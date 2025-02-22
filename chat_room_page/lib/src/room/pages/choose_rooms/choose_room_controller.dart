import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

class ChooseRoomsController extends ValueNotifier<List<VRoom>> {
  final String? currentId;

  ChooseRoomsController(this.currentId)
      : super(
          [],
        ) {
    _getRooms();
  }

  void close() {}
  final maxForward = VChatController.I.vChatConfig.maxForward;

  bool get isThereSelection => value.firstWhereOrNull((e) => e.isSelected) == null;

  void onDone(BuildContext context) {
    final l = <String>[];
    for (var element in value) {
      if (element.isSelected) {
        l.add(element.id);
      }
    }
    Navigator.pop(context, l);
  }

  void _getRooms() async {
    final vRooms = (await VChatController.I.nativeApi.local.room.getRooms(limit: 120))
        .where((e) => e.id != currentId && !e.roomType.isBroadcast)
        .toList();
    value = vRooms;
  }

  int get selectedCount => value.where((e) => e.isSelected).length;

  bool isSelect(VRoom room) => room.isSelected == false;

  void onRoomItemPress(VRoom room, BuildContext context) {
    if (isSelect(room)) {
      if (selectedCount >= maxForward) {
        return;
      }
    }

    value.firstWhere((e) => e == room).toggleSelect();
    notifyListeners();
  }
}
