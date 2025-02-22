import 'dart:async';

import 'package:chat_core/chat_core.dart';
import 'package:chat_room_page/chat_room_page.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';

import '../../shared/stream_mixin.dart';

///this class is the controller for the room page you should initialize it in the init method of the page
///and don't forget to dispose it in the dispose method of the page
class VRoomController with StreamMix {
  final VNativeApi _nativeApi = VChatController.I.nativeApi;
  final _events = VEventBusSingleton.vEventBus;
  bool isFetchingRooms = false;

  RoomItemController? _roomItemController;
  BuildContext? _context;
  late final RoomStateController roomState;

  final RoomProvider _roomProvider = RoomProvider();

  VRoomController() {
    _initStreams();
    roomState = RoomStateController(
      _roomProvider,
    );
  }

  void init(BuildContext context, VRoomLanguage language) {
    _context ??= context;
    _roomItemController ??= RoomItemController(_roomProvider, _context!);
    _getRoomsFromLocal();
    _getRoomsFromApi();
    _manageDeletedRooms();
  }

  void sortRoomsBy(VRoomType? type) {
    if (type == null) {
      _getRoomsFromLocal();
      return;
    }
    roomState.sortRoomsBy(type);
  }

  bool isSortByUnreadCount = false;

  void sortRoomsByUnReadCount() {
    if (isSortByUnreadCount) {
      _getRoomsFromLocal();
    } else {
      roomState.sortRoomsByUnreadCount();
    }
    isSortByUnreadCount = !isSortByUnreadCount;
  }

  Future<void> _getRoomsFromLocal() async {
    await vSafeApiCall<VPaginationModel<VRoom>>(
      request: () async {
        return _roomProvider.getLocalRooms();
      },
      onSuccess: (response) {
        roomState.insertAll(response);
      },
    );
  }

  String? selectedRoomId;

  void setRoomSelected(String roomId) {
    selectedRoomId = roomId;
    roomState.setRoomSelected(roomId);
  }

  void onRoomItemLongPress(VRoom room, BuildContext context) async {
    switch (room.roomType) {
      case VRoomType.s:
        await _roomItemController?.openForSingle(
          room,
        );
        break;
      case VRoomType.g:
        await _roomItemController?.openForGroup(
          room,
        );
        break;
      case VRoomType.b:
        await _roomItemController?.openForBroadcast(
          room,
        );
        break;
      case VRoomType.o:
        await _roomItemController?.openForOrder(
          room,
        );
        break;
    }
  }

  Future _getRoomsFromApi() async {
    if (isFetchingRooms) {
      return;
    }
    isFetchingRooms = true;
    await VChatController.I.nativeApi.remote.socketIo.socketCompleter.future;
    await vSafeApiCall<VPaginationModel<VRoom>>(
      request: () async {
        return _roomProvider.getApiRooms(
          const VRoomsDto(),
        );
      },
      onSuccess: (response) {
        roomState.updateCacheStateForChatRooms(response);
      },
    );
    isFetchingRooms = false;
  }

  void dispose() {
    roomState.close();
    closeStreamMix();
  }

  void onRoomItemPress(VRoom room, BuildContext context) {
    VChatController.I.vNavigator.messageNavigator.toMessagePage(context, room);
  }

  Future<bool> onLoadMore() {
    return roomState.onLoadMore();
  }

  bool get getIsFinishLoadMore {
    return roomState.isFinishLoadMore;
  }

  void _initStreams() {
    streamsMix.addAll([
      ///socket events
      _events.on<VSocketStatusEvent>().listen(_handleSocketConnectionStatus),
      _events.on<VSocketIntervalEvent>().listen(_handleSocketIntervalFire),

      ///room events
      _events.on<VUpdateRoomImageEvent>().listen(_handleUpdateRoomImage),
      _events.on<VUpdateRoomNameEvent>().listen(_handleUpdateRoomTitle),
      _events.on<VUpdateRoomTypingEvent>().listen(_handleRoomTyping),
      _events.on<VUpdateRoomUnReadCountByOneEvent>().listen(_handleCounterByOne),
      _events.on<VUpdateRoomMuteEvent>().listen(_handleMute),
      _events.on<VUpdateRoomMemberMention>().listen(_handleMention),
      _events.on<VDeleteRoomEvent>().listen(_handleDeleteRoom),
      _events.on<VInsertRoomEvent>().listen(_handleInsertRoom),
      _events.on<VUpdateRoomUnReadCountToZeroEvent>().listen(_handleResetCounter),
      _events.on<VUpdateLocalRoomNickNameEvent>().listen(_handleUpdateNickName),
      _events.on<VRoomOfflineEvent>().listen(_handleOnOffRoom),
      _events.on<VRoomOnlineEvent>().listen(_handleOnOnlineRoom),

      ///messages events
      _events.on<VInsertMessageEvent>().listen(_handleInsertMessage),
      _events.on<VDeleteMessageEvent>().listen(_handleDeleteMessage),
      _events.on<VUpdateMessageDeliverEvent>().listen(_handleDeliverMessages),
      _events.on<VUpdateMessageSeenEvent>().listen(_handleSeenMessages),
      _events.on<VUpdateMessageEvent>().listen(_handleUpdateMessages),
      _events.on<VUpdateRoomOneSeenEvent>().listen(_handleUpdateOneSeen),
      _events.on<VUpdateMessageAllDeletedEvent>().listen(_handleAllDeleteMessage),
      _events.on<VUpdateMessageStatusEvent>().listen(_handleUpdateMessageStatus),
    ]);
  }

