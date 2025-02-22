import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageDownloaderWidget extends StatelessWidget {
  final VBaseMessage message;

  const MessageDownloaderWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        VDownloaderService.instance.addToMobileQueue(message);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color.fromARGB(125, 255, 255, 255),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.download,
              color: Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 131, 131, 131) : const Color.fromARGB(255, 255, 255, 255),
            )
          ],
        ),
      ),
    );
  }
}
