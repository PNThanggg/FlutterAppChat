import 'package:flutter/material.dart';

import '../models/dash_grid_item_model.dart';
import 'dash_info_item.dart';

class AnimatedItemWidget extends StatelessWidget {
  const AnimatedItemWidget({
    super.key,
    required this.index,
    required this.animation,
    required this.data,
  });

  final int index;
  final Animation<double> animation;
  final List<DashGridItemModel> data;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      // And slide transition
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.1),
          end: Offset.zero,
        ).animate(animation),
        // Paste you Widget
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: DashInfoItem(
            dashGridItemModel: data[index],
          ),
        ),
      ),
    );
  }
}
