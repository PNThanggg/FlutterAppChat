import 'package:chat_core/chat_core.dart';
import 'package:chat_room_page/chat_room_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AllTabController extends ValueNotifier implements BaseController {
  final vRoomController = VRoomController();

  AllTabController() : super(null);

  @override
  void onClose() {
    vRoomController.dispose();
  }

  @override
  void onInit() {}
}
