import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:v_platform/v_platform.dart';

import '../interceptors.dart';

part 's_admin_api.chopper.dart';

@ChopperApi(baseUrl: 'admin-panel')
abstract class SAdminApi extends ChopperService {
  @Get(path: "/dashboard")
  Future<Response> dashboard();

  @Get(path: "/config")
  Future<Response> config();

  @Patch(path: "/config")
  Future<Response> updateConfig(@Body() Map<String, dynamic> body);

  @Post(path: "/login")
  Future<Response> login();

  @Get(path: "/users")
  Future<Response> getDashUsers(
    @QueryMap() Map<String, dynamic> body,
  );

  @Get(path: "/notifications")
  Future<Response> getNotifications();

  @Post(path: '/notifications')
  @multipart
  Future<Response> createNotifications(
    @PartFile("file") MultipartFile? file,
    @PartMap() List<PartValue> body,
  );

  @Patch(path: "/user/info/{id}")
  Future<Response> updateUserData(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @Get(path: "/user/info/{id}")
  Future<Response> getUserInfo(
    @Path("id") String id,
  );

  @Get(path: "/users/all-staff")
  Future<Response> getAllStaff();

  @Put(path: "/users/toggle-staff/{id}")
  Future<Response> toggleStaff(
    @Path("id") String id,
  );

  static SAdminApi create({
    required Uri baseUrl,
    String? accessToken,
    Map<String, String>? headers,
  }) {
    final client = ChopperClient(
      baseUrl: baseUrl,
      services: [
        _$SAdminApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        //AuthInterceptor(headers: headers),
        SAdminHeaderKeySetterInterceptor(),
      ],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 15),
            ),
    );
    return _$SAdminApi(client);
  }
}
