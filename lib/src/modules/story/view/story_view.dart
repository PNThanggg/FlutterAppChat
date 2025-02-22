import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../core/api_service/story/story_api_service.dart';
import '../../../core/models/story/story_model.dart';
import '../../../core/utils/enums.dart';
import '../../peer_profile/views/peer_profile_view.dart';

class StoryViewpage extends StatefulWidget {
  final UserStoryModel storyModel;
  final Function(UserStoryModel current)? onComplete;

  const StoryViewpage({
    super.key,
    required this.storyModel,
    required this.onComplete,
  });

  @override
  State<StoryViewpage> createState() => _StoryViewpageState();
}

class _StoryViewpageState extends State<StoryViewpage> {
  final controller = StoryController();

  final stories = <StoryItem>[];
  late StoryModel current = widget.storyModel.stories.first;
  final _api = GetIt.I.get<StoryApiService>();

  @override
  void initState() {
    _parseStories();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          StoryView(
            onComplete: () {
              context.pop();
              widget.onComplete?.call(widget.storyModel);
            },
            onStoryShow: (storyItem, index) {
              int pos = stories.indexOf(storyItem);
              current = widget.storyModel.stories[pos];
              unawaited(_setSeen(current.id));
              if (pos == 0) return;
              setState(() {});
            },
            storyItems: stories,
            controller: controller,
          ),
          Positioned(
            top: 25,
            left: 10,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (widget.storyModel.userData.isMe) return;
                    context.toPage(
                      PeerProfileView(peerId: widget.storyModel.userData.id),
                    );
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      VCircleAvatar(
                        vFileSource: VPlatformFile.fromUrl(
                          url: widget.storyModel.userData.userImage,
                        ),
                        radius: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.storyModel.userData.fullName.text.black.color(Colors.white),
                          const SizedBox(
                            height: 3,
                          ),
                          format(
                            DateTime.parse(current.createdAt),
                            locale: Localizations.localeOf(context).languageCode,
                          ).cap.color(Colors.white),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _setSeen(String id) async {
    vSafeApiCall(
      request: () async {
        await _api.setSeen(current.id);
      },
      onSuccess: (response) {},
    );
  }

  void _parseStories() {
    for (final story in widget.storyModel.stories) {
      if (story.storyType == StoryType.image) {
        stories.add(
          StoryItem.pageImage(
            url: VPlatformFile.fromUrl(url: story.att!['url']!).url!,
            controller: controller,
            caption: story.caption == null ? null : Text(story.caption!),
            duration: const Duration(seconds: 7),
            imageFit: BoxFit.contain,
          ),
        );
        continue;
      }
      if (story.storyType == StoryType.text) {
        stories.add(
          StoryItem.text(
            title: story.content,
            duration: const Duration(seconds: 10),
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontStyle: story.fontType == StoryFontType.italic ? FontStyle.italic : null,
              textBaseline: TextBaseline.alphabetic,
              fontWeight: story.fontType == StoryFontType.bold ? FontWeight.bold : null,
            ),
            backgroundColor: story.colorValue == null ? Colors.green : Color(story.colorValue!),
          ),
        );
        continue;
      }
    }
  }
}
