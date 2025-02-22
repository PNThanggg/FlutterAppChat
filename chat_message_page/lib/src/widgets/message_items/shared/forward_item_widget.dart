import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForwardItemWidget extends StatelessWidget {
  final bool isFroward;

  const ForwardItemWidget({
    super.key,
    required this.isFroward,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFroward) {
      return const SizedBox.shrink();
    }

    return const Icon(
      CupertinoIcons.arrow_turn_up_right,
      color: Colors.grey,
      size: 15,
    );
  }
}
