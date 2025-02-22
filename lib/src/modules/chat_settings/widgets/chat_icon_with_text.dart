import 'package:flutter/cupertino.dart';
import 'package:super_up_core/super_up_core.dart';

class ChatIconWithText extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;

  const ChatIconWithText({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          Icon(
            icon,
            color: CupertinoColors.systemGreen,
            size: 30,
          ),
          const SizedBox(
            height: 10,
          ),
          title.text
        ],
      ),
    );
  }
}
