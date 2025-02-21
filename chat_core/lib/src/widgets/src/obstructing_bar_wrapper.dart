import 'package:flutter/cupertino.dart';

class ObstructingBarWrapper extends StatelessWidget implements ObstructingPreferredSizeWidget {
  const ObstructingBarWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  /// True if the navigation bar's background color has no transparency.
  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoDynamicColor.maybeResolve(null, context) ??
        CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kMinInteractiveDimensionCupertino);
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
