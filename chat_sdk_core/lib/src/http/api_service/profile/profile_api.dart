import 'dart:io';

import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart';

part 'profile_api.chopper.dart';

@ChopperApi(baseUrl: 'profile')
abstract class ProfileApi extends ChopperService {
  ///add fcm
  @POST(path: "/push")
  Future<Response> addNotificationPush(@Body() Map<String, dynamic> body);

  ///delete fcm
  @DELETE(path: "/push")
  Future<Response> deleteNotificationPush();

  @GET(path: "/users/{peerId}/last-seen", optionalBody: true)
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
