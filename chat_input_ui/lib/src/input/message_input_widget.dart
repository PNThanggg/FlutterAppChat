import 'package:chat_core/chat_core.dart' hide ModelSheetItem;
import 'package:chat_mention_controller/chat_mention_controller.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:pasteboard/pasteboard.dart';
import 'package:place_picker_v2/entities/localization_item.dart';
import 'package:place_picker_v2/place_picker.dart';

import '../../chat_input_ui.dart';
import '../enums.dart';
import '../models/link_preview_data.dart';
import '../models/location_message_data.dart';
import '../models/message_voice_data.dart';
import '../permission_manager.dart';
import '../recorder/record_widget.dart';
import '../v_widgets/circle_avatar_widget.dart';
import '../v_widgets/input_ui_alert.dart';
import '../v_widgets/input_ui_picker.dart';
import 'widgets/emoji_keyboard.dart';
import 'widgets/link_preview_loader.dart';
import 'widgets/message_record_btn.dart';
import 'widgets/message_send_btn.dart';
import 'widgets/message_text_filed.dart';

///this widget used to render the footer of messages page
class VMessageInputWidget extends StatefulWidget {
  ///callback when user send text
  final Function(String message, VLinkPreviewData? previewData) onSubmitText;

  ///callback when user send images or videos or mixed
  final Function(List<VPlatformFile> files) onSubmitMedia;

  ///callback when user send files
  final Function(List<VPlatformFile> files) onSubmitFiles;

  ///callback when user send location will call only if [googleMapsApiKey] has value
  final Function(LocationMessageData data) onSubmitLocation;

  ///callback when user submit voice
  final Function(MessageVoiceData data) onSubmitVoice;

  ///callback when user start typing or recording or stop
  final Function(RoomTypingEnum typing) onTypingChange;

  ///callback when user clicked send attachment
  final Future<AttachEnumRes?> Function()? onAttachIconPress;

  ///callback if you want to implement custom mention item builder
  final Widget Function(MentionModel)? mentionItemBuilder;

  ///callback when user start add '@' or '@...' if text is empty that means the user just start type '@'
  final Future<List<MentionModel>> Function(String)? onMentionSearch;

  /// widget to render if user select to reply
  final Widget? replyWidget;

  /// should be true in web to let user directly start chat
  final bool autofocus;

  /// widget to render if the chat has been closed my be this user leave group or has banned!
  final Widget? stopChatWidget;

  /// set max timeout for recording
  final Duration maxRecordTime;

  ///set text filed focusNode
  final FocusNode? focusNode;

  ///if not provided the the user cant see the option of send location
  final String? googleMapsApiKey;

  ///text-field hint
  final VInputLanguage language;

  ///google maps localizations
  final String googleMapsLangKey;
  final String roomId;
  final bool isAllowSendMedia;

  ///set max upload files size default it 50 mb
  final int maxMediaSize;

  const VMessageInputWidget({
    super.key,
    required this.onSubmitText,
    required this.onSubmitMedia,
    required this.isAllowSendMedia,
    required this.roomId,
    required this.onSubmitVoice,
    required this.onSubmitFiles,
    required this.onSubmitLocation,
    required this.onTypingChange,
    this.maxMediaSize = 50 * 1024 * 1024,
    this.replyWidget,
    this.autofocus = false,
    this.focusNode,
    this.mentionItemBuilder,
    this.maxRecordTime = const Duration(minutes: 30),
    this.onAttachIconPress,
    this.stopChatWidget,
    this.onMentionSearch,
    this.googleMapsApiKey,
    this.language = const VInputLanguage(),
    this.googleMapsLangKey = "en",
  });

  @override
  State<VMessageInputWidget> createState() => _VMessageInputWidgetState();
}

class _VMessageInputWidgetState extends State<VMessageInputWidget> {
  bool _isEmojiShowing = false;
  String _text = "";
  RoomTypingEnum _typingType = RoomTypingEnum.stop;
  final VChatTextMentionController _textEditingController = VChatTextMentionController();
  FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeKeyboardHandler = FocusNode();

  bool get _isRecording => _typingType == RoomTypingEnum.recording;

