import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/material.dart';

class CreateGroupController extends ValueNotifier implements BaseController {
  final List<BaseUser> users;
  final Function(VRoom) onDone;
  final txtController = TextEditingController();
  final focusNode = FocusNode();
  ChatLoadingState loadingState = ChatLoadingState.ideal;

  CreateGroupController(this.users, this.onDone) : super(null);

  VPlatformFile? image;
  bool isCreating = false;

  Future<void> createGroup(BuildContext context) async {
    final title = txtController.text;
    if (title.isEmpty) {
      VAppAlert.showErrorSnackBar(message: S.of(context).titleIsRequired, context: context);
      return;
    }
    await vSafeApiCall<VRoom>(
      onLoading: () async {
        isCreating = true;
        notifyListeners();
      },
      onError: (exception, trace) {
        isCreating = false;
        notifyListeners();
        VAppAlert.showErrorSnackBar(
          message: exception,
          context: context,
        );
      },
      request: () async {
        final room = await VChatController.I.roomApi.createGroup(
          dto: CreateGroupDto(
            peerIds: users.map((e) => e.id).toList(),
            title: title,
            platformImage: image,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        return room;
      },
      onSuccess: (response) {
        isCreating = false;
        notifyListeners();
        onDone(response);
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  @override
  void onClose() {
    txtController.dispose();
    focusNode.dispose();
  }

  bool get isEmpty => txtController.value.text.isEmpty;

  @override
  void onInit() {
    focusNode.requestFocus();
    txtController.addListener(() {
      notifyListeners();
    });
  }
}
