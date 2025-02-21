import 'package:flutter/material.dart';
import 'package:super_up_core/src/v_chat/src/extension.dart';
import 'package:textless/textless.dart';

class CustomListTile extends StatelessWidget {
  final Widget leading;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final GestureTapCallback? onTap;
  final EdgeInsets? padding;

  const CustomListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    leading,
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          title.h6.maxLine(1).overflowEllipsis.size(16),
                          SizedBox(height: subtitle != null ? 2 : 0),
                          subtitle?.h6.size(12).color(Theme.of(context).primaryColor) ??
                              const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing ?? const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final Widget leading;
  final Widget? trailing;
  final String title;
  final Widget? subtitle;
  final GestureTapCallback? onTap;
  final EdgeInsets? padding;

  const ChatListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              leading,
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   title,
                    //   maxLines: 1,
                    //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w700,
                    //         fontStyle: FontStyle.normal,
                    //         letterSpacing: -0.4,
                    //         color: Theme.of(context).textTheme.bodyLarge!.color,
                    //       ),
                    // ),
                    title.h6.maxLine(1).overflowEllipsis.size(16).color(context.textTheme.bodyLarge!.color!).semiBold,
                    SizedBox(height: subtitle != null ? 1 : 0),
                    subtitle ?? const SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.more_horiz_rounded,
                  size: 24,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
