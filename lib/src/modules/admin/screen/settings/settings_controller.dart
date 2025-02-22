import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../main.dart';
import '../../admin.dart';

class SettingsController extends SLoadingController<AppConfigModel> {
  SettingsController()
      : super(
          LoadingState(
            AppConfigModel.init(),
          ),
        );

  final SAdminApiService _apiService = GetIt.I.get<SAdminApiService>();

  @override
  void onClose() {}

  @override
  void onInit() {
    getData();
  }

  BuildContext get context => navigatorKey.currentState!.context;

  void getData() async {
    vSafeApiCall<AppConfigModel>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return _apiService.getConfig();
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      onError: (exception, trace) {
        VAppAlert.showErrorSnackBar(message: exception, context: context);
      },
    );
  }

  void updateAllowCall(bool data) {
    value.data = value.data.copyWith(allowCall: data);
    submitForm();
  }

  void submitForm() {
    vSafeApiCall<AppConfigModel>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        await _apiService.updateConfig(value.data.toMap());
        return _apiService.getConfig();
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      onError: (exception, trace) {
        VAppAlert.showErrorSnackBar(message: exception, context: context);
      },
    );
  }

  void onUpdateFeedbackEmail() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).updateFeedBackEmail,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.feedbackEmail,
          keyboardType: TextInputType.emailAddress,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(feedbackEmail: res.first);
    submitForm();
  }

  void onUpdateMaxMessageForward() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).setMaxMessageForwardAndShare,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.maxForward.toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(maxForward: int.parse(res.first));
    submitForm();
  }

  void updateAllowMobileLogin(bool data) {
    value.data = value.data.copyWith(allowMobileLogin: data);
    submitForm();
  }

  void updateAllowWebLogin(bool data) {
    value.data = value.data.copyWith(allowWebLogin: data);
    submitForm();
  }

  void updateAllowDesktopLogin(bool data) {
    value.data = value.data.copyWith(allowDesktopLogin: data);
    submitForm();
  }

  void updateAllowCreateGroup(bool data) {
    value.data = value.data.copyWith(allowCreateGroup: data);
    submitForm();
  }

  void updateAllowCreateBroadcast(bool data) {
    value.data = value.data.copyWith(allowCreateBroadcast: data);
    submitForm();
  }

  void updateAllowSendMedia(bool data) {
    value.data = value.data.copyWith(allowSendMedia: data);
    submitForm();
  }

  void updateAllowAds(bool data) {
    value.data = value.data.copyWith(enableAds: data);
    submitForm();
  }

  void onUpdatePrivacyUrl() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).setNewPrivacyPolicyUrl,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.privacyUrl.toString(),
          keyboardType: TextInputType.url,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(privacyUrl: res.first);
    submitForm();
  }

  void onUpdateStoreUrls() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).appleStoreAppUrl,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.appleStoreUrl,
          hintText: "Apple Ios",
          keyboardType: TextInputType.url,
          maxLines: 3,
          minLines: 2,
          prefixText: "Apple Ios",
        ),
        DialogTextField(
          hintText: "Google Android",
          initialText: value.data.googlePayUrl,
          keyboardType: TextInputType.url,
          prefixText: "Google Android",
        ),
        DialogTextField(
            initialText: value.data.windowsStoreUrl,
            hintText: "Microsoft windows",
            keyboardType: TextInputType.url,
            prefixText: "Microsoft windows"),
        DialogTextField(
            hintText: "Apple macStoreUrl",
            initialText: value.data.macStoreUrl,
            keyboardType: TextInputType.url,
            prefixText: "Apple MacOs"),
        DialogTextField(
          hintText: "Web chat",
          initialText: value.data.webChatUrl,
          keyboardType: TextInputType.url,
          prefixText: "Web chat",
        ),
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(
      appleStoreUrl: res[0],
      googlePayUrl: res[1],
      windowsStoreUrl: res[2],
      macStoreUrl: res[3],
      webChatUrl: res[4],
    );
    submitForm();
  }

  void onUpdateAppleUrl() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).appleStoreAppUrl,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.appleStoreUrl.toString(),
          keyboardType: TextInputType.url,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(appleStoreUrl: res.first);
    submitForm();
  }

  void onUpdateGooglePlayUrl() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).googlePlayAppUrl,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.googlePayUrl.toString(),
          keyboardType: TextInputType.url,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(googlePayUrl: res.first);
    submitForm();
  }

  void onUpdateMaxExpireEmailTime() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).forgetPasswordExpireTime,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.maxExpireEmailTime.toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(maxExpireEmailTime: int.parse(res.first));
    submitForm();
  }

  void onUpdateCallTimeout() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).callTimeoutInSeconds,
      context: context,
      textFields: [
        DialogTextField(
          initialText: (value.data.callTimeout ~/ 1000).toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(callTimeout: int.parse(res.first) * 1000);
    submitForm();
  }

  void onUpdateMaxGroupMembers() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).setMaxGroupMembers,
      context: context,
      textFields: [
        DialogTextField(
          initialText: (value.data.maxGroupMembers).toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(maxGroupMembers: int.parse(res.first));
    submitForm();
  }

  void onUpdateMaxBroadcastMembers() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).setMaxBroadcastMembers,
      context: context,
      textFields: [
        DialogTextField(
          initialText: (value.data.maxBroadcastMembers).toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(maxBroadcastMembers: int.parse(res.first));
    submitForm();
  }

  void onUpdateAppName() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).name,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.appName,
          keyboardType: TextInputType.text,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(appName: res.first);
    submitForm();
  }

  void onUpdateUserRegisterStatus() {
    if (value.data.userRegisterStatus == "pending") {
      value.data = value.data.copyWith(userRegisterStatus: "accepted");
    } else {
      value.data = value.data.copyWith(userRegisterStatus: "pending");
    }
    submitForm();
  }
}
