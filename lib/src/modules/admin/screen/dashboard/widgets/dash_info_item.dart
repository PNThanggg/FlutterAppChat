import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

import '../models/dash_grid_item_model.dart';

class DashInfoItem extends StatelessWidget {
  final DashGridItemModel dashGridItemModel;

  const DashInfoItem({
    super.key,
    required this.dashGridItemModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (dashGridItemModel.iconWidget != null)
            dashGridItemModel.iconWidget!
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: "${dashGridItemModel.title} ".text.medium,
                  ),
                ),
                Icon(
                  dashGridItemModel.iconData,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ],
            ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              dashGridItemModel.valueFormat.text.medium,
            ],
          ),
        ],
      ),
    );
  }
}
