import 'dart:async';

import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';

class PickUp extends StatefulWidget {
  const PickUp({
    super.key,
    required this.callModel,
    required this.localization,
  });

  final VNewCallModel callModel;
  final VCallLocalization localization;

  @override
  State<PickUp> createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  StreamSubscription? subscription;
  final _ringtonePlayer = FlutterRingtonePlayer();

  @override
  void initState() {
    super.initState();
    _playRingtone();
    _addListeners();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  VCircleAvatar(
                    vFileSource: VPlatformFile.fromUrl(
                      networkUrl: widget.callModel.peerUser.userImage,
                    ),
                    radius: 80,
                  ),
                  const SizedBox(height: 30.0),
                  widget.callModel.peerUser.fullName.text.color(Colors.white).bold.size(28),
                  const SizedBox(height: 5.0),
                  (widget.callModel.withVideo
                          ? widget.localization.incomingVideoCall
                          : widget.localization.incomingVoiceCall)
                      .text
                      .color(Colors.green)
                      .size(22),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.all(15.0),
                        color: CupertinoColors.systemGreen,
                        borderRadius: BorderRadius.circular(50.0),
                        onPressed: _acceptCall,
                        child: const Icon(
                          CupertinoIcons.phone_circle_fill,
                          color: CupertinoColors.white,
                          size: 35,
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.all(15.0),
                        color: CupertinoColors.systemRed,
                        borderRadius: BorderRadius.circular(50.0),
                        onPressed: () => _rejectCall(context),
                        child: const Icon(
                          CupertinoIcons.phone_down_circle_fill,
                          color: CupertinoColors.white,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestMicrophonePermission() async {
    final res = await [Permission.microphone].request();
    if (res[Permission.microphone] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> _requestCameraPermission() async {
    final res = await [Permission.microphone].request();
    if (res[Permission.camera] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  void _acceptCall() async {
    if (widget.callModel.withVideo) {
      if (!await _requestMicrophonePermission() && !await _requestCameraPermission() && !VPlatforms.isWeb) {
        VAppAlert.showErrorSnackBar(
          message: S.of(context).microphoneAndCameraPermissionMustBeAccepted,
          context: context,
        );
        return;
      }
    } else {
      if (!await _requestMicrophonePermission() && !VPlatforms.isWeb) {
        VAppAlert.showErrorSnackBar(
          message: S.of(context).microphonePermissionMustBeAccepted,
          context: context,
        );
        return;
      }
    }
    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 100));
    VChatController.I.vNavigator.callNavigator.toCall(
      VChatController.I.navigationContext,
      VCallDto(
        isVideoEnable: widget.callModel.withVideo,
        roomId: widget.callModel.roomId,
        peerUser: widget.callModel.peerUser,
        isCaller: false,
        meetId: widget.callModel.meetId,
      ),
    );
  }

  void _rejectCall(BuildContext context) async {
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.rejectCall(widget.callModel.meetId);
      },
      onSuccess: (_) {},
      onError: (exception, trace) async {
        VAppAlert.showErrorSnackBar(message: exception, context: context);
      },
    );
    context.pop();
  }

  @override
  void dispose() {
    _stopRingtone();
    subscription?.cancel();
    super.dispose();
  }

  void _playRingtone() async {
    if (VPlatforms.isMobile) {
      await _ringtonePlayer.playRingtone(
        looping: true,
        volume: 1.0,
        asAlarm: true,
      );
    }
  }

  void _stopRingtone() async {
    if (VPlatforms.isMobile) {
      await _ringtonePlayer.stop();
    }
  }

  void _addListeners() {
    subscription = VChatController.I.nativeApi.streams.callStream.listen(
      (e) async {
        if (e is VCallCanceledEvent) {
          Navigator.of(context).pop();
          return;
        }

        if (e is VCallTimeoutEvent) {
          Navigator.of(context).pop();
          return;
        }
      },
    );
  }
}
