import 'package:flutter/material.dart';

class MessageBroadcastWidget extends StatelessWidget {
  final bool isFromBroadcast;

  const MessageBroadcastWidget({
    super.key,
    required this.isFromBroadcast,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFromBroadcast) {
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.only(right: 4),
      child: Icon(
        Icons.campaign_outlined,
        size: 16,
      ),
    );
  }
}
