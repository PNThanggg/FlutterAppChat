import 'package:flutter/material.dart';

class WideConstraints extends StatelessWidget {
  final Widget child;
  final bool enable;

  const WideConstraints({
    super.key,
    required this.child,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enable) {
      return child;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 1000,
          ),
          child: child,
        ),
      ),
    );
  }
}
