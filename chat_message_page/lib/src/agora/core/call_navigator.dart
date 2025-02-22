import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pages/call/call_page.dart';
import '../pages/pick_up/pick_up.dart';

final vDefaultCallNavigator = VCallNavigator(
  toPickUp: (context, callModel) async {
    if (!VPlatforms.isMobile) return;

    context.toPage(
      PickUp(
        callModel: callModel,
        localization: VCallLocalization.fromEnglish(),
      ),
    );
  },
  toCall: (context, dto) async {
    if (!VPlatforms.isMobile) return;
    final micRes = await [Permission.microphone].request();
    if (dto.isVideoEnable) {
      final cameraRes = await [Permission.camera].request();
      if (cameraRes[Permission.camera] != PermissionStatus.granted) {
        VAppAlert.showErrorSnackBar(
          message: S.of(context).microphoneAndCameraPermissionMustBeAccepted,
          context: context,
        );
        return;
      }
    }
    if (micRes[Permission.microphone] != PermissionStatus.granted) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).microphonePermissionMustBeAccepted,
        context: context,
      );
      return;
    }
    context.toPage(
      VCallPage(
        dto: dto,
      ),
    );
  },
);
