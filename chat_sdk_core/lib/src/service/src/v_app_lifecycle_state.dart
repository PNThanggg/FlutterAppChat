import 'dart:async';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class VAppLifecycleState {
  static bool isAppActive = false;

  // final _log = Logger('VAppLifecycleState');
  Timer? _timer;

  VAppLifecycleState() {
    if (!VPlatforms.isMobile) return;
    FGBGEvents.stream.listen((event) {
      switch (event) {
        case FGBGType.foreground:
          _timer?.cancel();
          VEventBusSingleton.vEventBus.fire(const VAppLifeCycle(isGoBackground: false));

          ///start connect
          if (!SocketController.instance.isSocketConnected) {
            SocketController.instance.connect();
          }
        case FGBGType.background:
          _timer?.cancel();
          _timer = Timer(const Duration(seconds: 5), () {
            VEventBusSingleton.vEventBus.fire(
              const VAppLifeCycle(
                isGoBackground: true,
              ),
            );
            SocketController.instance.disconnect();
          });
      }
    });
  }
}
