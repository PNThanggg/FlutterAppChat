import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

class BanWidget extends StatelessWidget {
  final bool isMy;
  final VoidCallback onUnBan;
  final String youDontHaveAccess;

  const BanWidget({
    super.key,
    required this.isMy,
    required this.onUnBan,
    required this.youDontHaveAccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            youDontHaveAccess.text.color(Colors.white).black,
          ],
        ),
      ),
    );
  }
}
