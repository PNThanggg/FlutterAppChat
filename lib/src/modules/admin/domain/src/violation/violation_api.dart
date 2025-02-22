import 'dart:io';

import 'package:chat_platform/v_platform.dart';
import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart';

import '../interceptors.dart';

part 'violation_api.chopper.dart';

@ChopperApi(baseUrl: 'violation-text')
abstract class ViolationApi extends ChopperService {
  static ViolationApi create({
    required Uri baseUrl,
    String? accessToken,
    Map<String, String>? headers,
  }) {
    final client = ChopperClient(
      baseUrl: baseUrl,
      services: [
        _$ViolationApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        ViolationInterceptor(),
      ],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 15),
            ),
    );
    return _$ViolationApi(client);
  }

  @GET(path: "/")
  Future<Response> getAllViolation();

  @POST(path: "/create")
  Future<Response> addViolation(
    @Body() Map<String, String> body,
  );

  @DELETE(path: "/{id}")
  Future<Response> deleteViolation(
    @Path("id") String id,
  );
}
