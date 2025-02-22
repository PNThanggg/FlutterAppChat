import 'dart:io';

import 'package:chat_config/chat_constants.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';

import '../interceptors.dart';

part 'profile_api.chopper.dart';

@ChopperApi(baseUrl: 'profile')
abstract class ProfileApi extends ChopperService {
  ///update image
  @PATCH(path: '/image')
  @multipart
  Future<Response> updateImage(
    @PartFile("file") MultipartFile file,
  );

  @PATCH(path: '/version')
  Future<Response> checkVersion(@Body() Map<String, dynamic> body);

  ///update name
  @PATCH(path: "/name")
  Future<Response> updateUserName(@Body() Map<String, dynamic> body);

  @PATCH(path: "/password")
  Future<Response> updatePassword(@Body() Map<String, dynamic> body);

  ///update name
  @PATCH(path: "/bio")
  Future<Response> updateUserBio(@Body() Map<String, dynamic> body);

  @PATCH(path: "/visit", optionalBody: true)
  Future<Response> setVisit();

  @POST(path: "/report")
  Future<Response> createReport(@Body() Map<String, dynamic> body);

  @GET(path: "/device")
  Future<Response> device();

  @PATCH(path: "/privacy")
  Future<Response> updatePrivacy(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: "/admin-notifications")
  Future<Response> adminNotifications(
    @QueryMap() Map<String, dynamic> query,
  );

  @DELETE(path: "/device/{id}")
  Future<Response> deleteDevice(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: "/delete-my-account")
  Future<Response> deleteMyAccount(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: "/blocked")
  Future<Response> myBlocked(
    @QueryMap() Map<String, dynamic> query,
  );

  @GET(path: "/")
  Future<Response> myProfile();

  @POST(path: "/password-check")
  Future<Response> passwordCheck(@Body() Map<String, dynamic> body);

  @GET(path: "/{id}")
  Future<Response> peerProfile(@Path("id") String id);

  @GET(path: "/app-config")
  Future<Response> appConfig();

  @GET(path: "/users")
  Future<Response> appUsers(
    @QueryMap() Map<String, dynamic> query,
  );

  static ProfileApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: ChatConstants.sApiBaseUrl,
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
