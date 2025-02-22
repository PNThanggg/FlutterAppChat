import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/api_service/api_service.dart';
import '../../../home/home_controller/views/home_view.dart';
import '../../../splash/views/splash_view.dart';
import '../states/waiting_list_state.dart';

class WaitingListController extends SLoadingController<WaitingListState?> {
  final txtController = TextEditingController();

  WaitingListController()
      : super(
          LoadingState(null),
        );

  final _profileApi = GetIt.I.get<ProfileApiService>();

  @override
  void onClose() {
    txtController.dispose();
  }

  @override
  void onInit() {}

  Future<void> refreshProfile(BuildContext context) async {
    await vSafeApiCall<MyProfile>(
      onError: (exception, trace) {
        VAppAlert.showErrorSnackBar(
          message: exception.toString(),
          context: context,
        );
      },
      request: () async {
        return _profileApi.getMyProfile();
      },
      onSuccess: (MyProfile response) async {
        if (response.registerStatus == RegisterStatus.accepted) {
          VAppAlert.showSuccessSnackBar(
            message: S.of(context).congregationsYourAccountHasBeenAccepted,
            context: context,
          );
          await ChatPreferences.setMap(
            SStorageKeys.myProfile.name,
            response.toMap(),
          );
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
        await ChatPreferences.clear();
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
