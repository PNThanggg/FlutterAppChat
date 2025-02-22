import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';

import '../core/api_service/api_service.dart';
import '../core/api_service/story/story_api_service.dart';
import '../core/app_config/app_config_controller.dart';
import '../core/controllers/version_checker_controller.dart';
import '../modules/app/controller/app_controller.dart';

abstract class AppDi {
  static void inject() {
    GetIt.I.registerSingleton<AuthApiService>(AuthApiService.init());
    GetIt.I.registerSingleton<AppController>(AppController());
    GetIt.I.registerSingleton<StoryApiService>(StoryApiService.init());
    final ProfileApiService profileApiService = ProfileApiService.init();
    GetIt.I.registerSingleton<ProfileApiService>(profileApiService);
    GetIt.I.registerSingleton<AppSizeHelper>(AppSizeHelper());
    GetIt.I.registerSingleton<VAppConfigController>(
      VAppConfigController(profileApiService),
    );

    GetIt.I.registerSingleton<VersionCheckerController>(
      VersionCheckerController(profileApiService),
    );
  }
}
