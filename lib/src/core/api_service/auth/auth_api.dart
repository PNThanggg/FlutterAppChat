import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../interceptors.dart';

part 'auth_api.chopper.dart';

@ChopperApi(baseUrl: 'auth')
abstract class AuthApi extends ChopperService {
  @Post(path: "/login")
  Future<Response> login(@Body() Map<String, dynamic> body);

  ///send-otp-reset-password
  @Post(path: "/send-otp-reset-password")
  Future<Response> sendOtpResetPassword(@Body() Map<String, dynamic> body);

  ///verify-and-reset-password
  @Post(path: "/verify-and-reset-password")
  Future<Response> verifyAndResetPassword(@Body() Map<String, dynamic> body);

  @Post(path: "/register")
  @multipart
  Future<Response> register(
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
  );

  @Post(path: "/logout")
  Future<Response> logout(@Body() Map<String, dynamic> body);

  static AuthApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: SConstants.sApiBaseUrl,
      services: [
        _$AuthApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        AuthInterceptor(),
      ],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 7),
            ),
    );
    return _$AuthApi(client);
  }
}
