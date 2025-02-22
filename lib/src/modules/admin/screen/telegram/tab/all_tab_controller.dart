import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';

class AllTabController extends ValueNotifier implements SBaseController {
  final vRoomController = VRoomController();

  AllTabController() : super(null);

  @override
  void onClose() {
    vRoomController.dispose();
  }

  @override
  void onInit() {}

// void createNewGroup(BuildContext context) async {
//   final groupRoom = await showCupertinoModalBottomSheet(
//     expand: true,
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (context) => const SheetForCreateGroup(),
//   ) as VRoom?;
//   if (groupRoom == null) {
//     return;
//   }
//   VChatController.I.vNavigator.messageNavigator
//       .toMessagePage(context, groupRoom);
// }
//
// void createNewBroadcast(BuildContext context) async {
//   final broadcastRoom = await showCupertinoModalBottomSheet(
//     expand: true,
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (context) => const SheetForCreateBroadcast(),
//   );
//   if (broadcastRoom == null) {
//     return;
//   }
//   VChatController.I.vNavigator.messageNavigator
//       .toMessagePage(context, broadcastRoom);
// }
//
// void onSearchClicked(BuildContext context) {
//   context.toPage(const ChatsSearchView());
// }
//
// void onCameraPress(BuildContext context) async {
//   //  await PlatformNotifier.I.showChatNotification(
//   //    userImage: "",
//   //    context: context,
//   //    model: ShowPluginNotificationModel(id: DateTime.now().microsecond.hashCode, title: "title", body: "body"),
//   //    userName: 'xx',
//   //    conversationTitle: 'xx',
//   //  );
//   // return;
//   final fileSource = await VAppPick.getImage(isFromCamera: true);
//   if (fileSource == null) return;
//   final roomsIds = await VChatController.I.vNavigator.roomNavigator
//       .toForwardPage(context, null);
//   final data = await VFileUtils.getImageInfo(
//     fileSource: fileSource,
//   );
//   if (roomsIds != null) {
//     for (final roomId in roomsIds) {
//       final message = VImageMessage.buildMessage(
//         roomId: roomId,
//         data: VMessageImageData(
//           fileSource: fileSource,
//           height: data.image.height,
//           width: data.image.width,
//           blurHash: await VMediaFileUtils.getBlurHash(fileSource),
//         ),
//       );
//       await VChatController.I.nativeApi.local.message.insertMessage(message);
//       try {
//         VMessageUploaderQueue.instance.addToQueue(
//           await MessageFactory.createUploadMessage(message),
//         );
//       } catch (err) {
//         if (kDebugMode) {
//           print(err);
//         }
//       }
//     }
//   }
// }
}
