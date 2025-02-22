import 'package:chat_config/chat_constants.dart';
import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/api_service/auth/auth_api_service.dart';
import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../core/app_config/app_config_controller.dart';
import '../../../home/home_controller/views/home_view.dart';
import '../../auth_utils.dart';
import '../../waiting_list/views/waiting_list_page.dart';

class RegisterController implements BaseController {
  final AuthApiService authService;
  final ProfileApiService profileService;

  RegisterController(
    this.authService,
    this.profileService,
  );

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  Future<void> register(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    if (name.isEmpty) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).nameMustHaveValue,
        context: context,
      );
      return;
    }
    if (!EmailValidator.validate(email)) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).emailNotValid,
        context: context,
      );
      return;
    }
    final password = passwordController.text;
    final confirm = confirmController.text;

    if (password.isEmpty) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).passwordMustHaveValue,
        context: context,
      );
      return;
    }

    if (password != confirm) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).passwordNotMatch,
        context: context,
      );
      return;
    }
    if (_checkIfLoginNoAllowed()) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).loginNowAllowedNowPleaseTryAgainLater,
        context: context,
      );
      return;
    }

    await vSafeApiCall<MyProfile>(
      onLoading: () async {
        VAppAlert.showLoading(context: context);
      },
      onError: (exception, trace) {
        final errEnum = EnumToString.fromString(ApiI18nErrorRes.values, exception.toString());
        Navigator.of(context).pop();
        VAppAlert.showOkAlertDialog(
          context: context,
          title: S.of(context).error,
          content: AuthTrUtils.tr(errEnum) ?? exception.toString(),
        );
      },
      request: () async {
        final deviceHelper = DeviceInfoHelper();
        await authService.register(
          RegisterDto(
            email: email,
            method: RegisterMethod.email,
            fullName: name,
            pushKey: await (await VChatController.I.vChatConfig.currentPushProviderService)?.getToken(
              VPlatforms.isWeb ? ChatConstants.webVapidKey : null,
            ),
            deviceInfo: await deviceHelper.getDeviceMapInfo(),
            deviceId: await deviceHelper.getId(),
            language: VLanguageListener.I.appLocal.languageCode,
            platform: VPlatforms.currentPlatform,
            password: password,
          ),
        );
        return profileService.getMyProfile();
      },
      onSuccess: (response) async {
        final status = response.registerStatus;
        await ChatPreferences.setMap(SStorageKeys.myProfile.name, response.toMap());
        if (status == RegisterStatus.accepted) {
          await ChatPreferences.setBool(SStorageKeys.isLogin.name, true);
          _homeNav(context);
        } else {
          context.toPage(
            WaitingListPage(
              profile: response,
            ),
            withAnimation: true,
            removeAll: true,
          );
        }
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    confirmController.dispose();
    passwordController.dispose();
  }

  @override
  void onInit() {}

  void _homeNav(BuildContext context) {
    context.toPage(
      const HomeView(),
      withAnimation: true,
      removeAll: true,
    );
  }

  bool _checkIfLoginNoAllowed() {
    if (VPlatforms.isMobile && !VAppConfigController.appConfig.allowMobileLogin) {
      return true;
    }
    if (VPlatforms.isWeb && !VAppConfigController.appConfig.allowWebLogin) {
      return true;
    }
    if (VPlatforms.isDeskTop && !VAppConfigController.appConfig.allowDesktopLogin) {
      return true;
    }
    return false;
  }
}
