import 'dart:async';

import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_html/html.dart';

import '../api_service/profile/profile_api_service.dart';
import '../app_config/app_config_controller.dart';

class VersionCheckerController extends ValueNotifier<SVersion> {
  final ProfileApiService profileApiService;

  VersionCheckerController(this.profileApiService)
      : super(
          SVersion.empty(),
        );

  Future<SVersion> _check() async {
    final res = await vSafeApiCall<SVersion>(
      request: () async {
        final packageInfo = await PackageInfo.fromPlatform();
        final version = packageInfo.version;
        return profileApiService.checkVersion(version);
      },
      onSuccess: (response) {
        return response;
      },
      onError: (exception, trace) {
        if (kDebugMode) {
          print(exception);
        }
      },
    );
    value = res ?? SVersion.empty();
    return value;
  }

  Future<void> lunchUpdate() async {
    if (VPlatforms.isAndroid) {
      await VStringUtils.lunchLink(VAppConfigController.appConfig.googlePayUrl);
    }
    if (VPlatforms.isIOS) {
      await VStringUtils.lunchLink(VAppConfigController.appConfig.appleStoreUrl);
    }
    if (VPlatforms.isWeb) {
      window.location.reload();
    }
    if (VPlatforms.isMacOs) {
      await VStringUtils.lunchLink(VAppConfigController.appConfig.macStoreUrl);
    }
    if (VPlatforms.isWindows) {
      await VStringUtils.lunchLink(
        VAppConfigController.appConfig.windowsStoreUrl,
      );
    }
  }

  FutureOr<void> checkForUpdates(
    BuildContext context,
    bool showAlert,
  ) async {
    final version = await _check();
    if (!version.isNeedUpdates) {
      if (showAlert) {
        VAppAlert.showSuccessSnackBar(
          message: S.of(context).noUpdatesAvailableNow,
          context: context,
        );
      }
      return;
    }
    if (version.isCritical) {
      await VAppAlert.showOkAlertDialog(
        context: context,
        title: S.of(context).newUpdateIsAvailable,
        content: "${S.of(context).weHighRecommendToDownloadThisUpdate} ${version.serverVersion}",
      );
      await lunchUpdate();
      return;
    }
    if (!showAlert) return;
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).newUpdateIsAvailable,
      content: "${version.notes} ${version.serverVersion}",
    );
    if (res == 1) {
      await lunchUpdate();
    }
    return null;
  }
}
