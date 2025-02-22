import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

import '../room.dart';

final vDefaultRoomNavigator = VRoomNavigator(
  toForwardPage: (context, currentRoomId) async {
    return await context.toPage(
          VChooseRoomsPage(
            currentRoomId: currentRoomId,
          ),
        ) ??
        [];
  },
);
