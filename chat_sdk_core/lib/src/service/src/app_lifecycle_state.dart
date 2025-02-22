import 'dart:async';

import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class VAppLifecycleState {
  static bool isAppActive = false;

  Timer? _timer;

  VAppLifecycleState() {
    if (!VPlatforms.isMobile) return;
    FGBGEvents.instance.stream.listen((event) {
      switch (event) {
        case FGBGType.foreground:
          _timer?.cancel();
          VEventBusSingleton.vEventBus.fire(
            const VAppLifeCycle(isGoBackground: false),
          );

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
