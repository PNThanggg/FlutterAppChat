import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:flutter/foundation.dart';

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
        await ChatPreferences.setMap(
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
    final cachedConfig = ChatPreferences.getMap(SStorageKeys.appConfigModelData.name);
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
