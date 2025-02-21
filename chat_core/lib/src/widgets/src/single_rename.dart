import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

class VSingleRename extends StatefulWidget {
  final String appbarTitle;
  final String subTitle;
  final String? oldValue;

  const VSingleRename({
    super.key,
    required this.appbarTitle,
    required this.subTitle,
    this.oldValue,
  });

  @override
  State<VSingleRename> createState() => _VSingleRenameState();
}

class _VSingleRenameState extends State<VSingleRename> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.oldValue != null) {
      controller.text = widget.oldValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: context.theme.cardColor,
        middle: widget.appbarTitle.h6.size(16).medium,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: S.of(context).ok.h6.size(16).medium,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  (widget.subTitle.isEmpty ? "None" : widget.subTitle)
                      .h6
                      .medium
                      .size(16)
                      .color(context.isDark ? Colors.white : Colors.black),
                  const SizedBox(
                    height: 12,
                  ),
                  STextFiled(
                    autocorrect: true,
                    inputType: TextInputType.text,
                    autofocus: true,
                    controller: controller,
                    textHint: widget.oldValue ?? "",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
