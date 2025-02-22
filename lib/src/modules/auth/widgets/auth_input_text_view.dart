import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class AuthInputTextView extends StatefulWidget {
  final String? hintText, labelText;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool obscureText;
  final bool autofocus;
  final int? maxLength;
  final int maxLines;
  final int? minLines;
  final bool autocorrect;

  final ValueChanged<String>? onChanged;

  const AuthInputTextView({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.inputType,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.autofocus = false,
    this.autocorrect = true,
    this.obscureText = false,
  });

  @override
  State<AuthInputTextView> createState() => _AuthInputTextViewState();
}

class _AuthInputTextViewState extends State<AuthInputTextView> {
  FocusNode focusNode = FocusNode();

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  Color _color(BuildContext context) => context.isDark ? Colors.white24 : Theme.of(context).primaryColor;

  TextStyle _floatingLabelStyle(BuildContext context) => const TextStyle(
        fontSize: 20,
        color: Colors.blueAccent,
        fontWeight: FontWeight.w500,
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {});
      },
      minLines: widget.minLines,
      autocorrect: widget.autocorrect,
      autofocus: widget.autofocus,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: _color(context),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        suffixIcon: _controller.text.isEmpty
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 16,
                ),
                onPressed: () {
                  setState(() {
                    _controller.clear();
                  });
                },
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 32,
          minWidth: 32,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: _color(context),
          ),
        ),
        floatingLabelStyle: _floatingLabelStyle(context),
        // floatingLabelStyle: _controller.text.isEmpty
        //     ? focusNode.hasFocus
        //         ? _floatingLabelStyle(context)
        //         : null
        //     : _floatingLabelStyle(context),
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        filled: false,
      ),
    );
  }
}
