import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textless/textless.dart';

class MessageTimeWidget extends StatelessWidget {
  final DateTime dateTime;
  final bool isMeSender;

  const MessageTimeWidget({
    super.key,
    required this.dateTime,
    required this.isMeSender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6),
      child: DateFormat.jm(Localizations.localeOf(context).languageCode).format(dateTime.toLocal()).text.size(12).color(
            isMeSender ? const Color.fromARGB(145, 185, 185, 185) : const Color.fromARGB(145, 159, 159, 159),
          ),
    );
  }
}
