import 'package:chat_core/chat_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

import '../controllers/link_by_qr_code_controller.dart';
import '../states/link_by_qr_code_state.dart';

class LinkByQrCodePage extends StatefulWidget {
  const LinkByQrCodePage({super.key});

  @override
  State<LinkByQrCodePage> createState() => _LinkByQrCodePageState();
}

class _LinkByQrCodePageState extends State<LinkByQrCodePage> {
  late final LinkByQrCodeController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).linkByQrCode),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ValueListenableBuilder<LoadingState<LinkByQrCodeState?>>(
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
    controller = LinkByQrCodeController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
