import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';
import '../controllers/admin_notification_controller.dart';

class AdminNotificationPage extends StatefulWidget {
  const AdminNotificationPage({super.key});

  @override
  State<AdminNotificationPage> createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> {
  late final AdminNotificationController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        middle: Text(
          S.of(context).adminNotification,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ValueListenableBuilder<SLoadingState<List<AdminNotificationsModel>>>(
          valueListenable: controller,
          builder: (_, value, ___) => VAsyncWidgetsBuilder(
            loadingState: value.loadingState,
            onRefresh: controller.getData,
            successWidget: () {
              return LoadMore(
                onLoadMore: controller.onLoadMore,
                isFinish: controller.isFinishLoadMore,
                textBuilder: (status) => "",
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
                          : GestureDetector(
                              onTap: () {
                                VChatController.I.vNavigator.messageNavigator.toImageViewer(
                                  context,
                                  VPlatformFile.fromUrl(
                                    url: value.data[index].imageUrl!,
                                  ),
                                  true,
                                );
                              },
                              child: VCircleAvatar(
                                vFileSource: VPlatformFile.fromUrl(url: value.data[index].imageUrl!),
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
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AdminNotificationController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
