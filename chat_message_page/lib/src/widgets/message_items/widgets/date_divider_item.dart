import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDividerItem extends StatelessWidget {
  final DateTime dateTime;
  final String today;
  final String yesterday;

  const DateDividerItem({
    super.key,
    required this.dateTime,
    required this.today,
    required this.yesterday,
  });

  @override
  Widget build(BuildContext context) {
    var text = "";
    final now = DateTime.now().toLocal();
    final difference = now.difference(dateTime).inDays;
    if (difference == 0) {
      text = today;
    } else if (difference == 1) {
      text = yesterday;
    } else if (difference <= 7) {
      //will print the day name EX (sunday ,...)
      text = DateFormat.E(Localizations.localeOf(context).languageCode).format(dateTime);
    } else {
      //will print the time as (1/1/2000)
      text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(dateTime);
    }
    final method = context.vMessageTheme.vMessageItemTheme.dateDivider;
    if (method != null) {
      return context.vMessageTheme.vMessageItemTheme.dateDivider!(
        context,
        dateTime,
        text,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: text.text.color(Colors.white).size(12),
            ),
          ),
        ],
      ),
    );
  }
}
