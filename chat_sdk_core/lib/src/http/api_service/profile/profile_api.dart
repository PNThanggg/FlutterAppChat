import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

part 'profile_api.chopper.dart';

@ChopperApi(baseUrl: 'profile')
abstract class ProfileApi extends ChopperService {
  ///add fcm
  @Post(path: "/push")
  Future<Response> addNotificationPush(@Body() Map<String, dynamic> body);

  ///delete fcm
  @Delete(path: "/push")
  Future<Response> deleteNotificationPush();

  @Get(path: "/users/{peerId}/last-seen", optionalBody: true)
  Future<Response> getLastSeenAt(
    @Path("peerId") String peerId,
  );

  static ProfileApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$ProfileApi(),
      ],
      converter: const JsonConverter(),
      //, HttpLoggingInterceptor()
      interceptors: [AuthInterceptor()],
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
