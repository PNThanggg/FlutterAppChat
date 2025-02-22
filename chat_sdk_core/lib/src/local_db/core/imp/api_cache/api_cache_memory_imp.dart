import 'package:chat_sdk_core/chat_sdk_core.dart';

class ApiCacheMemoryImp extends BaseLocalApiCacheRepo {
  @override
  Future<ApiCacheModel?> getOneByEndPoint(String endpoint) {
    return Future.value();
  }

  @override
  Future<int> insert(ApiCacheModel model) {
    return Future.value(1);
  }

  @override
  Future<void> reCreate() {
    return Future.value();
  }
}
