import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'notifications_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final controller = NotificationsController();

  @override
  void initState() {
    controller.onInit();
    super.initState();
  }

  final sizer = GetIt.I.get<AppSizeHelper>();

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sizer.isWide(context)
          ? AppBar(
              title: S.of(context).notificationsPage.h5,
              centerTitle: true,
            )
          : null,
      floatingActionButton: FloatingActionButton(
        child: const Icon(CupertinoIcons.add),
        onPressed: () => controller.onShowCreateNotificationsAlert(context),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, value, ___) {
            final loadingState = controller.loadingState;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  alignment: Alignment.topCenter,
                  constraints: sizer.isWide(context) ? BoxConstraints(maxWidth: context.width * .6) : null,
                  child: Card(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: loadingState == ChatLoadingState.loading,
                            child: const LinearProgressIndicator(),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(10),
                              itemBuilder: (context, index) {
                                return CupertinoListTile(
                                  padding: EdgeInsets.zero,
                                  title: Text(value.data[index].title),
                                  subtitle: Text(
                                    value.data[index].content,
                                    maxLines: 50,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  leadingSize: 50,
                                  leading: value.data[index].imageUrl == null
                                      ? null
                                      : VCircleAvatar(
                                          vFileSource: VPlatformFile.fromUrl(
                                            networkUrl: value.data[index].imageUrl!,
                                          ),
                                        ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  thickness: .7,
                                  color: Colors.grey.withOpacity(.5),
                                  height: 15,
                                );
                              },
                              itemCount: value.data.length,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
