import 'dart:async';

import 'package:chat_sdk_core/chat_sdk_core.dart';

mixin VSocketStatusStream {
  StreamSubscription<VSocketStatusEvent>? _socketStatusStream;

  void initSocketStatusStream(Stream<VSocketStatusEvent> stream) {
    _socketStatusStream = stream.listen((event) {
      if (event.isConnected) {
        onSocketConnected();
      } else {
        onSocketDisconnect();
      }
    });
  }

  void closeSocketStatusStream() {
    _socketStatusStream?.cancel();
  }

  void onSocketConnected() {}

  void onSocketDisconnect() {}
}

mixin VSocketIntervalStream {
  late final StreamSubscription<VSocketIntervalEvent> _socketIntervalStatusStream;

  void initSocketIntervalStream(Stream<VSocketIntervalEvent> stream) {
    _socketIntervalStatusStream = stream.listen((event) {
      onIntervalFire();
    });
  }

  void closeSocketIntervalStream() {
    _socketIntervalStatusStream.cancel();
  }

  void onIntervalFire();
}
