import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

class FreeChatTab extends StatefulWidget {
  const FreeChatTab({super.key});

  @override
  State<FreeChatTab> createState() => _FreeChatTabState();
}

class _FreeChatTabState extends State<FreeChatTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Free Chat",
        style: context.textTheme.bodyMedium?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ),
      ),
    );
  }
}
