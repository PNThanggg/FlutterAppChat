import 'package:flutter/material.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

typedef MessageItemBuilderTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  VBaseMessage data,
);

class VMessageItemTheme {
  final Widget Function(
    BuildContext context,
    DateTime dateTime,
    String dateString,
  )? dateDivider;
  final MessageItemBuilderTypeDef? replyMessageItemBuilder;

  const VMessageItemTheme._({
    this.dateDivider,
    this.replyMessageItemBuilder,
  });

  const VMessageItemTheme.light({
    this.dateDivider,
    this.replyMessageItemBuilder,
  });

  const VMessageItemTheme.dark({
    this.dateDivider,
    this.replyMessageItemBuilder,
  });

  VMessageItemTheme copyWith({
    Widget Function(
      BuildContext context,
      DateTime dateTime,
      String dateString,
    )? dateDivider,
    MessageItemBuilderTypeDef? replyMessageItemBuilder,
  }) {
    return VMessageItemTheme._(
      dateDivider: dateDivider ?? this.dateDivider,
      replyMessageItemBuilder:
          replyMessageItemBuilder ?? this.replyMessageItemBuilder,
    );
  }
}
