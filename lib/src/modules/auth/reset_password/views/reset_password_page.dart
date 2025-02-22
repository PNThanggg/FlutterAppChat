import 'package:chat_core/chat_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/widgets/wide_constraints.dart';
import '../../widgets/auth_header.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final ResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = ResetPasswordController(widget.email);
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: const Color.fromRGBO(
          114,
          178,
          238,
          1,
        ),
      ),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return WideConstraints(
          enable: !sizingInformation.isMobile,
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(S.of(context).resetPassword),
            ),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const AuthHeader(),
                    SizedBox(
                      height: context.height * .02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Pinput(
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            length: 6,
                            submittedPinTheme: submittedPinTheme,
                            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            controller: controller.codeController,
                            onCompleted: (pin) => debugPrint(pin),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          STextFiled(
                            autofocus: true,
                            controller: controller.newPasswordController,
                            textHint: S.of(context).newPassword,
                            prefix: const Icon(CupertinoIcons.lock_fill),
                            autocorrect: false,
                            obscureText: true,
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          STextFiled(
                            autofocus: true,
                            controller: controller.confirmPasswordController,
                            textHint: S.of(context).confirmPassword,
                            obscureText: true,
                            prefix: const Icon(CupertinoIcons.lock_fill),
                            autocorrect: false,
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SElevatedButton(
                            title: S.of(context).resetPassword,
                            onPress: () => controller.resetPassword(context),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
