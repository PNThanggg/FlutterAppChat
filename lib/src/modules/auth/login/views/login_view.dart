import 'package:chat_core/chat_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/api_service/auth/auth_api_service.dart';
import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../core/widgets/wide_constraints.dart';
import '../../forget_password_otp/views/forget_password_page.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/auth_input_text_view.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginController(
      GetIt.I.get<AuthApiService>(),
      GetIt.I.get<ProfileApiService>(),
    );
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => WideConstraints(
        enable: !sizingInformation.isMobile,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: ScrollConfiguration(
              behavior: DisableGlowBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AuthHeader(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AuthInputTextView(
                            controller: controller.emailController,
                            labelText: S.of(context).email,
                            autocorrect: false,
                            inputType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AuthInputTextView(
                            autocorrect: false,
                            controller: controller.passwordController,
                            labelText: S.of(context).password,
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              context.toPage(const ForgetPasswordPage());
                            },
                            child: S.of(context).forgetPassword.text.color(Colors.blue).medium,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SElevatedButton(
                            title: S.of(context).login,
                            onPress: () => controller.login(context),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              S.of(context).needNewAccount.text,
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: S.of(context).register.text.color(Colors.blue).medium,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
