import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:super_up/src/modules/home/settings_modules/test_notification/test_notification_screen.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../../main.dart';
import '../../../../../core/app_config/app_config_controller.dart';
import '../../../../../core/controllers/version_checker_controller.dart';
import '../../../../app/controller/app_controller.dart';
import '../../../../splash/views/splash_view.dart';
import '../states/setting_state.dart';
import '../views/media_storage_settings.dart';
import '../views/sheet_for_choose_language.dart';

class SettingsTabController extends SLoadingController<SettingState> {
  SettingsTabController()
      : super(
          SLoadingState(
            SettingState(
              isDarkMode: VAppPref.getStringOrNullKey(
                    SStorageKeys.appTheme.name,
                  ) ==
                  ThemeMode.dark.name,
              language: VAppPref.getStringOrNullKey(
                    SStorageKeys.appLanguageTitle.name,
                  ) ??
                  "English",
              inAppAlerts: VAppPref.getBoolOrNull(
                    SStorageKeys.inAppAlerts.name,
                  ) ??
                  true,
            ),
          ),
        );
  final versionCheckerController = GetIt.I.get<VersionCheckerController>();
  final appConfig = VAppConfigController.appConfig;

  @override
  void onClose() {}

  @override
  void onInit() {}

  Future<void> logout(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).areYouSure,
      content: "${S.of(context).yourAreAboutToLogoutFromThisAccount} ${AppAuth.myProfile.baseUser.fullName}",
    );
    if (res == 1) {
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
          context.toPage(
            const SplashView(),
            withAnimation: false,
            removeAll: true,
          );
          GetIt.I.get<AppController>().reset();
          // AdminDI.uninject();
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

  Future<void> testNotification(BuildContext context) async {
    context.toPage(const TestNotificationScreen());
  }

  Future<void> onThemeChange(BuildContext context) async {
    final newTheme = !value.data.isDarkMode;
    value.data = value.data.copyWith(isDarkMode: newTheme);
    //update the flutter cupertino theme
    CupertinoTheme.of(navigatorKey.currentState!.context)
        .copyWith(brightness: newTheme ? Brightness.dark : Brightness.light);
    VThemeListener.I.setTheme(newTheme == false ? ThemeMode.light : ThemeMode.dark);
    notifyListeners();
  }

  FutureOr<void> onLanguageChange(BuildContext context) async {
    final res = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SheetForChooseLanguage(),
    ) as ModelSheetItem?;
    if (res == null) {
      return;
    }
    value.data = value.data.copyWith(language: res.title);
    await VLanguageListener.I.setLocal(Locale(res.id.toString()));
    await VAppPref.setStringKey(
      SStorageKeys.appLanguageTitle.name,
      res.title,
    );
    notifyListeners();
  }

  FutureOr<void> checkForUpdates(BuildContext context) async {
    await versionCheckerController.checkForUpdates(context, true);
  }

  FutureOr<void> onChangeAppNotifications(BuildContext context) async {
    final options = <ModelSheetItem>[
      ModelSheetItem<bool>(
        title: S.of(context).on,
        id: true,
      ),
      ModelSheetItem<bool>(
        title: S.of(context).off,
        id: false,
      ),
    ];
    final res = await VAppAlert.showModalSheetWithActions(
      content: options,
      context: navigatorKey.currentState!.context,
    ) as ModelSheetItem<bool>?;
    if (res == null) return;
    value.data = value.data.copyWith(inAppAlerts: res.id);
    notifyListeners();
    await VAppPref.setBool(
      SStorageKeys.inAppAlerts.name,
      res.id,
    );
    final pushService = await VChatController.I.vChatConfig.currentPushProviderService;
    if (pushService == null) return null;

    if (res.id) {
      ///enable
      final token = await pushService.getToken(
        VPlatforms.isWeb ? SConstants.webVapidKey : null,
      );
      if (token == null) return;
      await VChatController.I.nativeApi.remote.profile.addFcm(token);
    } else {
      await pushService.deleteToken();
      await VChatController.I.nativeApi.remote.profile.deleteFcm();
    }
  }

  Future<void> clearDatabase() async {
    Database? database = await DBProvider.instance.database;

    if (database != null) {
      DBProvider.instance.reCreateTables(database);
    }
  }

  FutureOr<void> onStorageClick(BuildContext context) async {
    if (VPlatforms.isMobile) {
      context.toPage(const MediaStorageSettings());
      return;
    }
    VAppAlert.showOkAlertDialog(
      context: context,
      title: S.of(context).dataPrivacy,
      content: S.of(context).allDataHasBeenBackupYouDontNeedToManageSaveTheDataByYourself,
    );
  }

  FutureOr<void> tellAFriend(BuildContext context) async {
    await Share.share('''
    
    Install ${SConstants.appName}
    
    ANDROID
    ${appConfig.googlePayUrl}
    
    IOS
    ${appConfig.appleStoreUrl}
    
    WEB
    ${appConfig.webChatUrl}
    
    ''');
  }
}
