import 'package:permission_handler/permission_handler.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/agora/pages/pick_up/pick_up.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../v_chat_message_page.dart';
import '../pages/call/call_page.dart';

final vDefaultCallNavigator = VCallNavigator(
  toPickUp: (context, callModel) async {
    if (!VPlatforms.isMobile) return;
    context.toPage(PickUp(
      callModel: callModel,
      localization: VCallLocalization.fromEnglish(),
    ));
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
