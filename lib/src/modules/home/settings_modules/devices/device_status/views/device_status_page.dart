import 'package:chat_core/chat_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

import '../controllers/device_status_controller.dart';
import '../states/device_status_state.dart';

class DeviceStatusPage extends StatefulWidget {
  const DeviceStatusPage({super.key});

  @override
  State<DeviceStatusPage> createState() => _DeviceStatusPageState();
}

class _DeviceStatusPageState extends State<DeviceStatusPage> {
  late final DeviceStatusController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).deviceStatus),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ValueListenableBuilder<LoadingState<DeviceStatusState?>>(
                valueListenable: controller,
                builder: (_, value, ___) => VAsyncWidgetsBuilder(
                  loadingState: value.loadingState,
                  onRefresh: controller.getData,
                  successWidget: () {
                    return Text(S.of(context).success);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = DeviceStatusController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