  void _handleSocketConnectionStatus(VSocketStatusEvent event) {
    if (event.isConnected && event.connectTimes != 1) {
      _getRoomsFromApi();
    }
  }

  void _handleSocketIntervalFire(VSocketIntervalEvent event) {
    ///emit to update online and offline
    final ids = roomState.stateRooms
        .where(
          (element) => element.roomType.isSingleOrOrder,
        )
        .toList();
    _nativeApi.remote.socketIo.emitGetMyOnline(
      ids
          .map(
            (e) => VOnlineOfflineModel(
              peerId: e.peerId!,
              isOnline: false,
              roomId: e.id,
            ).toMap(),
          )
          .toList(),
    );
  }

  void _handleUpdateRoomImage(VUpdateRoomImageEvent event) {
    roomState.updateImage(event.roomId, event.image);
  }

  void _handleUpdateRoomTitle(VUpdateRoomNameEvent event) {
    roomState.updateTitle(event.roomId, event.name);
  }

  void _handleRoomTyping(VUpdateRoomTypingEvent event) {
    roomState.updateTyping(event.roomId, event.typingModel);
  }

  void _handleUpdateNickName(VUpdateLocalRoomNickNameEvent event) {
    roomState.updateNickName(event);
  }

  void _handleCounterByOne(VUpdateRoomUnReadCountByOneEvent event) {
    roomState.updateCounterByOne(event.roomId);
  }

  void _handleMute(VUpdateRoomMuteEvent event) {
    roomState.updateMute(event.roomId, event.isMuted);
  }

  void _handleDeleteRoom(VDeleteRoomEvent event) {
    roomState.deleteRoom(event.roomId);
  }

  void _handleInsertRoom(VInsertRoomEvent event) {
    roomState.insertRoom(event.room);
  }

  void _handleResetCounter(VUpdateRoomUnReadCountToZeroEvent event) {
    roomState.resetRoomCounter(event.roomId);
  }

  void _handleOnOffRoom(VRoomOfflineEvent event) {
    roomState.updateOffline(event.roomId);
  }

  void _handleOnOnlineRoom(VRoomOnlineEvent event) {
    roomState.updateOnline(event.roomId);
  }

  void _handleInsertMessage(VInsertMessageEvent event) {
    roomState.insertRoomLastMessage(event);
  }

  void _handleDeleteMessage(VDeleteMessageEvent event) {
    roomState.deleteRoomLastMessage(event);
  }

  void _handleDeliverMessages(VUpdateMessageDeliverEvent event) {
    roomState.deliverRoomLastMessage(event);
  }

  void _handleSeenMessages(VUpdateMessageSeenEvent event) {
    roomState.seenRoomLastMessage(event);
  }

  void _handleUpdateMessages(VUpdateMessageEvent event) {
    roomState.updateRoomLastMessage(event);
  }

  void _handleUpdateMessageStatus(VUpdateMessageStatusEvent event) {
    roomState.updateRoomLastMessageStatus(event);
  }

  void _handleAllDeleteMessage(VUpdateMessageAllDeletedEvent event) {
    roomState.updateRoomLastMessageAllDelete(event);
  }

  void _manageDeletedRooms() async {
    await vSafeApiCall<VPaginationModel<VRoom>>(
      request: () async {
        return _roomProvider.getApiRooms(
          const VRoomsDto(deletedOnly: true),
        );
      },
      onSuccess: (response) {
        for (final room in response.data) {
          unawaited(VChatController.I.nativeApi.local.room.deleteRoom(room.id));
        }
      },
    );
  }

  void _handleMention(VUpdateRoomMemberMention event) {
    roomState.updateRoomMention(event);
  }

  void _handleUpdateOneSeen(VUpdateRoomOneSeenEvent event) {
    roomState.updateOneSeen(event);
  }
}
