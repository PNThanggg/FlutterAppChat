import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    this.width,
    this.height,
    this.label,
    this.value,
    this.iconData,
    this.cardColor,
  });

  final double? width;
  final double? height;
  final String? label;
  final String? value;
  final IconData? iconData;
  final Color? cardColor;

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration({
      double? radius,
      Color? color,
      Color bgColor = Colors.white,
      bool showShadow = false,
    }) {
      return BoxDecoration(
        color: bgColor,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: const Color(0xfff1f4fb).withOpacity(0.4),
                  blurRadius: 0.5,
                  spreadRadius: 1,
                ),
              ]
            : null,
        border: showShadow
            ? Border.all(
                color: const Color(0xFFF1F4FB).withOpacity(0.99),
                style: BorderStyle.solid,
                width: 0,
              )
            : Border.all(
                color: color ?? const Color(0xFFF1F4FB).withOpacity(0.9),
                style: BorderStyle.solid,
                width: 1.2,
              ),
        borderRadius: BorderRadius.all(
          Radius.circular(radius ?? 8),
        ),
      );
    }

    return Container(
      width: width ?? 150,
      decoration: boxDecoration(
        showShadow: false,
        radius: 10,
        bgColor: cardColor ?? const Color(0xFFF29B38),
        color: cardColor ?? Colors.black12,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: (label ?? 'Users').h6.medium.size(16).color(Colors.white).alignStart,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  iconData ?? Icons.person,
                  size: 20,
                  color: Colors.white,
                )
              ],
            ),
          ),
          SizedBox(height: height ?? 16),
          (value ?? '00').h6.medium.size(20).color(Colors.white),
        ],
      ),
    );
  }
}
