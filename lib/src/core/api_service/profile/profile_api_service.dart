import 'package:chat_config/chat_constants.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart' hide ProfileApi, throwIfNotSuccess, extractDataFromResponse;

import '../../../modules/home/settings_modules/my_account/views/sheet_for_update_password.dart';
import '../../../modules/peer_profile/states/peer_profile_state.dart';
import '../../dto/create_report_dto.dart';
import '../../models/user_device_model.dart';
import '../interceptors.dart';
import 'profile_api.dart';

class ProfileApiService {
  static ProfileApi? _profileApi;

  ProfileApiService._();

  Future<String> updateImage(VPlatformFile img) async {
    final res = await _profileApi!.updateImage(
      await VPlatforms.getMultipartFile(
        source: img,
      ),
    );
    throwIfNotSuccess(res);
    return res.body['data'] as String;
  }

  Future<void> updatePassword(UpdatePasswordDto dto) async {
    final res = await _profileApi!.updatePassword(dto.toMap());
    throwIfNotSuccess(res);
  }

  Future<SVersion> checkVersion(String current) async {
    final res = await _profileApi!.checkVersion({"semVer": current});
    throwIfNotSuccess(res);
    return SVersion.fromMap(extractDataFromResponse(res));
  }

  Future<bool> setVisit() async {
    final res = await _profileApi!.setVisit();
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> createReport(CreateReportDto data) async {
    final res = await _profileApi!.createReport(data.toMap());
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> deleteDevice(String id, String password) async {
    final res = await _profileApi!.deleteDevice(
      id,
      {"password": password},
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> deleteMyAccount(String password) async {
    final res = await _profileApi!.deleteMyAccount(
      {"password": password},
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<List<UserDeviceModel>> getMyDevices() async {
    final res = await _profileApi!.device();
    throwIfNotSuccess(res);
    final l = (res.body as Map<String, dynamic>)['data'] as List;
    return l.map((e) => UserDeviceModel.fromMap(e)).toList();
  }

  Future<List<BaseUser>> getMyBlocked({
    VBaseFilter? filter,
  }) async {
    final res = await _profileApi!.myBlocked(filter?.toMap() ?? {});
    throwIfNotSuccess(res);
    final l = (res.body as Map<String, dynamic>)['data']['docs'] as List;
    return l.map((e) => BaseUser.fromMap(e['targetId'])).toList();
  }

  Future<bool> updatePrivacy(UserPrivacy userPrivacy) async {
    final res = await _profileApi!.updatePrivacy(userPrivacy.toMap());
    throwIfNotSuccess(res);
    return true;
  }

  Future<List<AdminNotificationsModel>> getMyAdminNotifications({
    VBaseFilter? filter,
  }) async {
    final res = await _profileApi!.adminNotifications(filter?.toMap() ?? {});
    throwIfNotSuccess(res);
    final l = (res.body as Map<String, dynamic>)['data']['docs'] as List;
    return l.map((e) => AdminNotificationsModel.fromMap(e)).toList();
  }

  Future<bool> updateUserBio(String bio) async {
    final res = await _profileApi!.updateUserBio({"bio": bio});
    throwIfNotSuccess(res);

    return true;
  }

  Future<bool> updateUserName(String fullName) async {
    final res = await _profileApi!.updateUserName({"fullName": fullName});
    throwIfNotSuccess(res);

    return true;
  }

  Future<MyProfile> getMyProfile() async {
    final res = await _profileApi!.myProfile();
    throwIfNotSuccess(res);
    return MyProfile.fromMap(extractDataFromResponse(res));
  }

  Future<bool> passwordCheck(String password) async {
    final res = await _profileApi!.passwordCheck({"password": password});
    throwIfNotSuccess(res);
    return true;
  }

  Future<PeerProfileModel> peerProfile(String peerId) async {
    final res = await _profileApi!.peerProfile(peerId);
    throwIfNotSuccess(res);
    return PeerProfileModel.fromMap(res.body['data'] as Map<String, dynamic>);
  }

  Future<AppConfigModel> appConfig() async {
    final res = await _profileApi!.appConfig();
    throwIfNotSuccess(res);
    return AppConfigModel.fromMap(res.body['data'] as Map<String, dynamic>);
  }

  Future<List<SearchUser>> appUsers(UserFilterDto dto) async {
    final res = await _profileApi!.appUsers(dto.toMap());
    throwIfNotSuccess(res);
    return (extractDataFromResponse(res)['docs'] as List)
        .map(
          (e) => SearchUser.fromMap(e),
        )
        .toList();
  }

  static ProfileApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _profileApi ??= ProfileApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? ChatConstants.sApiBaseUrl,
    );
    return ProfileApiService._();
  }
}
