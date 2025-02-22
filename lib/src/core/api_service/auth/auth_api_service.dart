import 'package:flutter/foundation.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../dto/reset_password_dto.dart';
import '../interceptors.dart';
import 'auth_api.dart';

class AuthApiService {
  AuthApiService._();

  static AuthApi? _authApi;

  Future<void> login(LoginDto dto) async {
    final body = dto.toMap();
    final response = await _authApi!.login(body);
    throwIfNotSuccess(response);
    await VAppPref.setHashedString(
      SStorageKeys.vAccessToken.name,
      extractDataFromResponse(response)['accessToken'].toString(),
    );
  }

  Future sendResetPasswordEmailOtp(String email) async {
    final response = await _authApi!.sendOtpResetPassword({"email": email});
    throwIfNotSuccess(response);
  }

  Future verifyAndResetPassword(ResetPasswordDto dto) async {
    final response = await _authApi!.verifyAndResetPassword(dto.toMap());
    throwIfNotSuccess(response);
  }

  Future<void> register(RegisterDto dto) async {
    final body = dto.toListOfPartValue();
    final response = await _authApi!.register(
      body,
      dto.image == null
          ? null
          : await VPlatforms.getMultipartFile(
              source: dto.image!,
            ),
    );
    throwIfNotSuccess(response);
    await VAppPref.setHashedString(
      SStorageKeys.vAccessToken.name,
      extractDataFromResponse(response)['accessToken'].toString(),
    );
  }

  static AuthApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _authApi ??= AuthApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? SConstants.sApiBaseUrl,
    );
    return AuthApiService._();
  }

  Future<bool> logout({required bool isLogoutFromAll}) async {
    final response = await _authApi!.logout(
      {
        "logoutFromAll": isLogoutFromAll,
      },
    );
    throwIfNotSuccess(response);
    return true;
  }
}
