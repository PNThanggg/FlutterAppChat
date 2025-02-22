import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart' hide NoAnimationPageRoute;

import '../../../../core/app_config/app_config_controller.dart';
import 'no_animation_page_route.dart';

class WideMessagesNavigation extends StatelessWidget {
  WideMessagesNavigation({
    super.key,
  });

  final controller = GetIt.I.get<VAppConfigController>();

  static final navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      initialRoute: 'IdleMessagesRoute',
      onGenerateRoute: (settings) {
        return NoAnimationPageRoute(
          builder: (context) {
            return const IdleMessagesRoute();
          },
        );
      },
    );
  }
}

class IdleMessagesRoute extends StatelessWidget {
  const IdleMessagesRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        border: Border.all(color: Colors.transparent),
        backgroundColor: context.isDark ? const Color(0xff000814) : Colors.grey.shade100,
        middle: SConstants.appName.h6.size(20).bold.color(context.textTheme.bodyLarge!.color!),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: !context.isDark
                ? const AssetImage("assets/message/pattern_light.png")
                : const AssetImage("assets/message/pattern_dark.png"),
            repeat: ImageRepeat.repeat,
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.color,
            ),
          ),
        ),
        child: Center(
          child: Image.asset(
            "assets/logo.png",
            height: 150,
            width: 150,
          ),
        ),
      ),
    );
  }
}
