import 'package:email_validator/email_validator.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' hide DeviceInfoHelper;
import 'package:v_platform/v_platform.dart';

import '../../../../core/api_service/auth/auth_api_service.dart';
import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../core/app_config/app_config_controller.dart';
import '../../../admin/admin.dart';
import '../../../app/controller/app_controller.dart';
import '../../../home/home_controller/views/home_view.dart';
import '../../auth_utils.dart';
import '../../waiting_list/views/waiting_list_page.dart';

class LoginController implements SBaseController {
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

    await vSafeApiCall<SMyProfile>(
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
            VPlatforms.isWeb ? SConstants.webVapidKey : null,
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

        await VAppPref.setHashedString(
          SStorageKeys.adminAccessPassword.name,
          "adminsieunhancuongphong",
        );

        if (GetIt.I.get<AppController>().isAdmin) {
          final SAdminApiService vAdminApiService = GetIt.I.get<SAdminApiService>();
          await vAdminApiService.login();
        }

        await VAppPref.setMap(SStorageKeys.myProfile.name, response.toMap());
        if (status == RegisterStatus.accepted) {
          await VAppPref.setBool(SStorageKeys.isLogin.name, true);
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

  void _setIsAdmin(SMyProfile value) {
    if (value.roles.contains(UserRoles.admin)) {
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
