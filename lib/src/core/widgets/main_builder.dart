import 'package:flutter/material.dart';

class MainBuilder extends StatelessWidget {
  final Widget? child;
  final ThemeMode themeMode;

  const MainBuilder({
    super.key,
    required this.child,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return child!;
  }
}
