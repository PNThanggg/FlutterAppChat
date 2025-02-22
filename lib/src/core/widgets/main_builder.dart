import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';

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
    final sizer = GetIt.I.get<AppSizeHelper>();
    if (!sizer.isWide(context)) {
      return AndroidStatusBarColor(
        themeMode: themeMode,
        child: PointerDownUnFocus(
          child: child!,
        ),
      );
    }
    return child!;
  }
}
