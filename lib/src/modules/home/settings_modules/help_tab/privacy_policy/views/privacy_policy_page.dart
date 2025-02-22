import 'package:chat_core/chat_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

import '../controllers/privacy_policy_controller.dart';
import '../states/privacy_policy_state.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final PrivacyPolicyController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).privacyPolicy),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ValueListenableBuilder<LoadingState<PrivacyPolicyState?>>(
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
    controller = PrivacyPolicyController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
