import 'dart:async';

import 'package:event_bus_plus/res/event_bus.dart';

/// vEventBus is a singleton instance of [EventBus] for v chat service
abstract class VEventBusSingleton {
  static EventBus vEventBus = EventBus();
}

final chatInfoSearchStream = StreamController<bool>.broadcast();
