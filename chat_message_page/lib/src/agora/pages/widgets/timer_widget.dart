import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:super_up_core/super_up_core.dart';

class TimerWidget extends StatelessWidget {
  final StopWatchTimer stopWatchTimer;

  const TimerWidget({
    super.key,
    required this.stopWatchTimer,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: stopWatchTimer.rawTime,
      initialData: 0,
      builder: (context, snap) {
        final value = snap.data;
        final displayTime = StopWatchTimer.getDisplayTime(
          value!,
          hours: true,
          minute: true,
          second: true,
          milliSecond: false,
        );

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: displayTime.text.size(30).bold.color(Colors.white),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
