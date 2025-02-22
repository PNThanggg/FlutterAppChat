import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../admin.dart';

class NotificationsController extends SLoadingController<List<AdminNotificationsModel>> {
  NotificationsController()
      : super(
          LoadingState(
            [],
          ),
        );

  final SAdminApiService adminApi = GetIt.I.get<SAdminApiService>();

  @override
  void onInit() {
    getData();
  }

  @override
  void onClose() {}

  Future<void> getData() async {
    await vSafeApiCall(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return adminApi.getNotifications();
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
        return response;
      },
      onError: (exception, trace) {
        if (kDebugMode) {
          print(exception);
          print(trace);
        }
      },
    );
  }

  void onShowCreateNotificationsAlert(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: CreateNotificationAlert(),
        );
      },
    );
    await getData();
  }
}

class CreateNotificationAlert extends StatefulWidget {
  const CreateNotificationAlert({super.key});

  @override
  State<CreateNotificationAlert> createState() => _CreateNotificationAlertState();
}

class _CreateNotificationAlertState extends State<CreateNotificationAlert> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final adminApi = GetIt.I.get<SAdminApiService>();
  VPlatformFile? vPlatformFile;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VImagePicker(
          onDone: (VPlatformFile file) {
            setState(() {
              vPlatformFile = file;
            });
          },
          initImage: vPlatformFile ??
              VPlatformFile.fromAssets(
                assetsPath: "assets/ss.png",
              ),
          withCrop: false,
          size: 120,
        ),
        const SizedBox(
          height: 30,
        ),
        STextFiled(
          controller: titleController,
          textHint: S.of(context).notificationTitle,
          autofocus: true,
        ),
        const SizedBox(
          height: 30,
        ),
        STextFiled(
          controller: descController,
          textHint: S.of(context).notificationDescription,
          autofocus: true,
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(onPressed: _createNotify, child: Text(S.of(context).create))
      ],
    );
  }

  void _createNotify() async {
    if (titleController.text.isEmpty) {
      VAppAlert.showErrorSnackBar(message: S.of(context).titleIsRequired, context: context);
      return;
    }
    if (descController.text.isEmpty) {
      VAppAlert.showErrorSnackBar(message: S.of(context).descriptionIsRequired, context: context);
      return;
    }
    await vSafeApiCall(
      onLoading: () {
        VAppAlert.showLoading(context: context);
      },
      request: () async {
        return adminApi.createNotifications(
          title: titleController.text,
          desc: descController.text,
          img: vPlatformFile,
        );
      },
      onSuccess: (response) {
        context.pop();
        context.pop();
      },
      onError: (exception, trace) {
        if (kDebugMode) {
          print(exception);
          print(trace);
        }
      },
    );
  }
}
