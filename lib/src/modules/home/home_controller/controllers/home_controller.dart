import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_receive_share/v_chat_receive_share.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../core/controllers/version_checker_controller.dart';
import '../../mobile/calls_tab/controllers/calls_tab_controller.dart';
import '../../mobile/rooms_tab/controllers/rooms_tab_controller.dart';
import '../../mobile/story_tab/controllers/story_tab_controller.dart';
import '../../mobile/telegram_tab/controllers/telegram_tab_controller.dart';
import '../../mobile/users_tab/controllers/users_tab_controller.dart';

class HomeController extends SLoadingController<int> {
  final ProfileApiService profileApiService;
  final BuildContext context;

  HomeController(this.profileApiService, this.context) : super(SLoadingState(0));

  int totalChatUnRead = 0;
  final versionCheckerController = GetIt.I.get<VersionCheckerController>();

  int get tabIndex => data;

  IconData fabIcon = Icons.message;

  late final StreamSubscription _unReadStream;

  @override
  void onInit() {
    _registerLazySingletons();
    _connectToVChatSdk();
    _checkVersion();
    _updateProfile();
    _unReadStream = VChatController.I.nativeApi.streams.totalUnreadRoomsCountStream.listen((event) {
      totalChatUnRead = event.count;
      notifyListeners();
    });
  }

  @override
  void onClose() {
    _unregister();
    _unReadStream.cancel();
  }

  void _connectToVChatSdk() async {
    await VChatController.I.profileApi.connect();
    vInitReceiveShareHandler();
    _setVisit();
    if (VPlatforms.isMobile) {
      vInitCallListener(context);
    }
  }

  void _setVisit() async {
    vSafeApiCall(
      request: () async {
        return profileApiService.setVisit();
      },
      onSuccess: (response) {},
      ignoreTimeoutAndNoInternet: true,
    );
  }

  void _checkVersion() async {
    await versionCheckerController.checkForUpdates(context, false);
  }

  void _registerLazySingletons() {
    GetIt.I.registerLazySingleton<CallsTabController>(
      () => CallsTabController(),
    );

    GetIt.I.registerLazySingleton<UsersTabController>(
      () => UsersTabController(GetIt.I.get<ProfileApiService>()),
    );

    GetIt.I.registerLazySingleton<StoryTabController>(
      () => StoryTabController(),
    );
    GetIt.I.registerLazySingleton<RoomsTabController>(
      () => RoomsTabController(),
    );
    GetIt.I.registerLazySingleton<TelegramTabController>(
      () => TelegramTabController(),
    );
  }

  void _unregister() {
    GetIt.I.get<RoomsTabController>().onClose();
    GetIt.I.get<TelegramTabController>().onClose();
    GetIt.I.get<CallsTabController>().onClose();
    GetIt.I.get<UsersTabController>().onClose();
    GetIt.I.unregister<CallsTabController>();
    GetIt.I.unregister<StoryTabController>();
    GetIt.I.unregister<UsersTabController>();
    GetIt.I.unregister<RoomsTabController>();
    GetIt.I.unregister<TelegramTabController>();
  }

  void _updateProfile() async {
    final newProfile = await profileApiService.getMyProfile();
    await VAppPref.setMap(SStorageKeys.myProfile.name, newProfile.toMap());
    AppAuth.setProfileNull();
  }
}
