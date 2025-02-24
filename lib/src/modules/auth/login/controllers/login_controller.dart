import 'package:chat_config/chat_constants.dart';
import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/api_service/auth/auth_api_service.dart';
import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../core/app_config/app_config_controller.dart';
import '../../../admin/admin.dart';
import '../../../app/controller/app_controller.dart';
import '../../../home/home_controller/views/home_view.dart';
import '../../auth_utils.dart';
import '../../waiting_list/views/waiting_list_page.dart';

class LoginController implements BaseController {
  final AuthApiService authService;
  final ProfileApiService profileService;

  LoginController(
    this.authService,
    this.profileService,
  );

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  onInit() {
    if (kDebugMode) {
      emailController.text = "user1@gmail.com";
      passwordController.text = "12345678";
    }
  }

  void _homeNav(BuildContext context) {
    context.toPage(
      const HomeView(),
      removeAll: true,
      withAnimation: true,
    );
  }

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();

    if (!EmailValidator.validate(email)) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).emailNotValid,
        context: context,
      );
      return;
    }

    final password = passwordController.text;
    if (password.isEmpty) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).passwordMustHaveValue,
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
        if (kDebugMode) {
          print(trace);
        }
        Navigator.of(context).pop();
        final errEnum = EnumToString.fromString(
          ApiI18nErrorRes.values,
          exception.toString(),
        );
        VAppAlert.showOkAlertDialog(
          context: context,
          title: S.of(context).error,
          content: AuthTrUtils.tr(errEnum) ?? exception.toString(),
        );
      },
      request: () async {
        final deviceHelper = DeviceInfoHelper();

        LoginDto loginDto = LoginDto(
          email: email,
          method: RegisterMethod.email,
          pushKey: await (await VChatController.I.vChatConfig.currentPushProviderService)?.getToken(
            VPlatforms.isWeb ? ChatConstants.webVapidKey : null,
          ),
          deviceInfo: await deviceHelper.getDeviceMapInfo(),
          deviceId: await deviceHelper.getId(),
          language: VLanguageListener.I.appLocal.languageCode,
          platform: VPlatforms.currentPlatform,
          password: password,
        );

        await authService.login(loginDto);

        return profileService.getMyProfile();
      },
      onSuccess: (response) async {
        final status = response.registerStatus;

        if (kDebugMode) {
          _setIsAdmin(response);
        } else {
          if (VPlatforms.isMobile) {
            _setIsAdmin(response);
          }
        }

        await ChatPreferences.setHashedString(
          SStorageKeys.adminAccessPassword.name,
          "adminsieunhancuongphong",
        );

        if (GetIt.I.get<AppController>().isAdmin) {
          final SAdminApiService vAdminApiService = GetIt.I.get<SAdminApiService>();
          await vAdminApiService.login();
        }

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

  void _setIsAdmin(MyProfile value) {
    if (value.roles.contains(UserRole.admin)) {
      GetIt.I.get<AppController>().updateAdmin();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
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
