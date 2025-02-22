import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../../core/widgets/wide_constraints.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/auth_input_text_view.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late final ForgetPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return WideConstraints(
          enable: !sizingInformation.isMobile,
          child: Scaffold(
            body: SafeArea(
              bottom: false,
              child: ScrollConfiguration(
                behavior: DisableGlowBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: IconButton(
                                onPressed: context.pop,
                                icon: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 24,
                                ),
                              ),
                            ),
                            Expanded(
                              child: S.of(context).forgetPassword.b1.medium.color(Colors.black).alignCenter,
                            ),
                            const SizedBox(
                              width: 40,
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      const AuthHeader(),
                      SizedBox(
                        height: context.height * .02,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AuthInputTextView(
                              autofocus: true,
                              controller: controller.emailController,
                              labelText: S.of(context).email,
                              autocorrect: false,
                              inputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SElevatedButton(
                              title: S.of(context).sendCodeToMyEmail,
                              onPress: () => controller.sendEmail(context),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    controller = ForgetPasswordController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
