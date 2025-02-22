import 'package:flutter/material.dart';
import 'package:chat_core/chat_core.dart';

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bkColor;
  final VoidCallback onTap;

  const ModalTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bkColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      onTap: onTap,
      leading: Container(
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: bkColor,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
      ),
      subtitle: subtitle.h6.size(14).color(Colors.grey),
      title: title.h6.bold.size(18),
    );
  }
}
