import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../interceptors.dart';

part 'profile_api.chopper.dart';

@ChopperApi(baseUrl: 'profile')
abstract class ProfileApi extends ChopperService {
  ///update image
  @Patch(path: '/image')
  @multipart
  Future<Response> updateImage(
    @PartFile("file") MultipartFile file,
  );

  @Patch(path: '/version')
  Future<Response> checkVersion(@Body() Map<String, dynamic> body);

  ///update name
  @Patch(path: "/name")
  Future<Response> updateUserName(@Body() Map<String, dynamic> body);

  @Patch(path: "/password")
  Future<Response> updatePassword(@Body() Map<String, dynamic> body);

  ///update name
  @Patch(path: "/bio")
  Future<Response> updateUserBio(@Body() Map<String, dynamic> body);

  @Patch(path: "/visit", optionalBody: true)
  Future<Response> setVisit();

  @Post(path: "/report")
  Future<Response> createReport(@Body() Map<String, dynamic> body);

  @Get(path: "/device")
  Future<Response> device();

  @Patch(path: "/privacy")
  Future<Response> updatePrivacy(
    @Body() Map<String, dynamic> body,
  );

  @Get(path: "/admin-notifications")
  Future<Response> adminNotifications(
    @QueryMap() Map<String, dynamic> query,
  );

  @Delete(path: "/device/{id}")
  Future<Response> deleteDevice(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: "/delete-my-account")
  Future<Response> deleteMyAccount(
    @Body() Map<String, dynamic> body,
  );

  @Get(path: "/blocked")
  Future<Response> myBlocked(
    @QueryMap() Map<String, dynamic> query,
  );

  @Get(path: "/")
  Future<Response> myProfile();

  @Post(path: "/password-check")
  Future<Response> passwordCheck(@Body() Map<String, dynamic> body);

  @Get(path: "/{id}")
  Future<Response> peerProfile(@Path("id") String id);

  @Get(path: "/app-config")
  Future<Response> appConfig();

  @Get(path: "/users")
  Future<Response> appUsers(
    @QueryMap() Map<String, dynamic> query,
  );

  static ProfileApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: SConstants.sApiBaseUrl,
      services: [
        _$ProfileApi(),
      ],
      converter: const JsonConverter(),
      //, HttpLoggingInterceptor()
      interceptors: [
        AuthInterceptor(),
      ],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 15),
            ),
    );
    return _$ProfileApi(client);
  }
}
