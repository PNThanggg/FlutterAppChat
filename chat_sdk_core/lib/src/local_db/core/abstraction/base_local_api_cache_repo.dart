import 'package:chat_sdk_core/chat_sdk_core.dart';

abstract class BaseLocalApiCacheRepo {
  Future<int> insert(ApiCacheModel model);

  Future<ApiCacheModel?> getOneByEndPoint(String endpoint);

  Future<void> reCreate();
}
