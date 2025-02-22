import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late final SplashController controller;

  @override
  void initState() {
    super.initState();
    controller = SplashController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/logo.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SConstants.appName.h6.semiBold.size(24).color(Colors.black)
                ],
              ),
              Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      return controller.version.text.medium.size(14).color(Colors.black);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
