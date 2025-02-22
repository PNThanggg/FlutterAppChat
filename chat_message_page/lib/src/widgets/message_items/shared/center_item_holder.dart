import 'package:flutter/material.dart';

class CenterItemHolder extends StatelessWidget {
  const CenterItemHolder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
