import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../core/api_service/api_service.dart';
import '../../../home/home_controller/views/home_view.dart';
import '../../../splash/views/splash_view.dart';
import '../states/waiting_list_state.dart';

class WaitingListController extends SLoadingController<WaitingListState?> {
  final txtController = TextEditingController();

  WaitingListController() : super(SLoadingState(null));
  final _profileApi = GetIt.I.get<ProfileApiService>();

  @override
  void onClose() {
    txtController.dispose();
  }

  @override
  void onInit() {}

  Future<void> refreshProfile(BuildContext context) async {
    await vSafeApiCall<SMyProfile>(
      onError: (exception, trace) {
        VAppAlert.showErrorSnackBar(
          message: exception.toString(),
          context: context,
        );
      },
      request: () async {
        return _profileApi.getMyProfile();
      },
      onSuccess: (SMyProfile response) async {
        if (response.registerStatus == RegisterStatus.accepted) {
          VAppAlert.showSuccessSnackBar(
            message: S.of(context).congregationsYourAccountHasBeenAccepted,
            context: context,
          );
          await VAppPref.setMap(SStorageKeys.myProfile.name, response.toMap());
          await Future.delayed(const Duration(seconds: 2));
          context.toPage(
            const HomeView(),
            removeAll: true,
            withAnimation: true,
          );
        } else {
          VAppAlert.showSuccessSnackBar(
            message: S.of(context).yourAccountIsUnderReview,
            context: context,
          );
        }
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  void logout(BuildContext context) {
    vSafeApiCall(
      onLoading: () {
        VAppAlert.showLoading(context: context);
      },
      request: () async {
        await VChatController.I.profileApi.logout();
        AppAuth.setProfileNull();
        await VAppPref.clear();
      },
      onSuccess: (response) {
        VChatController.I.navigatorKey.currentContext!.toPage(
          const SplashView(),
          withAnimation: false,
          removeAll: true,
        );
        AppAuth.setProfileNull();
      },
      onError: (exception, trace) {
        context.pop();
        VAppAlert.showOkAlertDialog(
          context: context,
          title: S.of(context).error,
          content: exception,
        );
      },
    );
  }
}
