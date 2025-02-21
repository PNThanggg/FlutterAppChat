import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class STextFiled extends StatelessWidget {
  final String textHint;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool obscureText;
  final bool autofocus;
  final int? maxLength;
  final int maxLines;
  final int? minLines;
  final bool autocorrect;
  final Widget? prefix;

  final ValueChanged<String>? onChanged;

  const STextFiled({
    super.key,
    required this.textHint,
    this.controller,
    this.inputType,
    this.prefix,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.autofocus = false,
    this.autocorrect = true,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      onChanged: onChanged,
      minLines: minLines,
      autocorrect: autocorrect,
      placeholder: textHint,
      autofocus: autofocus,
      style: context.textTheme.bodyLarge,
      prefix: Container(
        padding: const EdgeInsets.only(
          left: 4,
        ),
        child: prefix ?? const SizedBox(),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: context.isDark ? const Color(0xff363434) : Colors.grey.shade300,
      ),
    );
  }
}
