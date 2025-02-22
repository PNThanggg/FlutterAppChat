import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../../../core/models/story/story_model.dart';
import '../../../../story/view/story_view.dart';
import '../controllers/story_tab_controller.dart';
import 'package:s_translation/generated/l10n.dart';

import 'widgets/story_widget.dart';

class StoryTabView extends StatefulWidget {
  const StoryTabView({super.key});

  @override
  State<StoryTabView> createState() => _StoryTabViewState();
}

class _StoryTabViewState extends State<StoryTabView> {
  late final StoryTabController controller;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<StoryTabController>();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              S.of(context).stories,
            ),
          )
        ],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// MyStory
              ValueListenableBuilder<SLoadingState<StoryTabState>>(
                valueListenable: controller,
                builder: (_, value, __) {
                  return StoryWidget(
                    isMe: true,
                    toCreateStory: () {
                      controller.toCreateStory(context);
                    },
                    isLoading: value.data.isMyStoriesLoading,
                    onTap: (storyModel) {
                      if (storyModel.stories.isEmpty) return;
                      context.toPage(
                        StoryViewpage(
                          storyModel: storyModel,
                          onComplete: (current) {},
                        ),
                      );
                    },
                    storyModel: value.data.myStories,
                    onLongTap: (UserStoryModel storyModel) {},
                  );
                },
              ),

              S.of(context).recentUpdate.cap,

              Expanded(
                child: ValueListenableBuilder<SLoadingState<StoryTabState>>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    return VAsyncWidgetsBuilder(
                      loadingState: value.loadingState,
                      onRefresh: controller.getStories,
                      successWidget: () {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            return StoryWidget(
                              isMe: false,
                              onLongTap: (storyModel) {},
                              onTap: (storyModel) {
                                if (storyModel.stories.isEmpty) return;
                                context.toPage(
                                  StoryViewpage(
                                    storyModel: storyModel,
                                    onComplete: _onStoryComplete,
                                  ),
                                );
                              },
                              storyModel: value.data.allStories[index],
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 1,
                          ),
                          itemCount: value.data.allStories.length,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _onStoryComplete(UserStoryModel current) async {
    final index = controller.data.allStories.indexOf(current);
    if (index == -1) return;
    context.toPage(
      StoryViewpage(
        storyModel: controller.data.allStories[index + 1],
        onComplete: _onStoryComplete,
      ),
    );
  }
}
