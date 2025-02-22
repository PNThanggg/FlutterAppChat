import 'package:sqflite/sqlite_api.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_platform/v_platform.dart';

class NativeLocalApiCache {
  late final BaseLocalApiCacheRepo _apiCacheRepo;

  NativeLocalApiCache(Database? database) {
    if (VPlatforms.isWeb) {
      _apiCacheRepo = ApiCacheMemoryImp();
    } else {
      _apiCacheRepo = ApiCacheSqlImp(database!);
    }
  }

  Future<int> insertToApiCache(ApiCacheModel model) async {
    return _apiCacheRepo.insert(model);
  }

  Future<ApiCacheModel?> getOneApiCache(String endPoint) async {
    return _apiCacheRepo.getOneByEndPoint(endPoint);
  }
}
