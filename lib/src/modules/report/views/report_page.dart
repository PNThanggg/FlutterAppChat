import 'package:flutter/cupertino.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../choose_members/widgets/cupertino_checkbox_list_tile.dart';
import '../controllers/report_controller.dart';

class ReportPage extends StatefulWidget {
  final String userId;

  const ReportPage({super.key, required this.userId});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late final ReportController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: context.theme.canvasColor,
          middle: S.of(context).report.h6.size(16).medium,
          trailing: CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            onPressed: !controller.isSendReady ? null : () => controller.onReport(context),
            child: S.of(context).send.h6.size(16).medium,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CupertinoCheckboxListTile(
                    title: S.of(context).spamOrScamDescription.h6.size(16).maxLine(10),
                    value: controller.data.currentType == 1,
                    onChanged: (value) {
                      controller.onTypePress(value == true ? 1 : 0);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CupertinoCheckboxListTile(
                    title: S.of(context).harassmentOrBullyingDescription.h6.size(16).maxLine(10),
                    value: controller.data.currentType == 2,
                    onChanged: (value) {
                      controller.onTypePress(value == true ? 2 : 0);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CupertinoCheckboxListTile(
                    title: S.of(context).inappropriateContentDescription.h6.size(16).maxLine(10),
                    value: controller.data.currentType == 3,
                    onChanged: (value) {
                      controller.onTypePress(value == true ? 3 : 0);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CupertinoCheckboxListTile(
                    title: S.of(context).otherCategoryDescription.h6.size(16).maxLine(10),
                    value: controller.data.currentType == 4,
                    onChanged: (value) {
                      controller.onTypePress(value == true ? 4 : 0);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CupertinoCheckboxListTile(
                    title: S.of(context).blockUser.h6.size(16).maxLine(10),
                    value: controller.data.blockThisUser,
                    onChanged: (value) {
                      controller.onBlockPress(value ?? false);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  STextFiled(
                    maxLines: 10,
                    minLines: 5,
                    controller: controller.txtController,
                    textHint: S.of(context).explainWhatHappens,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = ReportController(widget.userId);
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
