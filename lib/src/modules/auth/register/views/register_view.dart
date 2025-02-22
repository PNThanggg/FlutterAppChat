import 'package:chat_core/chat_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/api_service/auth/auth_api_service.dart';
import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../core/widgets/wide_constraints.dart';
import '../../login/views/login_view.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/auth_input_text_view.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final RegisterController controller;

  @override
  void initState() {
    super.initState();
    controller = RegisterController(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const AuthHeader(),
                    SizedBox(
                      height: context.height * .02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        children: [
                          AuthInputTextView(
                            autocorrect: false,
                            labelText: S.of(context).name,
                            controller: controller.nameController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AuthInputTextView(
                            autocorrect: false,
                            controller: controller.emailController,
                            labelText: S.of(context).email,
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
                            height: 20,
                          ),
                          AuthInputTextView(
                            autocorrect: false,
                            controller: controller.confirmController,
                            labelText: S.of(context).confirmPassword,
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SElevatedButton(
                            title: S.of(context).register,
                            onPress: () => controller.register(context),
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              S.of(context).orLoginWith.s2.medium.color(Colors.grey),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              S.of(context).alreadyHaveAnAccount.text,
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.toPage(const LoginView());
                                },
                                child: S.of(context).login.text.medium.color(Colors.blue),
                              )
                            ],
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
      ),
    );
  }
}
