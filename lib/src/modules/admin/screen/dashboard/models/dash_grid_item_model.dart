import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';

class DashGridItemModel {
  final int value;
  final IconData iconData;
  final Widget? iconWidget;
  final String title;

  const DashGridItemModel({
    required this.value,
    required this.iconData,
    this.iconWidget,
    required this.title,
  });

  String get valueFormat {
    return value.numeral(digits: 2);
  }
}
