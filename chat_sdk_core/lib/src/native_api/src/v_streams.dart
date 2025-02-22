import 'package:chat_sdk_core/chat_sdk_core.dart';

class VStreams {
  final _emitter = VEventBusSingleton.vEventBus;

  Stream<VMessageEvents> get messageStream => _emitter.on<VMessageEvents>();

  Stream<VSocketStatusEvent> get socketStatusStream => _emitter.on<VSocketStatusEvent>();

  Stream<VTotalUnReadMessagesCount> get totalUnreadMessageCountStream => _emitter.on<VTotalUnReadMessagesCount>();

  Stream<VTotalUnReadRoomsCount> get totalUnreadRoomsCountStream => _emitter.on<VTotalUnReadRoomsCount>();

  Stream<VSocketIntervalEvent> get socketIntervalStream => _emitter.on<VSocketIntervalEvent>();

  Stream<VRoomEvents> get roomStream => _emitter.on<VRoomEvents>();

  Stream<VCallEvents> get callStream => _emitter.on<VCallEvents>();

  Stream<VOnNotificationsClickedEvent> get vOnNotificationsClickedStream => _emitter.on<VOnNotificationsClickedEvent>();

  Stream<VOnNewNotifications> get vOnNewNotificationStream => _emitter.on<VOnNewNotifications>();

  Stream<VOnUpdateNotificationsToken> get vOnUpdateNotificationsTokenStream =>
      _emitter.on<VOnUpdateNotificationsToken>();
}
