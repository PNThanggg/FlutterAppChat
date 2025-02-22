import 'package:flutter/foundation.dart';
import 'package:super_up_core/super_up_core.dart';

import '../api_service/api_service.dart';

class VAppConfigController {
  final ProfileApiService _profileApiService;

  VAppConfigController(this._profileApiService);

  Future<void> refreshAppConfig() async {
    await vSafeApiCall<AppConfigModel>(
      request: () async {
        return _profileApiService.appConfig();
      },
      onSuccess: (response) async {
        await VAppPref.setMap(
          SStorageKeys.appConfigModelData.name,
          response.toMap(),
        );
      },
      onError: (exception, trace) {
        if (kDebugMode) {
          print(exception);
          print(trace);
        }
      },
    );
  }

  static AppConfigModel get appConfig {
    final cachedConfig = VAppPref.getMap(SStorageKeys.appConfigModelData.name);
    try {
      if (cachedConfig != null) {
        return AppConfigModel.fromMap(cachedConfig);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    return AppConfigModel.init();
  }
}
