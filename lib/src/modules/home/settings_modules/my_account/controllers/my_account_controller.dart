import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_shared_page/states.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../splash/views/splash_view.dart';
import '../states/my_account_state.dart';
import '../views/sheet_for_update_password.dart';

class MyAccountController extends SLoadingController<MyAccountState?> {
  final ProfileApiService profileApiService;

  MyAccountController(this.profileApiService)
      : super(
          LoadingState(null),
        );

  @override
  void onClose() {}

  @override
  void onInit() {}

  void updateUserImage(BuildContext context) async {
    final image = await VAppPick.getCroppedImage();
    if (image == null) return;
    vSafeApiCall<String>(
      onLoading: () {
        // VAppAlert.showLoading(context: context);
      },
      request: () async {
        return await profileApiService.updateImage(image);
      },
      onSuccess: (response) async {
        // final file = VPlatformFile.fromUrl(url: response);
        final newProfile = AppAuth.myProfile.copyWith(
          baseUser: AppAuth.myProfile.baseUser.copyWith(userImage: response),
        );
        await ChatPreferences.setMap(SStorageKeys.myProfile.name, newProfile.toMap());
        AppAuth.setProfileNull();
        update();
        // context.pop();
      },
    );
  }

  void updateUserName(BuildContext context) async {
    final newName = await context.toPage(
      VSingleRename(
        appbarTitle: S.of(context).updateYourName,
        subTitle: AppAuth.myProfile.baseUser.fullName,
      ),
      withAnimation: false,
    );
    if (newName == null || newName.toString().isEmpty) return;
    vSafeApiCall<String>(
      onLoading: () {
        //VAppAlert.showLoading(context: context);
      },
      request: () async {
        await profileApiService.updateUserName(newName);
        return newName;
      },
      onSuccess: (response) async {
        final newProfile = AppAuth.myProfile.copyWith(
          baseUser: AppAuth.myProfile.baseUser.copyWith(fullName: response),
        );
        await ChatPreferences.setMap(SStorageKeys.myProfile.name, newProfile.toMap());
        AppAuth.setProfileNull();
        update();
        //  context.pop();
      },
    );
  }

  void updateUserBio(BuildContext context) async {
    final newBio = await context.toPage(
      VSingleRename(
        appbarTitle: S.of(context).updateYourBio,
        subTitle: AppAuth.myProfile.userBio,
      ),
      withAnimation: false,
    );
    if (newBio == null || newBio.toString().isEmpty) return;
    vSafeApiCall<String>(
      onLoading: () {
        //  VAppAlert.showLoading(context: context);
      },
      request: () async {
        await profileApiService.updateUserBio(newBio);
        return newBio;
      },
      onSuccess: (response) async {
        final newProfile = AppAuth.myProfile.copyWith(bio: response);
        await ChatPreferences.setMap(SStorageKeys.myProfile.name, newProfile.toMap());
        AppAuth.setProfileNull();
        update();
        //context.pop();
      },
    );
  }

  void updateUserPassword(BuildContext context) async {
    await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SheetForUpdatePassword(),
    );
  }

  Future<void> deleteMyAccount(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).areYouSure,
      content: S.of(context).youAreAboutToDeleteYourAccountYourAccountWillNotAppearAgainInUsersList,
    );
    if (res == 1) {
      final passwordRes = await VAppAlert.showTextInputDialog(
        context: context,
        textFields: [
          DialogTextField(hintText: S.of(context).password, obscureText: true),
        ],
      );
      if (passwordRes == null) return;

      vSafeApiCall<void>(
        onLoading: () {
          VAppAlert.showLoading(context: context);
        },
        request: () async {
          await VChatController.I.profileApi.logout();
          await profileApiService.deleteMyAccount(passwordRes.first);
          AppAuth.setProfileNull();
          await ChatPreferences.clear();
        },
        onSuccess: (response) async {
          VChatController.I.navigatorKey.currentContext!.toPage(
            const SplashView(),
            withAnimation: false,
            removeAll: true,
          );
          AppAuth.setProfileNull();
        },
        onError: (exception, trace) {
          context.pop();
          if (exception == "invalidLoginData") {
            VAppAlert.showErrorSnackBar(message: S.of(context).invalidLoginData, context: context);
          } else {
            VAppAlert.showErrorSnackBar(message: exception, context: context);
          }
        },
      );
    }
  }
}
