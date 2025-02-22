import 'package:chat_core/chat_core.dart' hide AutoDirection;
import 'package:chat_input_ui/src/models/v_input_theme.dart';
import 'package:chat_mention_controller/chat_mention_controller.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../v_widgets/auto_direction.dart';

class MessageTextFiled extends StatefulWidget {
  final VChatTextMentionController textEditingController;
  final FocusNode focusNode;
  final bool isTyping;
  final bool autofocus;
  final bool isAllowSendMedia;
  final String hint;
  final VoidCallback onShowEmoji;
  final VoidCallback onCameraPress;
  final VoidCallback onAttachFilePress;
  final Function(String value) onSubmit;
  final Function(List<Uri> urls) onDetectLink;

  const MessageTextFiled({
    super.key,
    required this.textEditingController,
    required this.focusNode,
    required this.isAllowSendMedia,
    required this.onShowEmoji,
    required this.onCameraPress,
    required this.onAttachFilePress,
    required this.onDetectLink,
    required this.isTyping,
    required this.autofocus,
    required this.hint,
    required this.onSubmit,
  });

  @override
  State<MessageTextFiled> createState() => _MessageTextFiledState();
}

class _MessageTextFiledState extends State<MessageTextFiled> {
  String txt = "";
  int lines = 1;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(_lineListener);
  }

  @override
  void dispose() {
    widget.textEditingController.removeListener(_lineListener);
    super.dispose();
  }

  bool get isMultiLine => lines != 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.end : CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 4,
        ),
        GestureDetector(
          onTap: widget.onShowEmoji,
          child: Padding(
            padding: isMultiLine ? const EdgeInsets.only(bottom: 6) : EdgeInsets.zero,
            child: context.vInputTheme.emojiIcon,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: AutoDirection(
            text: txt,
            child: CupertinoTextField(
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 4,
              ),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              placeholder: widget.hint,
              textCapitalization: TextCapitalization.sentences,
              controller: widget.textEditingController,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              onChanged: (value) {
                setState(() {
                  txt = value;
                });
                if (value.isNotEmpty) {
                  _urlMatcher(widget.textEditingController.text);
                }
              },
              style: context.isDark
                  ? context.vInputTheme.textFieldTextStyle.copyWith(
                      color: Colors.white,
                    )
                  : context.vInputTheme.textFieldTextStyle,
              minLines: 1,
              maxLines: 5,
              textAlignVertical: TextAlignVertical.top,
              onSubmitted: (value) {
                if (VPlatforms.isMobile) {
                  return;
                }

                if (value.isNotEmpty) {
                  widget.onSubmit(value);
                }
                widget.focusNode.requestFocus();
                widget.textEditingController.clear();
              },
              textInputAction: !VPlatforms.isMobile ? null : TextInputAction.newline,
              keyboardType: TextInputType.multiline,
            ),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Visibility(
          visible: !widget.isTyping,
          child: Padding(
            padding: isMultiLine ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
            child: Row(
              children: [
                if (VPlatforms.isMobile)
                  GestureDetector(
                    onTap: !widget.isAllowSendMedia ? null : widget.onCameraPress,
                    child: context.vInputTheme.cameraIcon,
                  ),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: !widget.isAllowSendMedia ? null : widget.onAttachFilePress,
          child: Padding(
            padding: isMultiLine ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
            child: context.vInputTheme.fileIcon,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }

  void _lineListener() {
    final count = widget.textEditingController.text.split('\n').length;
    if (lines != count) {
      setState(() {
        lines = count;
      });
    }
  }

  final RegExp _urlDetectReg = RegExp(
    r"(http(s)?://.)?(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_+.~#?&/=]*)",
    caseSensitive: false,
    dotAll: true,
  );

  void _urlMatcher(String txt) {
    final allMatches = _urlDetectReg.allMatches(txt);
    if (allMatches.isEmpty) {
      widget.onDetectLink(<Uri>[]);
      return;
    }
    final list = <Uri>[];
    for (final e in allMatches) {
      final group = e.group(0);
      if (group != null && Uri.tryParse(group) != null) {
        list.add(
          Uri.parse(ensureHttpPrefix(group)),
        );
      }
    }
    widget.onDetectLink(list);
  }

  String ensureHttpPrefix(String url) {
    if (!url.startsWith(RegExp(r'https?://'))) {
      return 'https://$url';
    }
    return url;
  }
}
