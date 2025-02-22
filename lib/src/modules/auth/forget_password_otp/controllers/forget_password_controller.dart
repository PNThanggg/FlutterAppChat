import 'package:chat_core/chat_core.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/api_service/auth/auth_api_service.dart';
import '../../auth_utils.dart';
import '../../reset_password/views/reset_password_page.dart';

class ForgetPasswordController extends BaseController {
  final TextEditingController emailController = TextEditingController();
  final AuthApiService _authApiService = GetIt.I.get<AuthApiService>();

  @override
  void onClose() {
    emailController.dispose();
  }

  @override
  void onInit() {}

  Future<void> sendEmail(BuildContext context) async {
    await vSafeApiCall(
      onLoading: () {
        VAppAlert.showLoading(context: context);
      },
      request: () async {
        await _authApiService.sendResetPasswordEmailOtp(emailController.text);
      },
      onSuccess: (response) {
        context.pop();
        context.toPage(
          ResetPasswordPage(
            email: emailController.text,
          ),
        );
      },
      onError: (exception, trace) {
        context.pop();
        final errEnum = EnumToString.fromString(
          ApiI18nErrorRes.values,
          exception.toString(),
        );
        VAppAlert.showErrorSnackBar(
          message: AuthTrUtils.tr(errEnum) ?? exception.toString(),
          context: context,
        );
      },
    );
  }
}
