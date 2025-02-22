import 'package:flutter/material.dart';
import 'package:chat_input_ui/src/models/models.dart';

class MessageRecordBtn extends StatelessWidget {
  final VoidCallback onRecordClick;

  const MessageRecordBtn({
    super.key,
    required this.onRecordClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRecordClick,
      child: context.vInputTheme.recordBtn,
    );
  }
}
