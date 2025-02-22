import 'dart:developer';

import 'package:chat_config/chat_constants.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/app_config/app_config_controller.dart';
import '../states/help_state.dart';

class HelpController extends SLoadingController<HelpState> {
  HelpController()
      : super(
          LoadingState(HelpState()),
        );

  bool isOpeningChat = false;
  final appConfig = VAppConfigController.appConfig;

  @override
  void onClose() {}

  @override
  void onInit() {
    getAppVersion();
  }

  void openChatWith(BuildContext context) async {
    vSafeApiCall(
      onLoading: () {
        isOpeningChat = true;
        notifyListeners();
      },
      request: () async {
        await VChatController.I.roomApi.openChatWith(
          peerId: "peerId",
        );
      },
      onSuccess: (response) {
        isOpeningChat = false;
        notifyListeners();
      },
      onError: (exception, trace) {
        isOpeningChat = false;
        notifyListeners();
      },
    );
  }

  Future<void> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;
      value.data.version = "$version+$buildNumber";
      update();
    } catch (err) {
      log(err.toString());
    }
  }

  Future<void> onEmailContact(BuildContext context) async {
    if (!await launchUrl(Uri.parse(
      "mailto:${appConfig.feedbackEmail}?subject=${ChatConstants.appName}&body= ",
    ))) {
      throw Exception('Could not launch  ');
    }
  }

  Future<void> onPrivacy(BuildContext context) async {
    if (!await launchUrl(Uri.parse(appConfig.privacyUrl))) {
      throw Exception('Could not launch  ');
    }
  }
}
