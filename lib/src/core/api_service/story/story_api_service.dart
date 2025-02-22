import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../models/story/create_story_dto.dart';
import '../../models/story/story_model.dart';
import '../interceptors.dart';
import 'story_api.dart';

class StoryApiService {
  static StoryApi? _storyApi;

  StoryApiService._();

  Future<void> createStory(CreateStoryDto dto) async {
    final body = dto.toListOfPartValue();
    final res = await _storyApi!.createStory(
      body,
      dto.image == null
          ? null
          : await VPlatforms.getMultipartFile(
              source: dto.image!,
            ),
    );
    throwIfNotSuccess(res);
  }

  Future<void> setSeen(String id) async {
    final res = await _storyApi!.setSeen(id);
    throwIfNotSuccess(res);
  }

  Future<List<UserStoryModel>> getUsersStories({
    int page = 1,
    int limit = 30,
  }) async {
    final res = await _storyApi!.getUsersStories({
      "page": page,
      "limit": limit,
    });
    throwIfNotSuccess(res);
    return (extractDataFromResponse(res)['docs'] as List).map((e) => UserStoryModel.fromMap(e)).toList();
  }

  Future<UserStoryModel?> getMyStories() async {
    final res = await _storyApi!.getMyStories();
    throwIfNotSuccess(res);
    final l = extractDataFromResponse(res)['docs'] as List;
    if (l.isEmpty) return null;
    return UserStoryModel.fromMap(l.first);
  }

  static StoryApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _storyApi ??= StoryApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? SConstants.sApiBaseUrl,
    );
    return StoryApiService._();
  }
}