  bool get _isTyping => _typingType == RoomTypingEnum.typing;

  bool get _isSendBottomEnable => _isTyping || _isRecording;
  final _recordStateKey = GlobalKey<RecordWidgetState>();
  bool _showMentionList = false;
  final _mentionsWithPhoto = <MentionModel>[];

  ///links
  VLinkPreviewData? _previewData;
  var _currentUrls = <Uri>[];
  Uri? _currentUrl;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    }
    _textEditingController.addListener(_textEditListener);
    _textEditingController.onSearch = (String? value) async {
      _mentionsWithPhoto.clear();
      if (value == null && _showMentionList) {
        setState(() {
          _showMentionList = false;
        });
        return;
      }
      if (widget.onMentionSearch != null && value != null) {
        final res = await widget.onMentionSearch!(value);
        if (res.isNotEmpty) {
          _mentionsWithPhoto.addAll(res);
          _showMentionList = true;
        } else {
          _showMentionList = false;
        }
        setState(() {});
      }
    };
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _isEmojiShowing = false;
        if (mounted) {
          setState(() {});
        }
      }
    });

    _focusNodeKeyboardHandler.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stopChatWidget != null) {
      _typingType = RoomTypingEnum.stop;
      _isEmojiShowing = false;
      _textEditingController.clear();
      _text = "";
      _currentUrls = [];
      _currentUrl = null;
      return widget.stopChatWidget!;
    }
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV): const _PasteIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyV): const _PasteIntent(),
        LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.enter): const _LineBreakIntent(),
        LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.enter): const _LineBreakIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const _EnterIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _PasteIntent: CallbackAction<_PasteIntent>(
            onInvoke: (_PasteIntent intent) async {
              Uint8List? bytes = await Pasteboard.image;

              if (bytes == null) {
                ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

                if (clipboardData == null) {
                  return false;
                }

                if (clipboardData.text == null) {
                  showToast(context, message: "No data in clipboard");
                }

                _textEditingController.text = clipboardData.text!;

                return false;
              }

              _sendWeChatImage(
                VPlatformFile.fromBytes(
                  name: "${DateTime.now().millisecondsSinceEpoch}.jpg",
                  bytes: bytes.toList(),
                ),
              );

              return true;
            },
          ),
          _EnterIntent: CallbackAction<_EnterIntent>(
            onInvoke: (_EnterIntent intent) async {
              _sendMessage(_textEditingController.text);

              return true;
            },
          ),
          _LineBreakIntent: CallbackAction<_LineBreakIntent>(
            onInvoke: (_LineBreakIntent intent) async {
              setState(() {
                _textEditingController.text += "\n";
              });

              return true;
            },
          ),
        },
        child: Focus(
          focusNode: _focusNodeKeyboardHandler,
          autofocus: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 6,
                            right: 6,
                          ),
                          decoration: context.vInputTheme.containerDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _showMentionList
                                  ? SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          if (widget.mentionItemBuilder != null) {
                                            return GestureDetector(
                                              onTap: () {
                                                _textEditingController.addMention(
                                                  MentionData(
                                                    id: _mentionsWithPhoto[index].peerId,
                                                    display: _mentionsWithPhoto[index].name,
                                                  ),
                                                );
                                              },
                                              child: widget.mentionItemBuilder!(
                                                _mentionsWithPhoto[index],
                                              ),
                                            );
                                          }
                                          return CupertinoListTile(
                                            leading: CircleAvatarWidget(
                                              fullUrl: _mentionsWithPhoto[index].imageS3,
                                              radius: 20,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onTap: () {
                                              _textEditingController.addMention(
                                                MentionData(
                                                  id: _mentionsWithPhoto[index].peerId,
                                                  display: _mentionsWithPhoto[index].name,
                                                ),
                                              );
                                            },
                                            title: _mentionsWithPhoto[index].name.h6,
                                          );
                                        },
                                        itemCount: _mentionsWithPhoto.length,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              _currentUrl != null
                                  ? LinkPreviewLoader(
                                      uri: _currentUrl!,
                                      roomId: widget.roomId,
                                      onGetData: (data) {
                                        _previewData = data;
                                      },
                                    )
                                  : const SizedBox.shrink(),
                              widget.replyWidget != null ? widget.replyWidget! : const SizedBox.shrink(),
                              _isRecording
                                  ? RecordWidget(
                                      key: _recordStateKey,
                                      onMaxTime: () async {
                                        widget.onSubmitVoice(
                                          await _recordStateKey.currentState!.stopRecord(),
                                        );
                                      },
                                      maxTime: widget.maxRecordTime,
                                      onCancel: () {
                                        _changeTypingType(RoomTypingEnum.stop);
                                      },
                                    )
                                  : MessageTextFiled(
                                      isAllowSendMedia: widget.isAllowSendMedia,
                                      autofocus: widget.autofocus,
                                      onDetectLink: (urls) {
                                        if (urls.isEmpty) {
                                          _previewData = null;
                                          _currentUrl = null;
                                        } else {
                                          _currentUrl = urls.last;
                                        }
                                        if (_currentUrls.isEmpty && urls.isEmpty) return;
                                        _currentUrls = urls;
                                        setState(() {});
                                      },
                                      focusNode: _focusNode,
                                      hint: widget.language.textFieldHint,
                                      isTyping: _typingType == RoomTypingEnum.typing,
                                      onSubmit: _sendMessage,
                                      textEditingController: _textEditingController,
                                      onShowEmoji: _showEmoji,
                                      onAttachFilePress: () => _onAttachFilePress(context, widget.language),
                                      onCameraPress: () => _onCameraPress(context),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      _isSendBottomEnable
                          ? MessageSendBtn(
                              onSend: () async {
                                if (_isRecording) {
                                  widget.onSubmitVoice(
                                    await _recordStateKey.currentState!.stopRecord(),
                                  );
                                  _changeTypingType(RoomTypingEnum.stop);
                                } else if (_text.isNotEmpty && _text.trim().isNotEmpty) {
                                  widget.onSubmitText(_textEditingController.markupText, _previewData);
                                  _text = "";
                                  _currentUrl = null;
                                  _currentUrls = [];
                                  _textEditingController.clear();
                                }
                              },
                            )
                          : MessageRecordBtn(
                              onRecordClick: () async {
                                if (VPlatforms.isDeskTop) {
                                  return;
                                }
                                final isAllowRecord = await PermissionManager.isAllowRecord();
                                if (isAllowRecord) {
                                  _changeTypingType(RoomTypingEnum.recording);
                                } else {
                                  final isAllowRecord = await PermissionManager.askForRecord();
                                  if (isAllowRecord) {
                                    _changeTypingType(RoomTypingEnum.recording);
                                  }
                                }
                              },
                            )
                    ],
                  ),
                ),
                EmojiKeyboard(
                  controller: _textEditingController,
                  isEmojiShowing: _isEmojiShowing,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      widget.onSubmitText(
        _textEditingController.markupText,
        _previewData,
      );
      _text = "";
      _currentUrl = null;
      _currentUrls = [];
      _textEditingController.clear();
      _changeTypingType(RoomTypingEnum.stop);
    }
  }

  Future<void> _showEmoji() async {
    _focusNode.unfocus();
    _focusNode.canRequestFocus = true;
    await Future.delayed(const Duration(milliseconds: 50));
    _isEmojiShowing = !_isEmojiShowing;
    setState(() {});
  }

  void _onAttachFilePress(BuildContext context, VInputLanguage language) async {
    late AttachEnumRes? res;
    if (widget.onAttachIconPress != null) {
      res = await widget.onAttachIconPress!();
    } else {
      final x = await InputUIAlert.showModalSheet(
        content: [
          ModelSheetItem<AttachEnumRes>(
            title: language.media,
            id: AttachEnumRes.media,
            iconData: const Icon(PhosphorIconsLight.image),
          ),
          ModelSheetItem<AttachEnumRes>(
            title: language.files,
            id: AttachEnumRes.files,
            iconData: const Icon(PhosphorIconsLight.file),
          ),
          if (widget.googleMapsApiKey != null && VPlatforms.isMobile)
            ModelSheetItem<AttachEnumRes>(
              title: language.location,
              iconData: const Icon(PhosphorIconsLight.mapPin),
              id: AttachEnumRes.location,
            ),
        ],
        context: context,
        title: language.shareMediaAndLocation,
        cancelText: language.cancel,
      );
      if (x == null) return null;
      res = x.id as AttachEnumRes;
    }
    if (res != null) {
      switch (res) {
        case AttachEnumRes.media:
          final files = await InputUiPicker.getMedia();
          if (files != null) {
            if (files.isNotEmpty) widget.onSubmitMedia(files);
          }
          break;
        case AttachEnumRes.files:
          final files = await InputUiPicker.getFiles();
          if (files != null) {
            final resFiles = _processFilesToSubmit(files);
            if (resFiles.isNotEmpty) widget.onSubmitFiles(files);
          }
          break;
        case AttachEnumRes.location:
          if (widget.googleMapsApiKey == null) return;
          final LocationResult? result = await context.toPage<LocationResult?>(
            PlacePicker(
              widget.googleMapsApiKey!,
              localizationItem: LocalizationItem(languageCode: widget.googleMapsLangKey),
            ),
          );
          if (result != null && result.latLng != null && result.latLng != null) {
            final location = LocationMessageData(
              latLng: latlong.LatLng(
                result.latLng!.latitude,
                result.latLng!.longitude,
              ),
              linkPreviewData: LinkPreviewData(
                title: result.name,
                desc: result.formattedAddress,
                link: "https://maps.google.com/?q=${result.latLng!.latitude},${result.latLng!.longitude}",
              ),
            );
            widget.onSubmitLocation(location);
          }
          break;
      }
    }
  }

  void _onCameraPress(BuildContext context) async {
    final isCameraAllowed = await PermissionManager.isCameraAllowed();
    if (!isCameraAllowed) {
      final x = await PermissionManager.askForCamera();
      if (!x) return;
    }
    final entity = await InputUiPicker.pickFromWeAssetCamera(
      onXFileCaptured: (p0, p1) {
        Navigator.pop(context);
        _sendWeChatImage(VPlatformFile.fromPath(
          fileLocalPath: p0.path,
        ));
        return true;
      },
      context: context,
    );

    if (entity == null) return;

    widget.onSubmitMedia(
      [
        entity,
      ],
    );
  }

  Future<void> _sendWeChatImage(VPlatformFile entity) async {
    widget.onSubmitMedia(
      [
        entity,
      ],
    );
  }

  void _textEditListener() {
    _text = _textEditingController.text;
    if (_text.isNotEmpty && _typingType != RoomTypingEnum.typing) {
      _changeTypingType(RoomTypingEnum.typing);
    } else if (_text.isEmpty && _typingType != RoomTypingEnum.stop) {
      _changeTypingType(RoomTypingEnum.stop);
    }
  }

  void _changeTypingType(RoomTypingEnum typingType) {
    if (typingType != _typingType) {
      setState(() {
        _typingType = typingType;
      });
      widget.onTypingChange(typingType);
    }
  }

  @override
  void dispose() {
    if (_typingType != RoomTypingEnum.stop) {
      widget.onTypingChange(RoomTypingEnum.stop);
    }
    _textEditingController.dispose();

    // _focusNode.dispose();
    _focusNodeKeyboardHandler.dispose();
    super.dispose();
  }

  List<VPlatformFile> _processFilesToSubmit(List<VPlatformFile> files) {
    final res = <VPlatformFile>[];
    for (final sourceFile in files) {
      if (sourceFile.fileSize > widget.maxMediaSize) {
        //this file should be ignored

        InputUIAlert.showErrorSnackBar(
          msg: widget.language.thereIsFileHasSizeBiggerThanAllowedSize,
          context: context,
        );
        continue;
      }
      res.add(sourceFile);
    }

    return res;
  }
}

class _PasteIntent extends Intent {
  const _PasteIntent();
}

class _EnterIntent extends Intent {
  const _EnterIntent();
}

class _LineBreakIntent extends Intent {
  const _LineBreakIntent();
}
