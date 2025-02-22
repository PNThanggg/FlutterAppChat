import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 90,
            width: 90,
          ),
          const SizedBox(
            height: 8,
          ),
          SConstants.appName.h4.bold.color(Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
