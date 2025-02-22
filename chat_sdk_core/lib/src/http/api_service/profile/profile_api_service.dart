import 'package:chat_sdk_core/chat_sdk_core.dart';

class VProfileApiService {
  static ProfileApi? _profileApi;

  VProfileApiService._();

  Future<bool> addFcm(String fcm) async {
    final res = await _profileApi!.addNotificationPush(
      {'pushKey': fcm},
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> deleteFcm() async {
    final res = await _profileApi!.deleteNotificationPush();
    throwIfNotSuccess(res);
    return true;
  }

  Future<DateTime?> getUserLastSeenAt(String peerId) async {
    final res = await _profileApi!.getLastSeenAt(peerId);
    throwIfNotSuccess(res);
    final str = (res.body as Map<String, dynamic>)['data'] as String?;
    if (str == null) return null;
    return DateTime.parse(str);
  }

  static VProfileApiService init({Uri? baseUrl, String? accessToken}) {
    _profileApi ??= ProfileApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VProfileApiService._();
  }
}
