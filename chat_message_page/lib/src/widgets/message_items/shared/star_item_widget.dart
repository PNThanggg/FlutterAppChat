import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class StarItemWidget extends StatelessWidget {
  final bool isStar;

  const StarItemWidget({
    super.key,
    required this.isStar,
  });

  @override
  Widget build(BuildContext context) {
    if (!isStar) return const SizedBox.shrink();
    return const Icon(
      CupertinoIcons.star_fill,
      color: AppColors.primaryColor,
      size: 15,
    );
  }
}
