import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart';
import 'package:v_platform/v_platform.dart';

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

  @Get(path: "/")
  Future<Response> getAllViolation();

  @Post(path: "/create")
  Future<Response> addViolation(
    @Body() Map<String, String> body,
  );

  @Delete(path: "/{id}")
  Future<Response> deleteViolation(
    @Path("id") String id,
  );
}
