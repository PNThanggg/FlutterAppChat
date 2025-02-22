import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart'; // Updated import
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../v_chat_message_page.dart';
import '../../core/agora_user.dart';
import '../../core/call_state.dart';
import '../widgets/agora_video_layout.dart';
import '../widgets/call_actions_row.dart';

class VCallPage extends StatefulWidget {
  final VCallDto dto;

  const VCallPage({
    super.key,
    required this.dto,
  });

  @override
  State<VCallPage> createState() => _VCallPageState();
}

class _VCallPageState extends State<VCallPage> {
  // Agora engine instance
  late final RtcEngine _agoraEngine;

  // Users in the call
  final _users = <AgoraUser>{};

  // View aspect ratio
  late double _viewAspectRatio;

  final value = CallState();

  String get channelName => widget.dto.roomId;
  int? _currentUid;

  StreamSubscription? callStream;

  bool get _callerIsVideoEnable => widget.dto.isVideoEnable;

  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  @override
  void initState() {
    super.initState();
    _initializeAgora();
    _addListeners();
    unawaited(WakelockPlus.enable());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CupertinoPageScaffold(
        backgroundColor: Colors.black,
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          middle: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VCircleAvatar(
                vFileSource: VPlatformFile.fromUrl(
                  url: widget.dto.peerUser.userImage,
                ),
                radius: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              widget.dto.peerUser.fullName.h6.color(Colors.white),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (value.status == CallStatus.accepted)
                StreamBuilder<int>(
                  initialData: 0,
                  stream: stopWatchTimer.rawTime,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const SizedBox.shrink();
                    }

                    return StopWatchTimer.getDisplayTime(
                      snapshot.data!,
                      hours: false,
                      milliSecond: false,
                      minute: true,
                      second: true,
                    ).h6.color(Colors.white);
                  },
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      final isPortrait = orientation == Orientation.portrait;
                      if (_users.isEmpty) {
                        return const SizedBox();
                      }
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => setState(() => _viewAspectRatio = isPortrait ? 2 / 3 : 3 / 2),
                      );
                      final layoutViews = _createLayout(_users.length);
                      return AgoraVideoLayout(
                        users: _users,
                        views: layoutViews,
                        viewAspectRatio: _viewAspectRatio,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: 360,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CallActionButton(
                        icon: value.isVideoEnabled
                            ? Icons.videocam_off_rounded
                            : Icons.videocam_rounded,
                        isEnabled: widget.dto.isVideoEnable,
                        onTap: widget.dto.isVideoEnable ? _onToggleCamera : null,
                      ),
                      CallActionButton(
                        icon: Icons.cameraswitch_rounded,
                        onTap: widget.dto.isVideoEnable ? _onSwitchCamera : null,
                        isEnabled: widget.dto.isVideoEnable,
                      ),
                      CallActionButton(
                        icon: value.isMicEnabled ? Icons.mic : Icons.mic_off,
                        isEnabled: true,
                        onTap: _onToggleMicrophone,
                      ),
                      CallActionButton(
                        icon: value.isSpeakerEnabled
                            ? CupertinoIcons.speaker_3
                            : CupertinoIcons.speaker_1,
                        onTap: _onToggleSpeaker,
                      ),
                      CallActionButton(
                        icon: Icons.call_end,
                        onTap: () {
                          context.pop();
                        },
                        radius: 30,
                        isEnabled: true,
                        backgroundColor: Colors.red,
                        iconSize: 28,
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopWatchTimer.dispose();
    WakelockPlus.disable();
    callStream?.cancel();
    _onCallEnd();
    super.dispose();
  }

  Future<void> _onCallEnd() async {
    await _agoraEngine.leaveChannel();
    await _agoraEngine.release(); // Updated from destroy to release
    await endCallApi();
  }

  Future<void> _initializeAgora() async {
    // Set aspect ratio for video according to platform
    if (kIsWeb) {
      _viewAspectRatio = 3 / 2;
    } else if (Platform.isAndroid || Platform.isIOS) {
      _viewAspectRatio = 2 / 3;
    } else {
      _viewAspectRatio = 3 / 2;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    final options = ChannelMediaOptions(
      publishMicrophoneTrack: true, // Replaces publishLocalAudio
      publishCameraTrack: widget.dto.isVideoEnable, // Replaces publishLocalVideo
    );

    // Join the channel
    final userToken = await VChatController.I.nativeApi.remote.calls.getAgoraAccess(channelName);
    await _agoraEngine.joinChannel(
      token: userToken,
      channelId: channelName,
      uid: 0,
      options: options,
    );

    if (widget.dto.isCaller) _createCall();
    if (widget.dto.meetId != null) _acceptCall();
  }

  Future<void> _initAgoraRtcEngine() async {
    _agoraEngine = createAgoraRtcEngine(); // Updated engine creation
    await _agoraEngine.initialize(
      const RtcEngineContext(
        appId: SConstants.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _agoraEngine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 1280, height: 720),
        frameRate: 30,
        bitrate: 0,
        orientationMode: OrientationMode.orientationModeAdaptive,
      ),
    );

    await _agoraEngine.enableAudio();

    if (_callerIsVideoEnable) {
      await _agoraEngine.enableVideo();
      value.isSpeakerEnabled = true;
      value.isVideoEnabled = true;
    }

    await _agoraEngine.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    ); // Updated method

    await _agoraEngine.muteLocalAudioStream(false); // Positional argument
    await _agoraEngine.setEnableSpeakerphone(_callerIsVideoEnable); // Positional argument
    await _agoraEngine.muteLocalVideoStream(!_callerIsVideoEnable); // Positional argument
  }

  Future<void> _addAgoraEventHandlers() async {
    _agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, String msg) {
          final info = 'LOG::onError: $err, $msg';
          debugPrint(info);
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          final info = 'LOG::onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
          debugPrint(info);
          setState(() {
            _currentUid = connection.localUid;
            _users.add(
              AgoraUser(
                uid: connection.localUid ?? 0,
                isAudioEnabled: value.isMicEnabled,
                isVideoEnabled: value.isVideoEnabled,
                view: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _agoraEngine,
                    canvas: VideoCanvas(uid: connection.localUid),
                  ),
                ),
              ),
            );
          });
        },
        // Updated event handlers with correct signatures
        onLocalAudioStateChanged: (
          RtcConnection connection,
          LocalAudioStreamState state,
          LocalAudioStreamReason reason,
        ) {
          // Handle local audio state changes if necessary
          debugPrint('LOG::onLocalAudioStateChanged: $state');
          setState(() {
            value.isMicEnabled = state != LocalAudioStreamState.localAudioStreamStateStopped;
          });
        },
        onFirstLocalVideoFrame: (VideoSourceType type, int width, int height, int elapsed) {
          debugPrint('LOG::firstLocalVideo');
          for (AgoraUser user in _users) {
            if (user.uid == _currentUid) {
              setState(
                () => user
                  ..isVideoEnabled = value.isVideoEnabled
                  ..view = AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _agoraEngine,
                      canvas: VideoCanvas(uid: _currentUid),
                    ),
                  ),
              );
            }
          }
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          debugPrint('LOG::onLeaveChannel');
          setState(() => _users.clear());
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          final info = 'LOG::userJoined: $remoteUid';
          debugPrint(info);
          setState(
            () => _users.add(
              AgoraUser(
                uid: remoteUid,
                view: AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: _agoraEngine,
                    canvas: VideoCanvas(uid: remoteUid),
                    connection: connection,
                  ),
                ),
              ),
            ),
          );
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          final info = 'LOG::userOffline: $remoteUid';
          debugPrint(info);
          AgoraUser? userToRemove;
          for (AgoraUser user in _users) {
            if (user.uid == remoteUid) {
              userToRemove = user;
              break;
            }
          }
          if (userToRemove != null) {
            setState(() => _users.remove(userToRemove));
          }
        },
        onFirstRemoteAudioFrame: (RtcConnection connection, int remoteUid, int elapsed) {
          final info = 'LOG::firstRemoteAudio: $remoteUid';
          debugPrint(info);
          for (AgoraUser user in _users) {
            if (user.uid == remoteUid) {
              setState(() => user.isAudioEnabled = true);
            }
          }
        },
        onFirstRemoteVideoFrame: (
          RtcConnection connection,
          int remoteUid,
          int width,
          int height,
          int elapsed,
        ) {
          final info = 'LOG::firstRemoteVideo: $remoteUid ${width}x$height';
          debugPrint(info);
          for (AgoraUser user in _users) {
            if (user.uid == remoteUid) {
              setState(
                () => user
                  ..isVideoEnabled = true
                  ..view = AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _agoraEngine,
                      canvas: VideoCanvas(uid: remoteUid),
                      connection: connection,
                    ),
                  ),
              );
            }
          }
        },
        onRemoteVideoStateChanged: (
          RtcConnection connection,
          int remoteUid,
          RemoteVideoState state,
          RemoteVideoStateReason reason,
          int elapsed,
        ) {
          final info = 'LOG::remoteVideoStateChanged: $remoteUid $state $reason';
          debugPrint(info);
          for (AgoraUser user in _users) {
            if (user.uid == remoteUid) {
              setState(() => user.isVideoEnabled =
                  state != RemoteVideoState.remoteVideoStateStopped &&
                      state != RemoteVideoState.remoteVideoStateFailed);
            }
          }
        },
        onRemoteAudioStateChanged: (
          RtcConnection connection,
          int remoteUid,
          RemoteAudioState state,
          RemoteAudioStateReason reason,
          int elapsed,
        ) {
          final info = 'LOG::remoteAudioStateChanged: $remoteUid $state $reason';
          debugPrint(info);
          for (AgoraUser user in _users) {
            if (user.uid == remoteUid) {
              setState(() => user.isAudioEnabled =
                  state != RemoteAudioState.remoteAudioStateStopped &&
                      state != RemoteAudioState.remoteAudioStateFailed);
            }
          }
        },
      ),
    );
  }

  List<int> _createLayout(int n) {
    int rows = (sqrt(n).ceil());
    int columns = (n / rows).ceil();

    List<int> layout = List<int>.filled(rows, columns);
    int remainingScreens = rows * columns - n;

    for (int i = 0; i < remainingScreens; i++) {
      layout[layout.length - 1 - i] -= 1;
    }
    return layout;
  }

  void _onToggleCamera() {
    setState(() {
      value.isVideoEnabled = !value.isVideoEnabled;
      for (AgoraUser user in _users) {
        if (user.uid == _currentUid) {
          user.isVideoEnabled = value.isVideoEnabled;
        }
      }
    });
    _agoraEngine.muteLocalVideoStream(!value.isVideoEnabled); // Positional argument
  }

  void _onToggleMicrophone() {
    setState(() {
      value.isMicEnabled = !value.isMicEnabled;
      for (AgoraUser user in _users) {
        if (user.uid == _currentUid) {
          user.isAudioEnabled = value.isMicEnabled;
        }
      }
    });
    _agoraEngine.muteLocalAudioStream(!value.isMicEnabled); // Positional argument
  }

  void _onToggleSpeaker() {
    setState(() {
      value.isSpeakerEnabled = !value.isSpeakerEnabled;
    });
    _agoraEngine.setEnableSpeakerphone(value.isSpeakerEnabled); // Positional argument
  }

  void _onSwitchCamera() => _agoraEngine.switchCamera();

  void _createCall() async {
    try {
      value.meetId = await VChatController.I.nativeApi.remote.calls.createCall(
        roomId: widget.dto.roomId,
        withVideo: widget.dto.isVideoEnable,
      );
    } catch (err) {
      VAppAlert.showErrorSnackBar(message: err.toString(), context: context);
      await Future.delayed(const Duration(milliseconds: 500));
      context.pop();
    }
  }

  /// Call this once you want to end the call but it must be started
  Future<void> endCallApi() async {
    final meetIdValue = widget.dto.meetId ?? value.meetId;
    if (meetIdValue == null) return;
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.endCallV2(meetIdValue);
      },
      onSuccess: (_) {},
      onError: (exception, trace) async {},
    );
  }

  void _addListeners() {
    callStream = VChatController.I.nativeApi.streams.callStream.listen(
      (e) async {
        if (e is VCallAcceptedEvent) {
          value.status = CallStatus.accepted;
          setState(() {});
          stopWatchTimer.onStartTimer();
          return;
        }
        if (e is VCallTimeoutEvent) {
          value.status = CallStatus.timeout;
          setState(() {});
          context.pop();
          return;
        }
        if (e is VCallEndedEvent) {
          value.status = CallStatus.callEnd;
          setState(() {});
          if (context.mounted) {
            context.pop();
          }
          return;
        }
        if (e is VCallRejectedEvent) {
          value.status = CallStatus.rejected;
          setState(() {});
          context.pop();
          return;
        }
      },
    );
  }

  void _acceptCall() async {
    await VChatController.I.nativeApi.remote.calls.acceptCall(
      meetId: widget.dto.meetId!,
    );
    stopWatchTimer.onStartTimer();
    setState(() {
      value.status = CallStatus.accepted;
    });
  }
}
