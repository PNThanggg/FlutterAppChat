import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/calls_tab_controller.dart';
import 'call_item.dart';

class CallsTabView extends StatefulWidget {
  const CallsTabView({super.key});

  @override
  State<CallsTabView> createState() => _CallsTabViewState();
}

class _CallsTabViewState extends State<CallsTabView> {
  late final CallsTabController controller;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<CallsTabController>();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            border: const Border(bottom: BorderSide.none),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            largeTitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                S.of(context).calls.h3.bold.color(Theme.of(context).textTheme.bodyLarge!.color!).size(32),
                InkWell(
                  onTap: () => controller.clearCalls(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: S.of(context).clear.b2.bold.color(Colors.grey),
                  ),
                ),
              ],
            ),
          )
        ],
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50, top: 10),
                child: ValueListenableBuilder<LoadingState<List<VCallHistory>>>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    return VAsyncWidgetsBuilder(
                      loadingState: value.loadingState,
                      onRefresh: controller.getCalls,
                      successWidget: () {
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                          itemBuilder: (context, index) {
                            return CallItem(
                              callHistory: value.data[index],
                              onLongPress: () => controller.onLongPress(context, value.data[index]),
                              onPress: () {
                                VChatController.I.roomApi.openChatWith(
                                  peerId: value.data[index].peerUser.id,
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            height: 10,
                            thickness: 1,
                            color: Colors.grey.withOpacity(.2),
                          ),
                          itemCount: value.data.length,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
