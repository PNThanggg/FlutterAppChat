import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../interceptors.dart';

part 'story_api.chopper.dart';

@ChopperApi(baseUrl: 'user-story')
abstract class StoryApi extends ChopperService {
  @Post(path: "/")
  @multipart
  Future<Response> createStory(
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
  );

  @Delete(path: "/{id}", optionalBody: true)
  Future<Response> deleteStory(@Path("id") String id);

  @Get(path: "/")
  Future<Response> getUsersStories(@QueryMap() Map<String, dynamic> query);

  @Post(path: "/views/{id}")
  Future<Response> setSeen(@Path("id") String id);

  @Get(path: "/me")
  Future<Response> getMyStories();

  @Post(path: "/views/{id}", optionalBody: true)
  Future<Response> addViewToStory();

  @Get(path: "/views/{id}")
  Future<Response> getStoryViews(@QueryMap() Map<String, dynamic> query);

  static StoryApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: SConstants.sApiBaseUrl,
      services: [
        _$StoryApi(),
      ],
      converter: const JsonConverter(),
      //, HttpLoggingInterceptor()
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 10),
            ),
    );
    return _$StoryApi(client);
  }
}
